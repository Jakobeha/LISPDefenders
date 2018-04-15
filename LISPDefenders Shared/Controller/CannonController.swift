//
//  CannonController.swift
//  LISPDefenders
//
//  Created by Jakob Hain on 4/15/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import SpriteKit

class CannonController {
    static func getNextItem(prev: SEmoji? = nil) -> SEmoji {
        let potential = SEmoji.neutralRand.fillIfRand()
        if potential != prev {
            return potential
        } else {
            return getNextItem(prev: prev)
        }
    }
    
    private let onFire: (ProjectileController) -> Void
    let cannonNode: SKNode
    let baseNode: SKNode
    let headNode: SKSpriteNode
    let itemNode: SKLabelNode
    var direction: CGFloat { didSet {
        headNode.zRotation = direction
    } }
    var item: SEmoji { didSet {
        itemNode.text = item.print
    } }
    var isEnabled: Bool
    
    private var parent: SKNode? {
        return cannonNode.parent
    }
    
    init(
        onFire: @escaping (ProjectileController) -> Void,
        cannonNode: SKNode,
        baseNode: SKNode,
        headNode: SKSpriteNode,
        itemNode: SKLabelNode
    ) {
        self.onFire = onFire
        self.cannonNode = cannonNode
        self.baseNode = baseNode
        self.headNode = headNode
        self.itemNode = itemNode
        direction = CGFloat.pi / 2
        item = CannonController.getNextItem()
        isEnabled = true
        
        cannonNode.zPosition = ZPositions.cannon //Just for safety
        headNode.zRotation = direction
        itemNode.text = item.print
    }
    
    func point(at headLoc: CGPoint) {
        direction = CGSize(point: headLoc).direction
    }
    
    func fire() {
        assert(parent != nil, "Can't fire projectile witout parent (for position)")
        
        let projectile = ProjectileController(
            item: item,
            posn: parent!.convert(CGPoint.zero, from: headNode),
            direction: direction
        )
        onFire(projectile)
        
        item = CannonController.getNextItem(prev: item)
    }
}
