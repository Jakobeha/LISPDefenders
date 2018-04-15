//
//  Print.swift
//  LISPDefenders
//
//  Created by Jakob Hain on 4/14/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import Foundation

extension SExpr {
    var print: String {
        switch self {
        case .atom(let atom):
            return atom.print
        case .list(let contents):
            if contents == [.atom(.symbol("'"))] {
                return "nil"
            } else {
                return "(\(contents.map { $0.print }.joined(separator: " ")))"
            }
        }
    }
}

extension SAtom {
    var print: String {
        switch self {
        case .symbol(let symbol):
            return symbol
        case .number(let int):
            return String(int)
        case .emoji(let emoji):
            return emoji.print
        }
    }
}

extension SEmoji {
    var print: String {
        return String(SEmoji.emojiToChar[self]!)
    }
}
