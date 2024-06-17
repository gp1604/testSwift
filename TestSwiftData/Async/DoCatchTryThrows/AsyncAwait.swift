//
//  AsyncAwait.swift
//  TestSwiftData
//
//  Created by daktech on 15/06/2024.
//

import SwiftUI

struct AsyncAwait: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    func add3() async {
        try? await add()
    }
    
    func add() async throws{
        try await Task.sleep(nanoseconds: 2_000_000)
    }
}

#Preview {
    AsyncAwait()
}
