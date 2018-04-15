//
//  SExpr.swift
//  LISPDefenders iOS
//
//  Created by Jakob Hain on 4/14/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import Foundation

enum SExpr: Equatable {
    static func ==(lhs: SExpr, rhs: SExpr) -> Bool {
        switch (lhs, rhs) {
        case (.atom(let lhs), .atom(let rhs)):
            return lhs == rhs
        case (.list(let lhs), .list(let rhs)):
            return lhs == rhs
        default:
            return false
        }
    }
    
    case atom(SAtom)
    case list([SExpr])

    var isTruthy: Bool {
        switch self {
        case .atom(let atom):
            return atom.isTruthy
        case .list(let contents):
            return !contents.isEmpty
        }
    }
}
