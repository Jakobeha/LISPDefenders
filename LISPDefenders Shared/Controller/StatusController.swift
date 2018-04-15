//
//  StatusController.swift
//  LISPDefenders
//
//  Created by Jakob Hain on 4/15/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import SpriteKit

class StatusController {
    static let gameOverColor: SKColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    static let regularColor: SKColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    var status: GameStatus { didSet {
        updateNode()
        onSetStatus(status)
    } }
    var node: SKLabelNode { didSet {
        node.zPosition = ZPositions.status
        updateNode()
    } }
    let onSetStatus: (GameStatus) -> Void
    
    init(status: GameStatus, node: SKLabelNode, onSetStatus: @escaping (GameStatus) -> Void) {
        self.status = status
        self.node = node
        self.onSetStatus = onSetStatus
        node.zPosition = ZPositions.status
        updateNode()
    }
    
    private func updateNode() {
        node.text = status.description
        node.fontColor = status.isGameOver ? StatusController.gameOverColor : StatusController.regularColor
    }
    
    func apply(effects: [SEmojiEffect]) {
        status.apply(effects: effects)
    }
}
