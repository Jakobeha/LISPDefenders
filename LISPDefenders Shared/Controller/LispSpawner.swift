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
    static let difficultyGrowthChange: CGFloat = 4
    static let difficultyGrowthExponent: CGFloat = 1/250
    static let spawnDelayDecayChange: CGFloat = 0.5
    static let spawnDelayDecayExponent: CGFloat = 1/2500
    
    private static func difficultyScale(totalPoints: Int) -> CGFloat {
        return pow(
            LispSpawner.difficultyGrowthChange,
            CGFloat(totalPoints) * LispSpawner.difficultyGrowthExponent
        )
    }
    
    private static func spawnDelayDecay(totalPoints: Int) -> CGFloat {
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
    var totalPoints: Int
    private var spawnDelay: CGFloat
    
    init(template: Template, world: InactiveLispWorldController, totalPoints: Int = 0) {
        self.template = template
        self.world = world
        self.totalPoints = totalPoints
        spawnDelay = 0
    }
    
    func update(deltaTime: CGFloat) {
        spawnDelay -= deltaTime
        
        if spawnDelay <= 0 {
            spawnAndDelay()
        }
    }
    
    private func spawnAndDelay() {
        let difficultyScale = LispSpawner.difficultyScale(totalPoints: totalPoints)
        let spawnDecayDelay = LispSpawner.spawnDelayDecay(totalPoints: totalPoints)
        LispSpawner.spawn(template.getNextExpr(difficultyScale: difficultyScale), in: world)
        spawnDelay += Random.within(
            min: LispSpawner.fullMinSpawnDelay * spawnDecayDelay,
            max: LispSpawner.fullMaxSpawnDelay * spawnDecayDelay
        )
    }
}
