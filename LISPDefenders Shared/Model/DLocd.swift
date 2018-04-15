//
//  Loc.swift
//  LISPDefenders
//
//  Created by Jakob Hain on 4/14/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import Foundation

struct DLocd<T> {
    var value: T
    var print: String
    var absLoc: Loc
    var relLoc: Loc

    init(_ value: T, print: String, absLoc: Loc, relLoc: Loc) {
        self.value = value
        self.print = print
        self.absLoc = absLoc
        self.relLoc = relLoc
    }
}
