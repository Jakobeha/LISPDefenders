//
//  GameScene.swift
//  LISPDefenders Shared
//
//  Created by Jakob Hain on 4/14/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var cannon: CannonController?
    var status: StatusController?
    var world : LispWorldController?
    var prevTime: TimeInterval?
    
    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .resizeFill
        
        return scene
    }
    
    func setUpScene() {
        let statusNode = childNode(withName: "status")! as! SKLabelNode
        status = StatusController(status: GameStatus.initial, node: statusNode, onSetStatus: { newStatus in
            return self.world!.handle(newStatus: newStatus)
        })
        let bufferNode = childNode(withName: "buffer")!
        world = LispWorldController(
            status: status!,
            template: Template.parse(fileWithName: "Standard"),
            scene: self,
            bufferNode: bufferNode
        )
        let cannonNode = childNode(withName: "cannon")!
        cannon = CannonController(
            onFire: world!.add,
            cannonNode: cannonNode,
            baseNode: cannonNode.childNode(withName: "base")!,
            headNode: cannonNode.childNode(withName: "head")! as! SKSpriteNode,
            itemNode: cannonNode.childNode(withName: "item")! as! SKLabelNode
        )
    }
    
    override func didMove(to view: SKView) {
        setUpScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let prevTime = prevTime {
            let deltaTime = CGFloat(currentTime - prevTime)
            
            world?.update(deltaTime: deltaTime)
        }
        
        prevTime = currentTime
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let cannon = cannon else {
            return
        }
        
        if event == nil || event!.allTouches == touches {
            let touch = touches.first!
            cannon.isEnabled = true
            cannon.point(at: touch.location(in: self))
        } else {
            //Multi-touch
            cannon.isEnabled = false
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let cannon = cannon else {
            return
        }
        
        if cannon.isEnabled {
            let touch = touches.first!
            cannon.point(at: touch.location(in: cannon.baseNode))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let cannon = cannon else {
            return
        }
        
        if cannon.isEnabled {
            let touch = touches.first!
            cannon.point(at: touch.location(in: cannon.baseNode))
            cannon.fire()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let cannon = cannon else {
            return
        }
        
        let touch = touches.first!
        cannon.point(at: touch.location(in: cannon.baseNode))
    }
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {
    override func mouseDown(with event: NSEvent) {
        guard let cannon = cannon else {
            return
        }
        
        cannon.point(at: event.location(in: cannon.baseNode))
    }
    
    override func mouseMoved(with event: NSEvent) {
        guard let cannon = cannon else {
            return
        }
        
        cannon.point(at: event.location(in: cannon.baseNode))
    }
    
    override func mouseUp(with event: NSEvent) {
        guard let cannon = cannon else {
            return
        }
        
        cannon.point(at: event.location(in: cannon.baseNode))
        cannon.fire()
    }
}
#endif
