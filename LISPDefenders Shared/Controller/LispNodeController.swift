//
//  LispNodeController.swift
//  LISPDefenders
//
//  Created by Jakob Hain on 4/14/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import SpriteKit

class LispNodeController: LispController {
    private static func newNode(expr: DLocdSExpr, posn: CGPoint) -> SKNode {
        let interNode = SKLabelNode(text: expr.print)
        interNode.horizontalAlignmentMode = .left
        interNode.verticalAlignmentMode = .bottom
        interNode.fontName = LispController.fontName
        interNode.fontSize = LispController.fontSize
        interNode.zPosition = ZPositions.lisp
        return interNode.multilined()
    }
    
    override var expr: DLocdSExpr { didSet {
        let nextNode = LispNodeController.newNode(expr: expr, posn: posn)
        if let parent = _node.parent {
            parent.addChild(nextNode)
            _node.removeFromParent()
        }
        _node = nextNode
    } }
    
    override var posn: CGPoint { didSet {
        _node.position = posn
    } }
    
    var node: SKNode {
        return _node
    }
    private var _node: SKNode
    
    init(expr: DLocdSExpr, posn: CGPoint) {
        _node = LispNodeController.newNode(expr: expr, posn: posn)
        super.init(expr: expr, posn: posn)
    }
}
