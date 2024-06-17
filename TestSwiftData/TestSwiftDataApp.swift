//
//  TestSwiftDataApp.swift
//  TestSwiftData
//
//  Created by daktech on 08/12/2023.
//

import SwiftUI
import SwiftData
import ComposableArchitecture

@main
struct TestSwiftDataApp: App {
    //    var sharedModelContainer: ModelContainer = {
    //        let schema = Schema([
    //            Item.self,
    //            Child.self
    //        ])
    //        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    //
    //        do {
    //            return try ModelContainer(for: schema, configurations: [modelConfiguration])
    //        } catch {
    //            fatalError("Could not create ModelContainer: \(error)")
    //        }
    //    }()
    //
        static let store = Store(initialState: CounterFeature.State()) {
            CounterFeature()
                ._printChanges()
        }
    
        static let store2 = Store(initialState: AppFeature.State()) {
            AppFeature()
        }
        
    
    static let contacts = Store(initialState: ContactsFeature.State()) {
        ContactsFeature()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            //            ContentView()
            
            //            SwitchingGridLayoutDemo2()
            
//                        TCAView(
//                            store: TestSwiftDataApp.store
//                        )
            
            //            AppView(store: TestSwiftDataApp.store2)
            
//            ContactsView(store: TestSwiftDataApp.contacts)
            
            TaskHomeView()
        }
        //        .modelContainer(sharedModelContainer)
    }
}


