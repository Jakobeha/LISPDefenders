//
//  Loc.swift
//  LISPDefenders
//
//  Created by Jakob Hain on 4/14/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import Foundation

struct Locd<T> {
    var value: T
    var print: String
    var location: Loc
    
    init(_ value: T, print: String, location: Loc) {
        self.value = value
        self.print = print
        self.location = location
    }
}
