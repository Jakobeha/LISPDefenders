//
//  Loc.swift
//  LISPDefenders
//
//  Created by Jakob Hain on 4/14/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import Foundation

struct Loc: Equatable {
    static let start: Loc = Loc(line: 0, column: 0, idx: 0)

    static func ==(_ x: Loc, _ y: Loc) -> Bool {
        return x.line == y.line && x.column == y.column && x.idx == y.idx
    }
    
    static func -(_ x: Loc, _ y: Loc) -> Loc {
        return Loc(line: x.line - y.line, column: x.column - y.column, idx: x.idx - y.idx)
    }

    var line: UInt
    var column: Int
    var idx: UInt
    
    mutating func addLine() {
        column = 0
        line += 1
        idx += 1
    }
    
    mutating func addColumn() {
        column += 1
        idx += 1
    }
}
