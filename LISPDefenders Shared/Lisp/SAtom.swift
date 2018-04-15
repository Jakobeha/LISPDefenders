//
// Created by Jakob Hain on 4/14/18.
// Copyright (c) 2018 Jakobeha. All rights reserved.
//

import Foundation

enum SAtom: Equatable {
    static func ==(lhs: SAtom, rhs: SAtom) -> Bool {
        switch (lhs, rhs) {
        case (.symbol(let lhs), .symbol(let rhs)):
            return lhs == rhs
        case (.number(let lhs), .number(let rhs)):
            return lhs == rhs
        case (.emoji(let lhs), .emoji(let rhs)):
            return lhs == rhs
        default:
            return false
        }
    }
    
    case symbol(String)
    case number(Int)
    case emoji(SEmoji)

    var isTruthy: Bool {
        switch self {
        case .symbol(let symbol):
            return symbol != "false"
        case .number(let int):
            return int != 0
        case .emoji(let emoji):
            return emoji.isTruthy
        }
    }
}
