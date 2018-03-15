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
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    private var background : SKSpriteNode!
    private var bigCoins : SKSpriteNode!
    private var bigCoins2 : SKSpriteNode!

    private var gameTimer : Timer!

    
    override func didMove(to view: SKView) {
        print("Enter didMove")
        // Add background
        background = SKSpriteNode(imageNamed: "Backgroundnoc")
        background.size = CGSize(width: (self.scene!.size.width), height: (self.scene!.size.height))
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -1
        self.addChild(background)
        
//        let myLabel = SKLabelNode(fontNamed: "Chalkduster")
//        myLabel.text = "SecondScene!@"
//        myLabel.fontSize = 65
//        myLabel.position = CGPoint(x: 0, y: 0)
//        self.addChild(myLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(addCoins), userInfo: nil, repeats: true)
    }
    
    //        let randomAlienPosition = GKRandomDistribution(lowestValue: 0, highestValue: 414)
    //        let position = CGFloat(randomAlienPosition.nextInt())
    
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
        // Add Children
        self.addChild(lCoin)
        self.addChild(rCoin)
        self.addChild(l2Coin)
        self.addChild(r2Coin)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Stop timer
        if(isInitializingCoins == false) {
            if(gameTimer != nil) {
                gameTimer.invalidate()
                gameTimer = nil
            }
        }
        
    }
}
