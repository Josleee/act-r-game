//
//  MenuScene.swift
//  game_demo
//
//  Created by Jed on 15/03/2018.
//  Copyright © 2018 Jed. All rights reserved.
//

import SpriteKit
//import GameplayKit
import Foundation

class MainGameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    private var background : SKSpriteNode!
    private var bigCoins : SKSpriteNode!
    private var bigCoins2 : SKSpriteNode!

    override func didMove(to view: SKView) {
        background = SKSpriteNode(imageNamed: "Background")
        background.size = CGSize(width: (self.scene!.size.width), height: (self.scene!.size.height))
        background.position = CGPoint(x: 0, y: 0)
        self.addChild(background)
        
        let myLabel = SKLabelNode(fontNamed: "Chalkduster")
        myLabel.text = "SecondScene!@"
        myLabel.fontSize = 65
        //        myLabel.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        myLabel.position = CGPoint(x: 0, y: 0)
        self.addChild(myLabel)
        
        bigCoins = SKSpriteNode(imageNamed: "bc")
        //        bigCoins.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        bigCoins.position = CGPoint(x: 0, y: 0)
        self.addChild(bigCoins)
        bigCoins2 = SKSpriteNode(imageNamed: "bc")
        //        bigCoins.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        bigCoins2.position = CGPoint(x: 20, y: 20)
        self.addChild(bigCoins2)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
