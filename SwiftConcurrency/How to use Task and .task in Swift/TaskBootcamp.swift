//
//  TaskBootcamp.swift
//  SwiftConcurrency
//
//  Created by Dostan Turlybek on 29.05.2025.
//
import SwiftUI

class TaskBootcampViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    
    
    func fetchImage() async {
//        for x in someArray{
//            //конечно .task может прерватся сам, НО если у нас есть тяжелая работа допустим через for loop оно занимает достатончо времени.
//            //для того что бы его остановаить нужно использовть
//            try Task.checkCancellation()
//        }
        
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        do {
            guard let url = URL(string: "https://picsum.photos/200") else {return}
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            
            await MainActor.run {
                self.image = UIImage(data: data) //Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates. Если не закинтуь в mainActor потому что нельзя обновлять UI с бекраунд thred
            }
            
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        do {
            guard let url = URL(string: "https://picsum.photos/200") else {return}
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run {
                self.image2 = UIImage(data: data)
            }
        } catch  {
            print(error.localizedDescription)
        }
    }
}

struct TackBootcampHomeView: View {
    var body: some View {
        NavigationStack{
            ZStack{
                NavigationLink("Press this link") {
                    TaskBootcamp() // проблема task то что оно работает даже если мы выдем стого view где оно запустилось. Это можно исправть использовав
                }
            }
        }
    }
}

struct TaskBootcamp: View {
    
    @StateObject private var vm: TaskBootcampViewModel = TaskBootcampViewModel()
    
    @State private var fetchImageTask: Task<(), Never>? = nil
    
    var body: some View{
        VStack(spacing: 40){
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit( )
                    .frame(width: 200, height: 200)
            }
            
            if let image = vm.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit( )
                    .frame(width: 200, height: 200)
            }
        }
        .onDisappear{
            fetchImageTask?.cancel()
        }
        .onAppear {
//            Task { // так задания будут выполнятся по очереди ассихронно
//                await vm.fetchImage()
//                await vm.fetchImage2()
//            }
            
            //{ Два таска запустятся сразу и будут выполнятся асихронно однавременно
            self.fetchImageTask = Task {
                await vm.fetchImage()
                
                Task {
                    await vm.fetchImage2()
                }
            }
            
            
            //}
            
//            Task (priority: .low, operation: {
//                await Task.yield() //"Я пока жду, можешь выполнить другие задачи, а потом вернись ко мне."
//                print("LOW: \(Thread.current) : \(Task.currentPriority)")
//            })
//            
//            Task (priority: .medium) {
//                print("MEDIUM: \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task (priority: .high) {
//                print("High: \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task (priority: .background) {
//                print("background: \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task (priority: .utility) {
//                print("utility: \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task (priority: .userInitiated) {
//                print("userInitiated: \(Thread.current) : \(Task.currentPriority)")
//            }
            
        }
    }
}

struct TaskBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        TackBootcampHomeView()
    }
}
