//
//  ContentView.swift
//  TestSwiftData
//
//  Created by daktech on 08/12/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        DetailChild(item: item)
                    } label: {
                        DetailView(item: item)
                        //                        VStack{
                        //                            Text(item.id)
                        //                            Text(item.name)
                        //                            Text(String(item.point))
                        //                            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                        //                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
        .onAppear{
            var arr: [Item] = Item.filter(in: modelContext)
            print(arr)
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(id: UUID().uuidString, name: "abc", point: 0, arrChild: [Child(id: UUID().uuidString, chilName: "tesst child")])
            modelContext.insert(newItem)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

struct DetailView: View {
    @Bindable var item: Item
    @Environment(\.modelContext) private var modelContext
    
    var body: some View{
        VStack{
            Image(.group14)
            
            Text(item.id)
            
            Text(item.name)
            Text(String(item.point))
            Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
            
            ForEach(item.arrChild) { child in
                Text(child.chilName)
                    .foregroundStyle(Color.red)
                    .onTapGesture {
                        //                        modelContext.delete(child)
                        item.arrChild.removeFirst()
                        let child = Child(id: UUID().uuidString, chilName: "update")
                        item.arrChild.append(child)
                    }
            }
            
            ForEach(item.car) { car in
                Text(car.name)
            }
            
            Button {
                item.point += 1
            } label: {
                Text("Click")
            }
            
            Button(action: {
                addItem()
            }, label: {
                Text("add")
            })
        }
    }
    
    
    private func addItem() {
        withObservationTracking {
            for i in item.arrChild {
                print(i.chilName)
            }
        } onChange: {
            print("withObservationTracking change")
        }
        
        withAnimation {
            item.arrChild.first?.chilName = "update"
            let car = Car(name: "new car", needsRepairs: true)
            item.car.append(car)
        }
    }
}

struct DetailChild: View {
    @Query var child: [Child]
    @Bindable var item: Item
    @Environment(\.modelContext) private var modelContext
    
    var body: some View{
        ScrollView{
            Button(action: {
                modelContext.delete(item)
            }, label: {
                Text("delete item")
                    .foregroundStyle(.red)
            })
            
            ForEach(child, id: \.id) {item in
                Text(item.chilName)
            }
            
            ForEach(item.car) { car in
                Text(car.name)
            }
            
            Button(action: {
                let children = Child(id: UUID().uuidString, chilName: "TEST ADA")
                modelContext.insert(children)
            }, label: {
                Text("ADD CHILD")
            })
            
            Divider()
            
            ForEach(item.arrChild, id: \.id) {child in
                Text(child.chilName)
            }
            
            Button(action: {
                let children = Child(id: UUID().uuidString, chilName: "add to arr child")
                //                modelContext.insert()
                item.arrChild.append(children)
                let car = Car(name: "new car", needsRepairs: true)
                item.car.append(car)
            }, label: {
                Text("add to item -> arr child")
            })
        }
    }
}


struct PhotoItem: Identifiable {
    var id = UUID()
    var name: String
}

struct SwitchingGridLayoutDemo2: View {
    @State var gridConfig: [GridItem] = [ GridItem() ] {
        didSet {
            switch gridConfig.count {
            case 1:
                icon = "rectangle.grid.2x2"
            case 2:
                icon = "rectangle.grid.3x2"
            case 3:
                icon = "square.grid.4x3.fill"
            case 4:
                icon = "rectangle.grid.1x2"
            default:
                icon = "rectangle.grid.1x2"
            }
        }
    }
    
    @State var icon: String = "rectangle.grid.2x2"
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridConfig) {
                    ForEach(1...30, id: \.self) { item in
                        Image(.group14)
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: gridConfig.count == 1 ? 200 : 100)
                            .cornerRadius(10)
                            .shadow(color: Color.primary.opacity(0.3), radius: 1)
                    }
                }
                .animation(.interactiveSpring(), value: gridConfig.count)
                .padding()
            }
            .frame(maxHeight: .infinity)
            .navigationTitle("Photos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print(gridConfig.count)
                        self.gridConfig = Array(repeating: .init(.flexible()), count: self.gridConfig.count % 4 + 1)
                        
                    } label: {
                        Image(systemName: icon)
                            .font(.title)
                            .foregroundColor(.primary)
                            .imageScale(.large)
                    }
                }
            }
        }
    }
}
