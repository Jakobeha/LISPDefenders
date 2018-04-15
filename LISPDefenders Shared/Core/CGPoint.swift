//
//  CGPoint.swift
//  lAzR4t
//
//  Created by Jakob Hain on 10/1/17.
//  Copyright © 2017 Jakob Hain. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    static func +(_ a: CGPoint, _ b: CGSize) -> CGPoint {
        return CGPoint(
            x: a.x + b.width,
            y: a.y + b.height
        )
    }
    
    static func -(_ a: CGPoint, _ b: CGPoint) -> CGSize {
        return CGSize(
            width: a.x - b.x,
            height: a.y - b.y
        )
    }
    
    static func *(_ a: CGPoint, _ scale: CGFloat) -> CGPoint {
        return CGPoint(
            x: a.x * scale,
            y: a.y * scale
        )
    }
    
    static func *(_ a: CGPoint, _ scale: CGSize) -> CGPoint {
        return CGPoint(
            x: a.x * scale.width,
            y: a.y * scale.height
        )
    }
    
    init(size: CGSize) {
        self.init(x: size.width, y: size.height)
    }
}
