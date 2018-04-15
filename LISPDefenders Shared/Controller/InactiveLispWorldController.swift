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
    var projectiles: [ProjectileController] {
        return _projectiles
    }
    private var _blocks: [FallingLispNodeController]
    private var _projectiles: [ProjectileController]

    let status: StatusController
    
    var isRunning: Bool { didSet {
        if !isRunning {
            removeFallingBlocks()
        }
    } }
    var scene: SKNode
    var bufferNode: SKNode { didSet {
        bufferNode.zPosition = ZPositions.buffer
    } }

    init(status: StatusController, scene: SKNode, bufferNode: SKNode) {
        self._blocks = []
        self._projectiles = []
        self.status = status
        self.scene = scene
        self.bufferNode = bufferNode
        self.isRunning = true
        bufferNode.zPosition = ZPositions.buffer
    }
    
    func add(block: FallingLispNodeController) {
        _blocks.append(block)
        scene.addChild(block.node)
    }
    
    func add(projectile: ProjectileController) {
        _projectiles.append(projectile)
        scene.addChild(projectile.node)
    }
    
    func update(deltaTime: CGFloat) {
        for block in blocks {
            guard block.node.parent != nil else {
                continue //Previous block update caused all blocks to be removed
            }
            
            updateChild(block: block, deltaTime: deltaTime)
        }
        for projectile in projectiles {
            updateChild(projectile: projectile, deltaTime: deltaTime)
        }
        for block in blocks {
            guard !block.isEvaluated else {
                continue
            }
            
            for projectile in projectiles {
                checkCollision(block: block, projectile: projectile)
            }
        }
    }
    
    private func updateChild(block: FallingLispNodeController, deltaTime: CGFloat) {
        block.update(deltaTime: deltaTime)
        
        if block.node.frame.minY <= bufferNode.frame.maxY && !block.isEvaluated {
            //Moved below buffer - evaluate.
            handleBlockHitBuffer(block)
        } else if block.node.frame.minY <= scene.bounds.minY {
            //Moving out of screen Y - remove.
            remove(block: block)
        }
    }
    
    private func updateChild(projectile: ProjectileController, deltaTime: CGFloat) {
        projectile.update(deltaTime: deltaTime)
        
        if projectile.node.frame.maxY <= scene.bounds.minY ||
            projectile.node.frame.minY >= scene.bounds.maxY {
            //Moved out of screen Y - delete.
            remove(projectile: projectile)
        }
    }
    
    private func checkCollision(block: LispController, projectile: ProjectileController) {
        checkEntireCollision(block: block, projectile: projectile)
        guard projectile.node.parent != nil else {
            return //Removed projectile
        }
        checkChildCollisions(block: block, projectile: projectile)
    }
    
    private func checkEntireCollision(block: LispController, projectile: ProjectileController) {
        if block.isJustEmoji && block.frame.intersects(projectile.node.frame) {
            handleEntireCollision(block: block, projectile: projectile)
        }
    }
    
    private func checkChildCollisions(block: LispController, projectile: ProjectileController) {
        for child in block.children {
            checkCollision(block: child, projectile: projectile)
            guard projectile.node.parent != nil else {
                return //Removed projectile
            }
        }
    }
    
    private func handleEntireCollision(block: LispController, projectile: ProjectileController) {
        block.expr = block.expr.set(value: .atom(.emoji(projectile.item)))
        remove(projectile: projectile)
    }
    
    func handleBlockHitBuffer(_ block: FallingLispNodeController) {
        let blockEvaled = block.expr.deepValue.eval(context: SContext.base)
        status.apply(effects: blockEvaled.toEmojis!)
        
        block.isEvaluated = true
        block.expr = DLocdSExpr.complete(blockEvaled)
    }
    
    private func remove(block: FallingLispNodeController) {
        _blocks.remove(at: _blocks.index(of: block)!)
        block.node.removeFromParent()
    }
    
    private func remove(projectile: ProjectileController) {
        _projectiles.remove(at: _projectiles.index(of: projectile)!)
        projectile.node.removeFromParent()
    }
    
    private func removeFallingBlocks() {
        var i = 0
        while i < _blocks.count {
            let block = _blocks[i]
            if block.isEvaluated {
                i += 1
            } else {
                _blocks.remove(at: i)
                block.node.removeFromParent()
            }
        }
    }
    
    func handle(newStatus: GameStatus) {
        if newStatus.isGameOver {
            isRunning = false
        }
    }
}
