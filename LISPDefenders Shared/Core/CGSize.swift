//
//  CGSize.swift
//  lAzR4t
//
//  Created by Jakob Hain on 9/30/17.
//  Copyright © 2017 Jakob Hain. All rights reserved.
//

import CoreGraphics

extension CGSize {
    static let infinite: CGSize = CGSize(width: CGFloat.infinity, height: CGFloat.infinity)
    
    static func +(_ a: CGSize, _ b: CGSize) -> CGSize {
        return CGSize(
            width: a.width + b.width,
            height: a.height + b.height
        )
    }
    
    static func *(_ a: CGSize, _ scale: CGFloat) -> CGSize {
        return CGSize(
            width: a.width * scale,
            height: a.height * scale
        )
    }
    
    static func /(_ a: CGSize, _ scale: CGFloat) -> CGSize {
        return CGSize(
            width: a.width / scale,
            height: a.height / scale
        )
    }
    
    static func /(_ a: CGSize, _ scale: CGSize) -> CGSize {
        return CGSize(
            width: a.width / scale.width,
            height: a.height / scale.height
        )
    }
}
