//
//  Item.swift
//  Todoey
//
//  Created by Zaheer Moola on 2021/12/03.
//

import RealmSwift

class Item: Object {
    @objc dynamic var title = ""
    @objc dynamic var done = false
    @objc dynamic var dateCreated = Date()

    var parentCategory = LinkingObjects(fromType: TodoCategory.self, property: "items")
}

