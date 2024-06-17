//
//  Task.swift
//  TestSwiftData
//
//  Created by daktech on 15/06/2024.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil

    func fetchImage() async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        guard let url = URL(string: "https://picsum.photos/id/870/200/300?grayscale&blur=2") else  { return }
        let (data, _) = try await URLSession.shared.data(from: url)
        let image = UIImage(data: data)
        await MainActor.run {
            self.image = image
        }
    }
    
    func fetchImage2() async {
        do{
//            try? await fetchImage()
            try await Task.sleep(nanoseconds: 1_000_000_000)
            guard let url = URL(string: "https://picsum.photos/seed/picsum/200/300") else  { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            let image = UIImage(data: data)
            await MainActor.run {
                self.image2 = image
            }
        }catch {
            print(error.localizedDescription)
        }
    }
}

struct TaskHomeView: View {
    var body: some View {
        NavigationStack{
            ZStack{
                NavigationLink("Click") {
                    TaskView()
                }
            }
        }
    }
}

struct TaskView: View {
    @StateObject var viewModel = TaskViewModel()
    
    var body: some View {
        VStack{
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
//                    .scaledToFill()
            }
            
            if let image = viewModel.image2{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            }
        }
        .onAppear{
            Task{
                await viewModel.fetchImage2()
                try? await viewModel.fetchImage()
            }
        }
    }
}

#Preview {
    TaskHomeView()
}
