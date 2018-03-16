//
//  GameScene.swift
//  game_demo
//
//  Created by Jed on 15/03/2018.
//  Copyright © 2018 Jed. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    private var bigCoins : SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        let myLabel = SKLabelNode(fontNamed: "Chalkduster")
        myLabel.text = "HEllo!@"
        myLabel.fontSize = 65
        print(self.frame.size.width)
        print(self.frame.size.height)
        myLabel.position = CGPoint(x: 0, y: 0)
        self.addChild(myLabel)
        
        bigCoins = SKSpriteNode(imageNamed: "bc")
        bigCoins.position = CGPoint(x: 0, y: 0)
        self.addChild(bigCoins)

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameSceneTemp = MainGameScene(fileNamed: "MainGameScene")
        self.scene?.view?.presentScene(gameSceneTemp!, transition: SKTransition.crossFade(withDuration: 3))
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
