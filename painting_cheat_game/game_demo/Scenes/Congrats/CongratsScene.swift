//
//  CongratsScene.swift
//  game_demo
//
//  Created by Jed on 17/03/2018.
//  Copyright © 2018 Jed. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class CongratsScene: SKScene {
    
    private var background : SKSpriteNode!
    private var backgroundCloudNoOne : SKSpriteNode!
    private var backgroundCloudNoTwo : SKSpriteNode!
    private var backgroundMontains : SKSpriteNode!
    private var backgroundPlayers : SKSpriteNode!
    private var backgroundMusic: SKAudioNode!
    
    override func didMove(to view: SKView) {
        // Add background
        createBackground()
        
        background = SKSpriteNode(imageNamed: "Background")
        background.size = CGSize(width: (self.scene!.size.width), height: (self.scene!.size.height))
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -10
        self.addChild(background)
        
        backgroundMontains = SKSpriteNode(imageNamed: "Montains")
        backgroundMontains.size = CGSize(width: (self.scene!.size.width), height: (self.scene!.size.height))
        backgroundMontains.position = CGPoint(x: 0, y: 0)
        backgroundMontains.zPosition = -2
        self.addChild(backgroundMontains)
        
        backgroundPlayers = SKSpriteNode(imageNamed: "Players")
        backgroundPlayers.size = CGSize(width: (self.scene!.size.width), height: (self.scene!.size.height))
        backgroundPlayers.position = CGPoint(x: 0, y: 0)
        backgroundPlayers.zPosition = -1
        self.addChild(backgroundPlayers)
        
        // Add background music
        if let musicURL = Bundle.main.url(forResource: "bgmusic", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: musicURL)
            backgroundMusic.autoplayLooped = true
            self.addChild(backgroundMusic)
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    func createBackground() {
        for i in 0...3 {
            let backgroundCloudNoOneLocal = SKSpriteNode(imageNamed: "CloudNoOne")
            backgroundCloudNoOneLocal.name = "CloudNoOne"
            backgroundCloudNoOneLocal.size = CGSize(width: (self.scene!.size.width), height: (self.scene!.size.height))
            backgroundCloudNoOneLocal.position = CGPoint(x: CGFloat(i) * (self.scene!.size.width), y: 0)
            backgroundCloudNoOneLocal.zPosition = -3
            self.addChild(backgroundCloudNoOneLocal)
            
            let backgroundCloudNoTwoLocal = SKSpriteNode(imageNamed: "CloudNoTwo")
            backgroundCloudNoTwoLocal.name = "CloudNoTwo"
            backgroundCloudNoTwoLocal.size = CGSize(width: (self.scene!.size.width), height: (self.scene!.size.height))
            backgroundCloudNoTwoLocal.position = CGPoint(x: CGFloat(i) * (self.scene!.size.width), y: 0)
            backgroundCloudNoTwoLocal.zPosition = -3
            self.addChild(backgroundCloudNoTwoLocal)
        }
    }
    
    
    func moveClouds() {
        self.enumerateChildNodes(withName: "CloudNoOne", using: ({ (node, error) in
            node.position.x -= 0.5
            
            if node.position.x < -(self.scene!.size.width) {
                node.position.x += (self.scene!.size.width) * 3
            }
        }))
        self.enumerateChildNodes(withName: "CloudNoTwo", using: ({ (node, error) in
            node.position.x -= 0.8
            
            if node.position.x < -(self.scene!.size.width) {
                node.position.x += (self.scene!.size.width) * 3
            }
        }))
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Move clouds
        moveClouds()
    }
}
