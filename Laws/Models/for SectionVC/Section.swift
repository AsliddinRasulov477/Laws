//
//  Section.swift
//  MoliyaStudiyasi
//
//  Created by Luiza on 24.09.2020.
//  Copyright © 2020 Luiza. All rights reserved.
//

import Foundation

//Модель для массива данных
struct Section{
    var sectionsName: String
    var chapters: [Chapter]
    var expanded: Bool
}

struct Chapter{
    var chapter: String
    var liked: Bool = false
}
