//
//  LispWorldController.swift
//  LISPDefenders
//
//  Created by Jakob Hain on 4/14/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import SpriteKit

class LispWorldController: InactiveLispWorldController {
    var spawner: LispSpawner!
    
    init(status: StatusController, template: Template, scene: SKNode, bufferNode: SKNode) {
        super.init(status: status, scene: scene, bufferNode: bufferNode)
        spawner = LispSpawner(
            template: template,
            world: self,
            totalPoints: status.status.totalPoints
        )
    }
    
    override func update(deltaTime: CGFloat) {
        if isRunning {
            spawner.update(deltaTime: deltaTime)
        }
        super.update(deltaTime: deltaTime)
    }
    
    override func handle(newStatus: GameStatus) {
        super.handle(newStatus: newStatus)
        
        spawner?.totalPoints = status.status.totalPoints
    }
}
