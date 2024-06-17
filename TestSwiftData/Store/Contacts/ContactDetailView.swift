//
//  ContactDetailView.swift
//  TestSwiftData
//
//  Created by daktech on 27/02/2024.
//

import SwiftUI
import ComposableArchitecture



struct ContactDetailView: View {
    @Bindable var store: StoreOf<ContactDetailFeature>

    var body: some View {
        Form {
            Button("Delete") {
                   store.send(.deleteButtonTapped)
                 }
        }
        .navigationBarTitle(Text(store.contact.name))
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}
