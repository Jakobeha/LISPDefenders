//
//  SKNode.swift
//  LISPDefenders
//
//  Created by Jakob Hain on 4/14/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import SpriteKit

extension SKNode {
    //Assumes node is anchored in the center.
    var bounds: CGRect {
        return CGRect(origin: CGPoint(size: frame.size) * -0.5, size: frame.size)
    }
}
