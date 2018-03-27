//
//  RulesScene.swift
//  game_demo
//
//  Created by E. Gassner on 3/27/18.
//  Copyright © 2018 Jed. All rights reserved.
//

import SpriteKit
import GameplayKit

class RulesScene: SKScene {
    private let moveNodeUp = SKAction.moveBy(x: 0, y: 10, duration: 0.2)
    private let moveNodeDown = SKAction.moveBy(x: 0, y: -10, duration: 0.2)
    
    private var startGameButton : SKLabelNode!
    
    override func didMove(to view: SKView) {
        // print(self.frame.size.width)
        // print(self.frame.size.height)
        let myLabel = SKLabelNode(fontNamed: "Chalkduster")
        myLabel.text = "Welcome to the rules"
        myLabel.fontSize = 25
        myLabel.position = CGPoint(x: 0, y: 10)
        self.addChild(myLabel)
        
       // startGameButton = SKSpriteNode(imageNamed: "startGame")
        startGameButton = SKLabelNode(fontNamed: "text")
        //startGameButton.size = CGSize(width: (startGameButton.size.width / 2), height: (startGameButton.size.height / 2))
        startGameButton.fontSize = 65
        startGameButton.position = CGPoint(x: 270, y: -145)
        startGameButton.name = "btn_startGame"
        startGameButton.text = "Start Game"
        startGameButton.fontSize = 65
        startGameButton.zPosition = 1
        self.addChild(startGameButton)
    }
    
    
    //if button to start game is pressed then start game
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let gameSceneTemp = MainGameScene(fileNamed: "MainGameScene")
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodeArray = self.nodes(at: location)
            
            //selected rules
            if (nodeArray.first?.name == "btn_startGame") {
                print("selected start game BUTTON")
                // Button animation
                nodeArray.first?.run(moveNodeUp)
                let wait = SKAction.wait(forDuration:0.25)
                let action = SKAction.run {
                    nodeArray.first?.run(self.moveNodeDown)
                }
                run(SKAction.sequence([wait,action]))
                self.scene?.view?.presentScene(gameSceneTemp!, transition: SKTransition.flipVertical(withDuration: 1))
            }
        }
    }
}
