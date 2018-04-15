//
//  LispSpawner.swift
//  LISPDefenders
//
//  Created by Jakob Hain on 4/14/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import SpriteKit

class LispSpawner {
    static let minSpawnDelay: CGFloat = 4
    static let maxSpawnDelay: CGFloat = 6
    
    private static func spawn(_ expr: DLocdSExpr, in world: InactiveLispWorldController) {
        let spawnExpr = expr.fillRands()
        let bounds = LispNodeController.boundsOf(expr: spawnExpr)
        let posn = CGPoint(
            x: Random.within(
                min: world.scene.bounds.minX,
                max: world.scene.bounds.maxX - bounds.width
            ),
            y: world.scene.bounds.maxY + bounds.height
        )
        world.add(block: FallingLispNodeController(expr: spawnExpr, posn: posn))
    }
    
    var template: Template
    var world: InactiveLispWorldController
    private var spawnDelay: CGFloat
    
    init(template: Template, world: InactiveLispWorldController) {
        self.template = template
        self.world = world
        self.spawnDelay = 0
    }
    
    func update(deltaTime: CGFloat) {
        spawnDelay -= deltaTime
        
        if spawnDelay <= 0 {
            spawnAndDelay()
        }
    }
    
    private func spawnAndDelay() {
        LispSpawner.spawn(template.getNextExpr(), in: world)
        spawnDelay += Random.within(min: LispSpawner.minSpawnDelay, max: LispSpawner.maxSpawnDelay)
    }
}
