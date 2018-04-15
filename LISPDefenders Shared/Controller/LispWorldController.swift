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
    
    init(template: Template, scene: SKNode) {
        super.init(scene: scene)
        spawner = LispSpawner(template: template, world: self)
    }
    
    override func update(deltaTime: CGFloat) {
        spawner.update(deltaTime: deltaTime)
        super.update(deltaTime: deltaTime)
    }
}
