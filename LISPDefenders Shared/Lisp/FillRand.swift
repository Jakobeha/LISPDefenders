//
//  FillRand.swift
//  LISPDefenders
//
//  Created by Jakob Hain on 4/14/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import Foundation

extension DLocd where T == UnDLocdSExpr {
    func fillRands() -> DLocdSExpr {
        switch self.value {
        case .atom(let atom):
            return set(value: .atom(atom.fillRands()))
        case .list(let contents):
            return set(value: .list(contents.map { $0.fillRands() }))
        }
    }
}

extension SExpr {
    func fillRands() -> SExpr {
        switch self {
        case .atom(let atom):
            return .atom(atom.fillRands())
        case .list(_):
            return self
        }
    }
}

extension SAtom {
    func fillRands() -> SAtom {
        switch self {
        case .symbol(_):
            return self
        case .number(_):
            return self
        case .emoji(let emoji):
            return .emoji(emoji.fillRands())
        }
    }
}

extension SEmoji {
    private static let noBombWeightsAndItems: [(CGFloat, SEmoji)] = [
        (45, .donut),
        (30, .pizza),
        (20, .taco),
        (5, .sushi),
        (0, .neutralRand),
        (0, .posRand)
    ]
    static let neutralWeightsAndItems: [(CGFloat, SEmoji)] = SEmoji.noBombWeightsAndItems + [(100, .bomb)]
    static let posWeightsAndItems: [(CGFloat, SEmoji)] = SEmoji.noBombWeightsAndItems + [(0, .bomb)]

    func fillRands() -> SEmoji {
        switch self {
        case .neutralRand:
            return Random.choice(SEmoji.neutralWeightsAndItems)
        case .posRand:
            return Random.choice(SEmoji.posWeightsAndItems)
        default:
            return self
        }
    }
}
