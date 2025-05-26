//
//  DoCatchTryThrowsBootcamp.swift
//  SwiftConcurrency
//
//  Created by Dostan Turlybek on 26.05.2025.
//
import SwiftUI

//do-catch
//try
//throws

class DoCatchTryThrowsBootcampDataManager {
    
    let isActive: Bool = false
    
    func getTitle() -> (title: String?, error: Error?) {
        if isActive {
            return ("New text", nil)
        } else {
            return (nil, URLError(.badURL))
        }
    }
    
    func getTitle2() -> Result<String, Error>{
        if isActive{
            return .success("New text")
        } else {
            return .failure(URLError(.badURL))
        }
    }
    
    func getTitle3() throws -> String{
        if isActive {
            return "New Text"
        } else {
            throw URLError(.badURL)
        }
    }
}

class DoCatchTryThrowsBootcampViewModel: ObservableObject {
    @Published var text: String = "Hello, World!"
    let manager = DoCatchTryThrowsBootcampDataManager()
    
    func fetchTitle() {
        /*
        let returnedValue = manager.getTitle()
        if let newText = returnedValue.title {
            self.text = newText
        } else if let error = returnedValue.error{
            self.text = error.localizedDescription
        }
                        */
        /*
        let result = manager.getTitle2()
        switch result {
        case .success(let newTitle):
            self.text = newTitle
        case .failure(let error):
            self.text = error.localizedDescription
        }
        */
        
        
        let newTitle = try? manager.getTitle3()
        if let newTitle = newTitle {
            //если getTitle3() будет всегда падать с ошибкой то этот код не будет работать. Но если try? выдаст nil то manager.getTitle3() выполнить свою работу и присвоит новое значение
            self.text = newTitle
        }
        
        /*
        do{
            let newTitle = try manager.getTitle3()
            self.text = newTitle
        } catch let error {
            self.text = error.localizedDescription
        }
         */
    }
}

struct DoCatchTryThrowsBootcamp: View{
    
    @StateObject private var viewModel = DoCatchTryThrowsBootcampViewModel()
    
    var body: some View{
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(Color.blue)
            .onTapGesture {
                viewModel.fetchTitle()
            }
            
    }
}

struct DoCatchTryThrowsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        DoCatchTryThrowsBootcamp()
    }
}
