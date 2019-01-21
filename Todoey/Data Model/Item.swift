//
//  Item.swift
//  Todoey
//
//  Created by Melvin Lee on 1/21/19.
//  Copyright © 2019 Melvin Lee. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    // Relationship to Category
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
