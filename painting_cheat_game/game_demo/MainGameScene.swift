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
import GameplayKit
import CoreMotion


class MainGameScene: SKScene {
    private var isInitializingCoins : Bool = true
    private var numberOfCoinsExist : Int = 0
    private var totalCoins : Int = 20
    private var coinSize: CGSize!
    
    private var gameTimer : Timer!
    private var background : SKSpriteNode!
    private var picture1 : SKSpriteNode!
    private var picture2 : SKSpriteNode!
    private var movableNode : SKNode?
    private var originalPosition : CGPoint!

    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        print("Enter didMove")
        // Add background
        background = SKSpriteNode(imageNamed: "Backgroundonlyp")
        background.size = CGSize(width: (self.scene!.size.width), height: (self.scene!.size.height))
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -1
        self.addChild(background)
        
        // Load paintings
        loadPics()
        
//        let myLabel = SKLabelNode(fontNamed: "Chalkduster")
//        myLabel.text = "SecondScene!@"
//        myLabel.fontSize = 65
//        myLabel.position = CGPoint(x: 0, y: 0)
//        self.addChild(myLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(addCoins), userInfo: nil, repeats: true)
    }
    
    func flipCard (node: SKNode){
        node.run(SKAction.sequence(
            [SKAction.fadeOut(withDuration: 0.1),
             SKAction.scaleX(to: 0, duration: 0.35),
             SKAction.scale(to: 1, duration: 0.0),
             SKAction.setTexture(SKTexture(imageNamed: "pic3")),
             SKAction.fadeIn(withDuration: 0.1),
             ]
        ))
    }
    
    //        let randomAlienPosition = GKRandomDistribution(lowestValue: 0, highestValue: 414)
    //        let position = CGFloat(randomAlienPosition.nextInt())
    
    func loadPics() {
        picture1 = SKSpriteNode(imageNamed: "pic1")
        picture2 = SKSpriteNode(imageNamed: "pic2")
        picture1.size = CGSize(width: (self.scene!.size.width / 6), height: (self.scene!.size.height / 5))
        picture2.size = CGSize(width: (self.scene!.size.width / 6), height: (self.scene!.size.height / 5))
        picture1.position = CGPoint(x: -60, y: 70)
        picture2.position = CGPoint(x: 60, y: 70)
        self.addChild(picture1)
        self.addChild(picture2)
    }
    
    @objc func addCoins() {
        // Count
        self.numberOfCoinsExist += 2
        if(self.numberOfCoinsExist > self.totalCoins) {
            self.isInitializingCoins = false
            return
        }
        // Add coins
        let lCoin = SKSpriteNode(imageNamed: "bc")
        let l2Coin = SKSpriteNode(imageNamed: "bc")
        let rCoin = SKSpriteNode(imageNamed: "bc")
        let r2Coin = SKSpriteNode(imageNamed: "bc")
        // Set size
        lCoin.size = CGSize(width: (lCoin.size.width / 2), height: (lCoin.size.height / 2))
        l2Coin.size = CGSize(width: (l2Coin.size.width / 2), height: (l2Coin.size.height / 2))
        rCoin.size = CGSize(width: (rCoin.size.width / 2), height: (rCoin.size.height / 2))
        r2Coin.size = CGSize(width: (r2Coin.size.width / 2), height: (r2Coin.size.height / 2))
        // Set position
        lCoin.position = CGPoint(x: -self.scene!.size.width / 2 + 35, y: (lCoin.size.height * CGFloat(self.numberOfCoinsExist) / 4 - 30))
        l2Coin.position = CGPoint(x: -self.scene!.size.width / 2 + 60, y: (lCoin.size.height * CGFloat(self.numberOfCoinsExist) / 4 - 30))
        rCoin.position = CGPoint(x: self.scene!.size.width / 2 - 35, y: (lCoin.size.height * CGFloat(self.numberOfCoinsExist) / 4 - 30))
        r2Coin.position = CGPoint(x: self.scene!.size.width / 2 - 60, y: (lCoin.size.height * CGFloat(self.numberOfCoinsExist) / 4 - 30))
        // Name the coins
        lCoin.name = "coin_l1_" + String(numberOfCoinsExist/2)
        l2Coin.name = "coin_l2_" + String(numberOfCoinsExist/2)
        rCoin.name = "coin_r1_" + String(numberOfCoinsExist/2)
        r2Coin.name = "coin_r2_" + String(numberOfCoinsExist/2)
        // Add Children
        self.addChild(lCoin)
        self.addChild(rCoin)
        self.addChild(l2Coin)
        self.addChild(r2Coin)
        // Set size
        coinSize = lCoin.size
    }
    
    
    func resetCoins(humanPlayerWin : Bool) {
        for child in self.children {
            if let spriteNode = child as? SKSpriteNode {
                if (spriteNode.name?.range(of:"coin") != nil) {
                    if (spriteNode.position.y <= -115) {
                        if (humanPlayerWin) {
                            let position = findAvailablePosition(x1: -self.scene!.size.width / 2 + 35, x2: -self.scene!.size.width / 2 + 60)
                            spriteNode.position = position
                        } else {
                            let position = findAvailablePosition(x1: self.scene!.size.width / 2 - 35, x2: self.scene!.size.width / 2 - 60)
                            spriteNode.position = position
                        }
                    }
                }
            }
        }
    }
    
    
    func findAvailablePosition(x1 : CGFloat, x2 : CGFloat) -> CGPoint {
        var count : Int = 0
        while true {
            var position : CGPoint
            position = CGPoint(x: x1, y: (coinSize.height * CGFloat(count) / 2 - 30))
            if checkWhetherHasCoin(position: position) {
                return position
            }
            position = CGPoint(x: x2, y: (coinSize.height * CGFloat(count) / 2 - 30))
            if checkWhetherHasCoin(position: position) {
                return position
            }
            position = CGPoint(x: x1, y: (-coinSize.height * CGFloat(count) / 2 - 30))
            if checkWhetherHasCoin(position: position) {
                return position
            }
            position = CGPoint(x: x2, y: (-coinSize.height * CGFloat(count) / 2 - 30))
            if checkWhetherHasCoin(position: position) {
                return position
            }
            // print("count: " + String(count))
            count += 1
        }
    }
    
    
    func checkWhetherHasCoin(position : CGPoint) -> Bool {
        var isContain : Bool = true
        var distanceInRange : Bool = true
        for child in self.children {
            if let spriteNode = child as? SKSpriteNode {
                if (spriteNode.name?.range(of:"coin") != nil) {
                    if (!spriteNode.contains(position)) {
                        continue
                    } else {
                        isContain = false
                        if (abs(position.y - spriteNode.position.y) > (spriteNode.size.height / 4)) {
                            continue
                        } else {
                            distanceInRange = false
                        }
                    }
                }
            }
        }
        if isContain == true || distanceInRange == true {
            return true
        } else {
            return false
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if (picture1.contains(location)) {
                resetCoins(humanPlayerWin: true)
            }
            
            for child in self.children {
                if let spriteNode = child as? SKSpriteNode {
                    if (spriteNode.name?.range(of:"coin") != nil) {
                        if (spriteNode.contains(location)) {
                            originalPosition = spriteNode.position
                            movableNode = spriteNode
                            movableNode!.position = location
                            return
                        }
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (movableNode != nil) {
            for touch in touches {
                let location = touch.location(in: self)
                movableNode?.position = location
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (movableNode != nil) {
            for touch in touches {
                let location = touch.location(in: self)
                if (location.y > -115) {
                    movableNode?.position = originalPosition
                } else {
                    movableNode?.position = location
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            movableNode = nil
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Stop timer
        if(isInitializingCoins == false) {
            if(gameTimer != nil) {
                flipCard(node: picture1)
                gameTimer.invalidate()
                gameTimer = nil
            }
        }
        
    }
}
