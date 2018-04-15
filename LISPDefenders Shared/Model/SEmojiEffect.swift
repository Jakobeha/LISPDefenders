//
// Created by Jakob Hain on 4/14/18.
// Copyright (c) 2018 Jakobeha. All rights reserved.
//

import Foundation

enum SEmojiEffect: Comparable {
    case award(points: Int)
    case lose

    static func >(_ x: SEmojiEffect, _ y: SEmojiEffect) -> Bool {
        switch (x, y) {
        case (.award(points: let xPoints), .award(let yPoints)):
            return xPoints > yPoints
        case (.award(points: _), .lose):
            return true
        case (.lose, .award(points: _)):
            return false
        case (.lose, .lose):
            return false
        }
    }

    static func <(_ x: SEmojiEffect, _ y: SEmojiEffect) -> Bool {
        switch (x, y) {
        case (.award(points: let xPoints), .award(let yPoints)):
            return xPoints < yPoints
        case (.award(points: _), .lose):
            return false
        case (.lose, .award(points: _)):
            return true
        case (.lose, .lose):
            return false
        }
    }
    
    static func ==(_ x: SEmojiEffect, _ y: SEmojiEffect) -> Bool {
        switch (x, y) {
        case (.award(points: let xPoints), .award(let yPoints)):
            return xPoints == yPoints
        case (.award(points: _), .lose):
            return false
        case (.lose, .award(points: _)):
            return false
        case (.lose, .lose):
            return true
        }
    }
}
