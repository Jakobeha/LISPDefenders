//
// Created by Jakob Hain on 4/14/18.
// Copyright (c) 2018 Jakobeha. All rights reserved.
//

import Foundation

enum SEmoji: Equatable {
    private static let charsAndEmojis: [(Character, SEmoji)] = [
        ("🍩", .donut),
        ("🍕", .pizza),
        ("🌮", .taco),
        ("🍣", .sushi),
        ("💣", .bomb),
        ("📦", .neutralRand),
        ("🎁", .posRand)
    ]
    static let charToEmoji: [Character : SEmoji] = Dictionary(uniqueKeysWithValues: charsAndEmojis)
    static let emojiToChar: [SEmoji : Character] = Dictionary(uniqueKeysWithValues: charsAndEmojis.map { (x, y) in (y, x) })
    
    case donut
    case pizza
    case taco
    case sushi
    case bomb
    case neutralRand
    case posRand

    var effect: SEmojiEffect {
        switch self {
        case .donut:
            return .award(points: 10)
        case .pizza:
            return .award(points: 15)
        case .taco:
            return .award(points: 25)
        case .sushi:
            return .award(points: 45)
        case .bomb:
            return .lose
        case .neutralRand, .posRand:
            fatalError("Placeholder's effect not defined - it needs to be filled.")
        }
    }

    var isTruthy: Bool {
        switch self {
        case .donut:
            return true
        case .pizza:
            return true
        case .taco:
            return true
        case .sushi:
            return true
        case .bomb:
            return false
        case .neutralRand, .posRand:
            fatalError("Placeholder's truthiness not defined - it needs to be filled.")
        }
    }
}
