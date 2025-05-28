//
//  diwaa.swift
//  SwiftConcurrency
//
//  Created by Dostan Turlybek on 27.05.2025.
//

import SwiftUI
import Combine

class diwaaImageLoader {
    
    let url = URL(string: "https://picsum.photos/200")!
    
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage?{
        guard let data = data,
              let image = UIImage(data: data),
              let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300
        else {
            return nil
        }
        return image
    }
    
    func downloadWithEscaping(complitionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
            let image = self?.handleResponse(data: data, response: response)
            complitionHandler(image, error)
        }
        .resume()
    }
    
    func downloadWithCombine() -> AnyPublisher<UIImage?, Error>{
        URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    func downloadWithAsync() async throws -> UIImage?{
        do{
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
            return handleResponse(data: data, response: response)
        } catch {
            throw error
        }
    }
    
    
}

class diwaaViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    let loader = diwaaImageLoader()
    var cancellables: Set<AnyCancellable> = []
    
    func fetchImage() async{
//        self.image = UIImage(systemName: "heart.fill")
        
//        loader.downloadWithEscaping { [weak self] image, error in
//            DispatchQueue.main.async(execute: {
//                self?.image = image
//            })
//        }
        
//        loader.downloadWithCombine()
//            .receive(on: DispatchQueue.main)
//            .sink { _ in
//            } receiveValue: { [weak self] returnedImage in
//                self?.image = returnedImage
//            }
//            .store(in: &cancellables)
        
        let image = try? await loader.downloadWithAsync()
        await MainActor.run { // такой вид перехоад от bacground thread в main. Нельзя использовать DispatchQueue.main.async в Concurency
            self.image = image
        }
    }
    
}

struct diwaa: View {
    
    @StateObject private var viewModel = diwaaViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250 , height: 250)
            }
        }
        .onAppear{
            Task{
                await viewModel.fetchImage()
            }
        }
    }
}

struct diwaa_Previews: PreviewProvider {
    static var previews: some View {
        diwaa()
    }
}
