////
////  asyncAwait.swift
////  SwiftConcurrency
////
////  Created by Dostan Turlybek on 28.05.2025.
////
//import SwiftUI
//
//class asyncAwaitViewModel: ObservableObject {
//    @Published var dataArray: [String] = []
//    
//    func addTitle1() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
//            self.dataArray.append("Title1 : \(Thread.current)")
//        })
//        
//    }
//    
//    func addTitle2() {
//        
//        DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
//            let title = "Title2 : \(Thread.current)"
//            DispatchQueue.main.async {
//                self.dataArray.append(title)
//                
//                let title3 = "Title3 : \(Thread.current)"
//                self.dataArray.append(title3)
//            }
//        })
//    }
//    
//    func addAuthor1() async {
//        let author1 = "Author1 : \(Thread.current)"
//        self.dataArray.append(author1)
//        
//        try? await Task.sleep(nanoseconds: 2_000_000_000)
//        
//        let author2 = "Author2 : \(Thread.current)"
//        await MainActor.run(body: {
//            self.dataArray.append(author2)
//            
//            let author3 = "Author3 : \(Thread.current)"
//            self.dataArray.append(author3)
//        })
//    }
//    
//    func addSomething() async {
//        
//        try? await Task.sleep(nanoseconds: 2_000_000_000)
//        let something1 = "Something1 : \(Thread.current)"
//        await MainActor.run(body: {
//            self.dataArray.append(something1)
//            
//            let something2 = "Something2 : \(Thread.current)"
//            self.dataArray.append(something2)
//        })
//        
//    }
//}
//
//struct asyncAwaitView: View {
//    
//    @StateObject private var viewModel = asyncAwaitViewModel()
//    
//    var body: some View {
//        List{
//            ForEach(viewModel.dataArray, id: \.self) { data in
//                Text(data)
//            }
//        }
//        .onAppear{
//            Task{
//                await viewModel.addAuthor1()
//                await viewModel.addSomething()
//                
//                let finalText = "FINAL TEXT : \(Thread.current)"
//                viewModel.dataArray.append(finalText)
//            }
////            viewModel.addTitle1()
////            viewModel.addTitle2()
//        }
//    }
//}
//
//struct asyncAwait_Previews: PreviewProvider {
//    static var previews: some View {
//        asyncAwaitView()
//    }
//}
