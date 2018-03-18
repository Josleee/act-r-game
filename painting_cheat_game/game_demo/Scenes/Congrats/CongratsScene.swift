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
    private var backgroundMusic : SKAudioNode!
    
    private var character : SKSpriteNode!
    private var hint : SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        // Set gravity
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        
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

        // Add background music
        if let musicURL = Bundle.main.url(forResource: "bgmusic", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: musicURL)
            backgroundMusic.autoplayLooped = true
            self.addChild(backgroundMusic)
        }
        
        createCharacter()
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        GameData.shared.winner = 0
        let gameSceneTemp = MainGameScene(fileNamed: "MainGameScene")
        self.scene?.view?.presentScene(gameSceneTemp!, transition: SKTransition.flipVertical(withDuration: 1))
    }
    
    
    func createCharacter() {
        if GameData.shared.winner == 1 {
            character = SKSpriteNode(imageNamed: "BoyJump")
            hint = SKSpriteNode(imageNamed: "HumanWins")
        } else {
            character = SKSpriteNode(imageNamed: "GirlJump")
            hint = SKSpriteNode(imageNamed: "AIWins")
        }
        character.size = CGSize(width: (character.size.width / 2), height: (character.size.height / 2))
        hint.size = CGSize(width: (hint.size.width / 2), height: (hint.size.height / 2))
        character.zPosition = 1
        hint.zPosition = 3
        hint.position = CGPoint(x: 0, y: 130)
        
        if GameData.shared.winner == 1 {
            character.position = CGPoint(x: -50, y: -20)
            playPartyPoppers(xCenter: -50)
        } else {
            character.position = CGPoint(x: 50, y: -20)
            playPartyPoppers(xCenter: 50)
        }
        self.addChild(character)
        self.addChild(hint)
    }
    
    
    func playPartyPoppers(xCenter : Int) {
        for _ in 1...1 {
            // Load colorful pieces
            for i in 1...11 {
                let cp = SKSpriteNode(imageNamed: "ppb" + String(i))
                let randomPosition = GKRandomDistribution(lowestValue: xCenter - 30, highestValue: xCenter + 30)
                let xPosition = CGFloat(randomPosition.nextInt())
                cp.name = "PartyPoppers"
                cp.position = CGPoint(x: xPosition, y: 130)
                cp.size = CGSize(width: (cp.size.width / 3), height: (cp.size.height / 3))
                cp.physicsBody = SKPhysicsBody(texture: cp.texture!, size: cp.texture!.size())
                cp.zPosition = 2
                self.addChild(cp)
            }
            
            // Load riband
            for i in 1...3 {
                let lb = SKSpriteNode(imageNamed: "ppl" + String(i))
                let randomPosition = GKRandomDistribution(lowestValue: -30, highestValue: 30)
                let xPosition = CGFloat(randomPosition.nextInt())
                lb.name = "PartyPoppers"
                lb.position = CGPoint(x: xPosition, y: 130)
                lb.size = CGSize(width: (lb.size.width / 2), height: (lb.size.height / 2))
                lb.physicsBody = SKPhysicsBody(texture: lb.texture!, size: lb.texture!.size())
                lb.zPosition = 2
                self.addChild(lb)
            }
        }
    }
    
    
    func createBackground() {
        for i in 0...2 {
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
                node.position.x += (self.scene!.size.width) * 2
            }
        }))
        self.enumerateChildNodes(withName: "CloudNoTwo", using: ({ (node, error) in
            node.position.x -= 0.8
            
            if node.position.x < -(self.scene!.size.width) {
                node.position.x += (self.scene!.size.width) * 2
            }
        }))
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Move clouds
        moveClouds()
    }
}
