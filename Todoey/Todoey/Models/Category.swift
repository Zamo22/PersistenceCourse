//
//  Category.swift
//  Todoey
//
//  Created by Zaheer Moola on 2021/12/03.
//

import RealmSwift

class TodoCategory: Object {
    @objc dynamic var name = ""

    let items = List<Item>()
}
