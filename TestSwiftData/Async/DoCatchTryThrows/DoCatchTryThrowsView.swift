//
//  DoCatchTryThrowsView.swift
//  TestSwiftData
//
//  Created by daktech on 14/06/2024.
//

import SwiftUI

class DoCatchTryThrowsDataManager: ObservableObject {
    let isActive: Bool = true
    
    func getTitle() -> (title: String?, error: Error?) {
        if isActive {
            return ("New text", nil)
        } else {
            return (nil, URLError(.badURL))
        }
    }
    
    func getTitle2() -> Result<String, Error>{
        if isActive {
            return .success("new text")
        }else{
            return .failure(URLError(.appTransportSecurityRequiresSecureConnection))
        }
    }
    
    func getTitle3() throws -> String{
//        if isActive {
//            return "New text"
//        }else{
            throw URLError(.badServerResponse)
//        }
    }
    
    func getTitle4() throws -> String {
        if isActive {
            return "final text"
        }else{
            throw URLError(.badServerResponse)
        }
    }
}

class DoCatchTryThrowsViewModel: ObservableObject {
    @Published var text: String = "test text"
    let managerData = DoCatchTryThrowsDataManager()
    
    func fetchTitle() {
//        let newTitle = managerData.getTitle()
//        if let newTitle = newTitle {
//            self.text = newTitle
//        }
//        let title = try? managerData.getTitle3()
        do {
            let title = try? managerData.getTitle3()
            self.text = title ?? ""
            
            let finalTitle = try managerData.getTitle4()
            self.text = finalTitle
        }catch let error {
            self.text = error.localizedDescription
        }
    }

}

struct DoCatchTryThrowsView: View {
    @StateObject var viewModel = DoCatchTryThrowsViewModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(Color.blue)
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

#Preview {
    DoCatchTryThrowsView(viewModel: DoCatchTryThrowsViewModel())
}
