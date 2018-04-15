//
//  Loc.swift
//  LISPDefenders
//
//  Created by Jakob Hain on 4/14/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import Foundation

struct Loc: Equatable {
    static let start: Loc = Loc(idx: 0)

    static func ==(_ x: Loc, _ y: Loc) -> Bool {
        return x.idx == y.idx
    }
    
    static func -(_ x: Loc, _ y: Loc) -> Loc {
        return Loc(idx: x.idx - y.idx)
    }

    var idx: UInt
    
    mutating func addLine() {
        idx += 1
    }
    
    mutating func addColumn() {
        idx += 1
    }
    
    func idx(in str: String) -> String.Index {
        return str.index(str.startIndex, offsetBy: Int(idx))
    }
}
