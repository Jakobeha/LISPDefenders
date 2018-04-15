//
//  FallingLispNodeController.swift
//  LISPDefenders
//
//  Created by Jakob Hain on 4/14/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import SpriteKit

class FallingLispNodeController: LispNodeController {
    static let velY: CGFloat = -72
    static let velXDiff: CGFloat = 48
    
    var velX: CGFloat
    
    var vel: CGSize {
        return CGSize(width: velX, height: FallingLispNodeController.velY)
    }
    
    override init(expr: DLocdSExpr, posn: CGPoint) {
        self.velX = Random.within(min: -FallingLispNodeController.velXDiff, max: FallingLispNodeController.velXDiff)
        super.init(expr: expr, posn: posn)
    }
    
    func update(deltaTime: CGFloat) {
        assert(node.parent != nil, "Can't move node without a parent.")
        
        posn = posn + (vel * CGFloat(deltaTime))
        
        if (frame.minX <= node.parent!.bounds.minX && velX < 0) ||
            (frame.maxX >= node.parent!.bounds.maxX && velX > 0) {
            //Moving out of screen X - "bounce"
            velX = -velX
        }
    }
}

