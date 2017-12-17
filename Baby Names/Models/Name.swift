//
//  Name.swift
//  Baby Names
//
//  Created by Maihan Nijat on 2017-11-01.
//  Copyright © 2017 Sunzala Technology. All rights reserved.
//

struct Name {
    let id: Int
    let name: String
    let native: String
    let meaning: String
    let origin: String
    var isFavorite: Bool
    let gender: String
    
    init(id: Int, name: String, native: String, meaning: String, origin: String, isFavorite: Bool, gender: String) {
        self.id = id
        self.name = name
        self.native = native
        self.meaning = meaning
        self.origin = origin
        self.isFavorite = isFavorite
        self.gender = gender
    }
}
