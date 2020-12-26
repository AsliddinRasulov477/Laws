//
//  DataBaseClass.swift
//  MoliyaStudiyasi
//
//  Created by Luiza on 15.10.2020.
//  Copyright © 2020 Luiza. All rights reserved.
//


import Foundation
import RealmSwift

class DataObjects: Object {
    @objc dynamic var nameCodecs: String = ""
    
    var namesBookMarked = List<String>()
    convenience init(add: String) {
        self.init()
        self.namesBookMarked.append(add)
    }
    
}
