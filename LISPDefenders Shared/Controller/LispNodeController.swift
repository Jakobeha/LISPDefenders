//
//  LispNodeController.swift
//  LISPDefenders
//
//  Created by Jakob Hain on 4/14/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import SpriteKit

class LispNodeController {
    static let font: SKFont = SKFont(name: fontName, size: fontSize)!
    static let fontName: String = "Menlo"
    static let fontSize: CGFloat = 36
    
    static func boundsOf(expr: DLocdSExpr) -> CGSize {
        return (expr.print as NSString).size(withAttributes: [.font: LispNodeController.font])
    }
    
    private static func newNode(expr: DLocdSExpr, posn: CGPoint) -> (SKNode, CGSize) {
        let interNode = SKLabelNode(text: expr.print)
        interNode.fontName = LispNodeController.fontName
        interNode.fontSize = LispNodeController.fontSize
        interNode.zPosition = ZPositions.lisp
        return interNode.multilined()
    }
    
    var expr: DLocdSExpr { didSet {
        let (nextNode, nextSize) = LispNodeController.newNode(expr: expr, posn: posn)
        if let parent = _node.parent {
            parent.addChild(nextNode)
            _node.removeFromParent()
        }
        _node = nextNode
        _size = nextSize
    } }
    
    var posn: CGPoint { didSet {
        _node.position = posn
    } }
    
    var node: SKNode {
        return _node
    }
    private var _node: SKNode
    var size: CGSize {
        return _size
    }
    private var _size: CGSize
    
    var frame: CGRect {
        return CGRect(
            x: posn.x - (size.width / 2),
            y: posn.y,
            width: size.width,
            height: size.height
        )
    }
    
    init(expr: DLocdSExpr, posn: CGPoint) {
        self.expr = expr
        self.posn = posn
        (_node, _size) = LispNodeController.newNode(expr: expr, posn: posn)
    }
}
