//
//  ProjectileController.swift
//  LISPDefenders
//
//  Created by Jakob Hain on 4/15/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import SpriteKit

class ProjectileController {
    static let speed: CGFloat = 1024
    static let font: SKFont = SKFont(name: fontName, size: fontSize)!
    static let fontName: String = "Menlo"
    static let fontSize: CGFloat = 48
    
    private static func newNode(item: SEmoji, posn: CGPoint) -> SKLabelNode {
        let res = SKLabelNode(text: item.print)
        res.fontName = ProjectileController.fontName
        res.fontSize = ProjectileController.fontSize
        res.zPosition = ZPositions.projectile
        return res
    }
    
    var item: SEmoji { didSet {
        node.text = item.print
    } }
    var posn: CGPoint { didSet {
        node.position = posn
    } }
    var direction: CGFloat
    var node: SKLabelNode
    
    var vel: CGSize {
        return CGSize(magnitude: ProjectileController.speed, direction: direction)
    }
    
    init(item: SEmoji, posn: CGPoint, direction: CGFloat) {
        self.item = item
        self.posn = posn
        self.direction = direction
        node = ProjectileController.newNode(item: item, posn: posn)
    }
    
    func update(deltaTime: CGFloat) {
        posn = posn + (vel * deltaTime)
        
        
        if (node.frame.minX <= node.parent!.bounds.minX && vel.width < 0) ||
            (node.frame.maxX >= node.parent!.bounds.maxX && vel.width > 0) {
            //Moving out of screen X - "bounce"
            direction = -direction
        }
        
        //TODO Handle colisions
    }
}
