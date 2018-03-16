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
    
    override func didMove(to view: SKView) {
        let myLabel = SKLabelNode(fontNamed: "Chalkduster")
        myLabel.text = "Welcome to Painting Cheat @~@"
        myLabel.fontSize = 30
        print(self.frame.size.width)
        print(self.frame.size.height)
        myLabel.position = CGPoint(x: 0, y: 0)
        self.addChild(myLabel)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameSceneTemp = MainGameScene(fileNamed: "MainGameScene")
        self.scene?.view?.presentScene(gameSceneTemp!, transition: SKTransition.crossFade(withDuration: 1))
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
