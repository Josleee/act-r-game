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
    private var rulesBtn : SKLabelNode!
    private let moveNodeUp = SKAction.moveBy(x: 0, y: 10, duration: 0.2)
    private let moveNodeDown = SKAction.moveBy(x: 0, y: -10, duration: 0.2)
    
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
        
        rulesBtn = SKLabelNode(fontNamed: "text")
        rulesBtn.text = "Rules"
        rulesBtn.fontSize = 65
        rulesBtn.position = CGPoint(x: 270, y: -145)
        rulesBtn.name = "btn_rules"
        rulesBtn.zPosition = 1
        self.addChild(rulesBtn)
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameSceneTemp = MainGameScene(fileNamed: "MainGameScene")
        let rulesSceneTemp = RulesScene(fileNamed: "RulesScene")
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodeArray = self.nodes(at: location)
            
            //selected rules
            if (nodeArray.first?.name == "btn_rules") {
                print("selected RulesScene")
                // Button animation
                nodeArray.first?.run(moveNodeUp)
                let wait = SKAction.wait(forDuration:0.25)
                let action = SKAction.run {
                    nodeArray.first?.run(self.moveNodeDown)
                }
                run(SKAction.sequence([wait,action]))
                self.scene?.view?.presentScene(rulesSceneTemp!, transition: SKTransition.flipVertical(withDuration: 1))
                
            } else { //maingame
                self.scene?.view?.presentScene(gameSceneTemp!, transition: SKTransition.flipVertical(withDuration: 1))
            }
        
        
            
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
