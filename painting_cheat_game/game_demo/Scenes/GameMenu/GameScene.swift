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

    override func didMove(to view: SKView) {
        // print(self.frame.size.width)
        // print(self.frame.size.height)
        let myLabel = SKLabelNode(fontNamed: "Chalkduster")
        myLabel.text = "Welcome to Painting Cheat @~@"
        myLabel.fontSize = 25
        myLabel.position = CGPoint(x: 0, y: 10)
        self.addChild(myLabel)
        
        let startLabel = SKLabelNode(fontNamed: "Chalkduster")
        startLabel.text = "Tap screen to start game"
        startLabel.fontSize = 17
        startLabel.position = CGPoint(x: 0, y: -35)
        self.addChild(startLabel)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameSceneTemp = MainGameScene(fileNamed: "MainGameScene")
        self.scene?.view?.presentScene(gameSceneTemp!, transition: SKTransition.flipVertical(withDuration: 1))
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
