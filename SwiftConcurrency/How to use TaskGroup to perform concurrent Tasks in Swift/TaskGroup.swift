//
//  TaskGroup.swift
//  SwiftConcurrency
//
//  Created by Dostan Turlybek on 31.05.2025.
//
import SwiftUI

class TaskGroupDataManager {
    
    func fetchImageWithAsyncLet() async throws-> [UIImage]{
        
        async let fetchImage1 = fetchImage(urlString: "https://picsum.photos/200")
        async let fetchImage2 = fetchImage(urlString: "https://picsum.photos/200")
        async let fetchImage3 = fetchImage(urlString: "https://picsum.photos/200")
        async let fetchImage4 = fetchImage(urlString: "https://picsum.photos/200")
        
        let (image1, image2, image3, image4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
        return [image1, image2, image3, image4]
    }
    
    func fetchImagesWithTaskGroup() async throws -> [UIImage] {
        let urlStrings: [String] = Array(repeating: "https://picsum.photos/300", count: 25)
        
        return try await withThrowingTaskGroup(of: UIImage.self) { group in
            var images: [UIImage] = []
            
            for urlString in urlStrings {
                group.addTask {
                    try await self.fetchImage(urlString: urlString)
                }
            }
            
//            group.addTask {
//                try await self.fetchImage(urlString: "https://picsum.photos/200")
//            }
//            group.addTask {
//                try await self.fetchImage(urlString: "https://picsum.photos/200")
//            }
//            group.addTask {
//                try await self.fetchImage(urlString: "https://picsum.photos/200")
//            }
//            group.addTask {
//                try await self.fetchImage(urlString: "https://picsum.photos/200")
//            }
//            group.addTask {
//                try await self.fetchImage(urlString: "https://picsum.photos/200")
//            }
            
            for try await taskResult in group {
                images.append(taskResult)
            }
            
            return images
        }
    }
    
    private func fetchImage(urlString: String) async throws -> UIImage{
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
}

class TaskGroupClass: ObservableObject {
    @Published var images: [UIImage] = []
    let manager = TaskGroupDataManager()
    
    func getImages() async {
        if let images = try? await manager.fetchImagesWithTaskGroup() {
            self.images.append(contentsOf: images)
        }
    }
}

struct TaskGroup: View {
    
    @StateObject private var vm: TaskGroupClass = TaskGroupClass()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack{
            ScrollView{
                LazyVGrid(columns: columns) {
                    ForEach(vm.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Async Let Bootcamp")
            .task {
                await vm.getImages()
            }
        }
    }
}

struct TaskGroup_Previews: PreviewProvider {
    static var previews: some View {
        TaskGroup()
    }
}
