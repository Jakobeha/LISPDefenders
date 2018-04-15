//
//  GameStatus.swift
//  LISPDefenders
//
//  Created by Jakob Hain on 4/15/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import Foundation

struct GameStatus {
    static let initial: GameStatus = GameStatus(totalPoints: 0, isGameOver: false)
    
    var totalPoints: Int { return _totalPoints }
    private var _totalPoints: Int
    var isGameOver: Bool { return _isGameOver }
    private var _isGameOver: Bool
    
    var description: String {
        let scoreMsg = "Score: \(totalPoints) Points"
        if isGameOver {
            return "Game Over - \(scoreMsg)"
        } else {
            return scoreMsg
        }
    }
    
    init(totalPoints: Int, isGameOver: Bool) {
        _totalPoints = totalPoints
        _isGameOver = isGameOver
    }
    
    mutating func apply(effects: [SEmojiEffect]) {
        for effect in effects {
            apply(effect: effect)
        }
    }
    
    mutating func apply(effect: SEmojiEffect) {
        switch effect {
        case .award(points: let points):
            add(points: points)
        case .lose:
            lose()
        }
    }
    
    mutating func add(points: Int) {
        _totalPoints += points
    }
    
    mutating func lose() {
        _isGameOver = true
    }
}
