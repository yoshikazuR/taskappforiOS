//
//  Task.swift
//  taskapp
//
//  Created by 高橋　義一 on 2021/10/18.
//

import RealmSwift

class Task: Object {
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var contents = ""
    @objc dynamic var category = ""
    @objc dynamic var date = Date()

    override static func primaryKey() -> String? {
        return "id"
    }
}
