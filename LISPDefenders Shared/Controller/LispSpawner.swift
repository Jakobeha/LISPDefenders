//
//  LispSpawner.swift
//  LISPDefenders
//
//  Created by Jakob Hain on 4/14/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import SpriteKit

class LispSpawner {
    static let fullMinSpawnDelay: CGFloat = 4
    static let fullMaxSpawnDelay: CGFloat = 6
    static let spawnDelayDecayChange: CGFloat = 0.75
    static let spawnDelayDecayExponent: CGFloat = 1/1000
    
    static func spawnDelayDecay(totalPoints: Int) -> CGFloat {
        return pow(
            LispSpawner.spawnDelayDecayChange,
            CGFloat(totalPoints) * LispSpawner.spawnDelayDecayExponent
        )
    }
    
    private static func spawn(_ expr: DLocdSExpr, in world: InactiveLispWorldController) {
        let spawnExpr = expr.fillRands()
        let bounds = LispNodeController.boundsOf(expr: spawnExpr)
        let posn = CGPoint(
            x: Random.within(
                min: world.scene.bounds.minX,
                max: world.scene.bounds.maxX - bounds.width
            ),
            y: world.scene.bounds.maxY
        )
        world.add(block: FallingLispNodeController(expr: spawnExpr, posn: posn))
    }
    
    var template: Template
    var world: InactiveLispWorldController
    var spawnDelayDecay: CGFloat
    private var spawnDelay: CGFloat
    
    init(template: Template, world: InactiveLispWorldController, spawnDelayDecay: CGFloat = 1) {
        self.template = template
        self.world = world
        self.spawnDelayDecay = spawnDelayDecay
        spawnDelay = 0
    }
    
    func update(deltaTime: CGFloat) {
        spawnDelay -= deltaTime
        
        if spawnDelay <= 0 {
            spawnAndDelay()
        }
    }
    
    private func spawnAndDelay() {
        LispSpawner.spawn(template.getNextExpr(), in: world)
        spawnDelay += Random.within(
            min: LispSpawner.fullMinSpawnDelay * spawnDelayDecay,
            max: LispSpawner.fullMaxSpawnDelay * spawnDelayDecay
        )
    }
}
