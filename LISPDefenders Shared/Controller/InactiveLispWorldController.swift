//
//  InactiveLispWorldController.swift
//  LISPDefenders
//
//  Created by Jakob Hain on 4/14/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import SpriteKit

///Doesn't spawn any blocks - will still update added blocks though.
class InactiveLispWorldController {
    var blocks: [FallingLispNodeController] {
        return _blocks
    }
    private var _blocks: [FallingLispNodeController]
    
    var scene: SKNode
    
    init(scene: SKNode) {
        self._blocks = []
        self.scene = scene
    }
    
    func addBlock(expr: DLocdSExpr, posn: CGPoint) {
        var block = nil as FallingLispNodeController!
        block = FallingLispNodeController(expr: expr, posn: posn, onHitBottom: { self.handleBlockHitBottom(block!) })
        _blocks.append(block!)
        scene.addChild(block!.node)
    }
    
    func handleBlockHitBottom(_ block: FallingLispNodeController) {
        //TODO Apply the block's effect
        removeBlock(block)
    }
    
    private func removeBlock(_ block: FallingLispNodeController) {
        _blocks.remove(at: _blocks.index(of: block)!)
        block.node.removeFromParent()
    }
    
    
    func update(deltaTime: CGFloat) {
        for block in blocks {
            block.update(deltaTime: deltaTime)
        }
    }
}
