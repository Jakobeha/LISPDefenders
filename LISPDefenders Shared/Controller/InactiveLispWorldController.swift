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
