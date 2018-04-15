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

    var scene: SKNode
    
    init(scene: SKNode) {
        self._blocks = []
        self._projectiles = []
        self.scene = scene
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
            updateChild(block: block, deltaTime: deltaTime)
        }
        for projectile in projectiles {
            updateChild(projectile: projectile, deltaTime: deltaTime)
        }
        for block in blocks {
            for projectile in projectiles {
                checkCollision(block: block, projectile: projectile)
            }
        }
    }
    
    private func updateChild(block: FallingLispNodeController, deltaTime: CGFloat) {
        block.update(deltaTime: deltaTime)
        
        if block.node.frame.minY <= scene.bounds.minY {
            //Moving out of screen Y - evaluate.
            handleBlockHitBottom(block)
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
    
    func handleBlockHitBottom(_ block: FallingLispNodeController) {
        //TODO Apply the block's effect
        remove(block: block)
    }
    
    private func remove(block: FallingLispNodeController) {
        _blocks.remove(at: _blocks.index(of: block)!)
        block.node.removeFromParent()
    }
    
    private func remove(projectile: ProjectileController) {
        _projectiles.remove(at: _projectiles.index(of: projectile)!)
        projectile.node.removeFromParent()
    }
}
