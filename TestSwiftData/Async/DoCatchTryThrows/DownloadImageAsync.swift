//
//  DownloadImageAsync.swift
//  TestSwiftData
//
//  Created by daktech on 14/06/2024.
//

import SwiftUI
import Combine

class DownloadImageAsyncImageLoader {
    let url = URL(string: "https://picsum.photos/id/237/200/300")!
    
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
                return nil
        }
        
        return image
    }

    func downloadWithEscaping(completionHandle: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            let image = self?.handleResponse(data: data, response: response)
            completionHandle(image, nil)
        }
        .resume()
    }
    
    func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
            .mapError({$0})
            .eraseToAnyPublisher()
    }
    
    func downloadWithAsync() async throws -> UIImage? {
        do{
            let (data, response) = try await URLSession.shared.data(from: url)
            return handleResponse(data: data, response: response)
        }catch {
            throw error
        }
    }
}

class DownloadImageAsyncViewModel: ObservableObject{
    @Published var image: UIImage? = nil
    let loader = DownloadImageAsyncImageLoader()
    var anyCancellbles = Set<AnyCancellable>()
    
    func fetchImage() async {
//        self.image = UIImage(systemName: "heart.fill")
        
//        loader.downloadWithEscaping { [weak self] image, error in
//            if let image = image {
//                DispatchQueue.main.async {
//                    self?.image = image
//                }
//            }
//        }
        
//        loader.downloadWithCombine()
//            .receive(on: DispatchQueue.main)
//            .sink { _ in
//                
//            } receiveValue: { [weak self] image in
//                self?.image = image
//            }
//            .store(in: &anyCancellbles)
        
       let image = try? await loader.downloadWithAsync()
        await MainActor.run {
            self.image = image
        }
    }
}

struct DownloadImageAsync: View {
    @StateObject private var viewModel = DownloadImageAsyncViewModel()
    
    var body: some View {
        ZStack{
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
        }
        .onAppear{
            Task {
               await viewModel.fetchImage()
            }
        }
    }
}

#Preview {
    DownloadImageAsync()
}
