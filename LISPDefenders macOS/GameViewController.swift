//
//  GameViewController.swift
//  LISPDefenders macOS
//
//  Created by Jakob Hain on 4/14/18.
//  Copyright © 2018 Jakobeha. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController {
    private var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene.newGameScene()
        
        // Present the scene
        skView = self.view as! SKView
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        
        //skView.showsFPS = true
        //skView.showsNodeCount = true
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        skView.window!.acceptsMouseMovedEvents = true;
        skView.window!.makeFirstResponder(skView.scene)
    }
}

