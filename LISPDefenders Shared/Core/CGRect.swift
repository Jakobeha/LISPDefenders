//
//  CGRect.swift
//  lAzR4t
//
//  Created by Jakob Hain on 10/8/17.
//  Copyright © 2017 Jakob Hain. All rights reserved.
//

import SpriteKit

extension CGRect {
    static func /(_ a: CGRect, _ scale: CGSize) -> CGRect {
        return CGRect(
            x: a.minX / scale.width,
            y: a.minY / scale.height,
            width: a.width / scale.width,
            height: a.height / scale.height
        )
    }
    
    var center: CGPoint { return CGPoint(x: midX, y: midY) }
}
