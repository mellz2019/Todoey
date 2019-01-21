//
//  Category.swift
//  Todoey
//
//  Created by Melvin Lee on 1/21/19.
//  Copyright © 2019 Melvin Lee. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    
    // Relationship to Item
    let items = List<Item>()
}
