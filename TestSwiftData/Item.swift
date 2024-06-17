//
//  Item.swift
//  TestSwiftData
//
//  Created by daktech on 08/12/2023.
//

import Foundation
import SwiftData
import Observation

@Model
class Car {
    var name: String = ""
    var needsRepairs: Bool = false
    
    init(name: String, needsRepairs: Bool = false) {
        self.name = name
        self.needsRepairs = needsRepairs
    }
}

@Model
final class Item {
    @Attribute(.unique) var id: String
    var timestamp: Date
    var name: String
    var point: Int
    var age: Int
    @Relationship(deleteRule: .cascade, inverse: \Child.item) var arrChild: [Child] = [Child]()
    var car: [Car]
    
    init(id: String, timestamp: Date? = Date(), name: String? = "", point: Int? = 0,age: Int? = 0, arrChild: [Child]? = [], car: [Car]? = []) {
        self.id = id
        self.timestamp = timestamp ?? Date()
        self.name = name ?? ""
        self.point = point ?? 0
        self.age = age ?? 0
        self.arrChild = arrChild ?? []
        self.car = car ?? []
    }
    
    static func filter(in context: ModelContext) -> [Item] {
        var arrFilter: [Item] = []
        arrFilter = try! context.fetch(FetchDescriptor<Item>(predicate: #Predicate<Item>{$0.name == "abc"}))
        return arrFilter
    }
}

@Model
class Child {
    @Attribute(.preserveValueOnDeletion) var id: String
    var chilName: String
    var childAge: Int
    var childOp: String
    var item: Item?
    
    init(id: String, chilName: String? = "", childAge: Int? = 0, childOp: String? = "") {
        self.id = id
        self.chilName = chilName ?? ""
        self.childAge = childAge ?? 0
        self.childOp = childOp ?? ""
    }
}
