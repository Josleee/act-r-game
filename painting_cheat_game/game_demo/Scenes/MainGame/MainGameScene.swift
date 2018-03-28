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
    private var backgroundCloudNoOne : SKSpriteNode!
    private var backgroundCloudNoTwo : SKSpriteNode!
    private var backgroundMontains : SKSpriteNode!
    private var backgroundPlayers : SKSpriteNode!
    
    private var picture1 : SKSpriteNode!
    private var picture2 : SKSpriteNode!
    private var pictureHumanValueLabel : SKLabelNode!
    private var pictureAIValueLabel : SKLabelNode!
    
    private var movableNode : SKNode?
    private var originalPosition : CGPoint!
    
    private var humanTurn : Bool = true
    private var newGame : Bool = false
   // private var gameWinner : Int!
    
    private var btnFold : SKSpriteNode!
    private var btnRaise : SKSpriteNode!
    
    private var hintYourTurn : SKSpriteNode!
    private var hintInvalidRaise : SKSpriteNode!
    
    private var game : GameHandler!
    private var backgroundMusic: SKAudioNode!
    private var soundCoins : SKAction!
    private var soundCoins2 : SKAction!



    private let moveNodeUp = SKAction.moveBy(x: 0, y: 10, duration: 0.2)
    private let moveNodeDown = SKAction.moveBy(x: 0, y: -10, duration: 0.2)
    private let scaleUpAlongY = SKAction.scaleY(to: 0.8, duration: 0.2)
    private let scaleDownAlongY = SKAction.scaleY(to: 1.25, duration: 0.2)
    
    
    
    //***BACKGROUND-MAGIC*********************************************************************
    //****************************************************************************************
    
    //Load everything (paintings, background, players,..)
    override func didMove(to view: SKView) {
        // Initialize game
        game = GameHandler()
        game.newRandomGame()

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
        soundCoins = SKAction.playSoundFileNamed("Coin1.mp3", waitForCompletion: false)
        soundCoins2 = SKAction.playSoundFileNamed("Coin2.mp3", waitForCompletion: false)
        
        // Load two buttons
        btnFold = SKSpriteNode(imageNamed: "fold")
        btnFold.size = CGSize(width: (btnFold.size.width / 2), height: (btnFold.size.height / 2))
        btnFold.position = CGPoint(x: 270, y: -145)
        btnFold.name = "btn_fold"
        btnFold.zPosition = 1
        self.addChild(btnFold)
        
        btnRaise = SKSpriteNode(imageNamed: "raise")
        btnRaise.size = CGSize(width: (btnRaise.size.width / 2), height: (btnRaise.size.height / 2))
        btnRaise.position = CGPoint(x: 210, y: -145)
        btnRaise.name = "btn_raise"
        btnRaise.zPosition = 1
        self.addChild(btnRaise)
        
        // Load paintings
        loadPaintings()
        loadPaintingValueLabels()
        
        // Load hints
        hintYourTurn = SKSpriteNode(imageNamed: "YourTurn")
        hintYourTurn.size = CGSize(width: (hintYourTurn.size.width / 2), height: (hintYourTurn.size.height / 2))
        hintYourTurn.zPosition = 3
        hintYourTurn.position = CGPoint(x: 0, y: 145)
        hintYourTurn.isHidden = true
        self.addChild(hintYourTurn)
        
        hintInvalidRaise = SKSpriteNode(imageNamed: "InvalidRaise")
        hintInvalidRaise.size = CGSize(width: (hintInvalidRaise.size.width / 2), height: (hintInvalidRaise.size.height / 2))
        hintInvalidRaise.zPosition = 3
        hintInvalidRaise.position = CGPoint(x: 0, y: 145)
        hintInvalidRaise.isHidden = true
        self.addChild(hintInvalidRaise)
        
        // Add coins generator
        gameTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(addCoins), userInfo: nil, repeats: true)
        let wait = SKAction.wait(forDuration: 2)
        let action = SKAction.run {
            self.moveCoins(numberOfCoins: 1, humanPlayer: false)
            self.moveCoins(numberOfCoins: 1, humanPlayer: true)
            self.showHintYourTurn()
        }
        run(SKAction.sequence([wait,action]))
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
    
    
    func loadPaintingValueLabels() {
        if pictureHumanValueLabel != nil {
            pictureHumanValueLabel.removeFromParent()
        }
        if pictureAIValueLabel != nil {
            pictureAIValueLabel.removeFromParent()
        }

        //get humanpainting value, but hide it
        pictureHumanValueLabel = SKLabelNode(fontNamed: "Chalkduster")
        pictureHumanValueLabel.fontSize = 50
        pictureHumanValueLabel.position = CGPoint(x: -60, y: 70)
        pictureHumanValueLabel.text = String(game.getHumanPaintingValue())
        pictureHumanValueLabel.zPosition = 2
        pictureHumanValueLabel.isHidden = true
        self.addChild(pictureHumanValueLabel)
        
        //get AI painting value
        pictureAIValueLabel = SKLabelNode(fontNamed: "Chalkduster")
        pictureAIValueLabel.fontSize = 50
        pictureAIValueLabel.position = CGPoint(x: 60, y: 70)
        pictureAIValueLabel.text = String(game.getAIPaintingValue())
        pictureAIValueLabel.zPosition = 2
        self.addChild(pictureAIValueLabel)
    }
    
    func loadPaintings() {
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
    
    //***GAME (coins, card, hint, ...) *********************************************************************
    //****************************************************************************************
    
    
    func resetCoins(humanPlayerWin : Bool) {
        for child in self.children {
            if let spriteNode = child as? SKSpriteNode {
                if (spriteNode.name?.range(of:"coin") != nil) {
                    if ((spriteNode.position.x >= -self.scene!.size.width / 2 + 90) &&
                        (spriteNode.position.x <= self.scene!.size.width / 2 - 90)) {
                        var position : CGPoint
                        if (humanPlayerWin) {
                            position = findAvailablePositionForCoins(x1: -self.scene!.size.width / 2 + 35, x2: -self.scene!.size.width / 2 + 60)
                        } else {
                            position = findAvailablePositionForCoins(x1: self.scene!.size.width / 2 - 35, x2: self.scene!.size.width / 2 - 60)
                        }
                        let moveAction = SKAction.move(to: position, duration: 0.35)
                        moveAction.timingMode = SKActionTimingMode.easeInEaseOut
                        
                        // Place temp node
                        let tempNode = SKSpriteNode()
                        tempNode.name = "tmpNode"
                        tempNode.position = position
                        tempNode.size = spriteNode.size
                        self.addChild(tempNode)
                        
                        // print(self.children.count)
                        // Run animation
                        spriteNode.run(moveAction)
                        run(soundCoins)
                    }
                }
            }
        }
        
        // Remove all temp nodes
        for child in self.children {
            if let spriteNode = child as? SKSpriteNode {
                if (spriteNode.name?.range(of:"tmp") != nil) {
                    spriteNode.removeFromParent()
                }
            }
        }
    }
    
    
    func moveCoins(numberOfCoins : Int, humanPlayer : Bool) {
        var count : Int = 0
        for child in self.children {
            if let spriteNode = child as? SKSpriteNode {
                if (spriteNode.name?.range(of:"coin") != nil) {
                    if (((spriteNode.position.x <= -self.scene!.size.width / 2 + 90) || (spriteNode.position.x >= self.scene!.size.width / 2 - 90))
                        && ((spriteNode.position.x > 0) == !humanPlayer)) {
                        if (count >= numberOfCoins) {
                            return
                        } else {
                            count += 1
                        }
                        
                        let position : CGPoint = CGPoint(x: CGFloat(Int(arc4random_uniform(240)) - Int(120)),
                                                         y: CGFloat(-Int(arc4random_uniform(45)) - Int(115)))
                        let moveAction = SKAction.move(to: position, duration: 0.35)
                        moveAction.timingMode = SKActionTimingMode.easeInEaseOut
                        // Run animation
                        spriteNode.run(moveAction)
                        self.run(soundCoins2)
                    }
                }
            }
        }
    }
    
    func findAvailablePositionForCoins(x1 : CGFloat, x2 : CGFloat) -> CGPoint {
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
                if (spriteNode.name?.range(of:"coin") != nil || spriteNode.name?.range(of:"tmp") != nil) {
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
    

    func showHintInvalidRaise() {
        var isOpShow : Bool = false
        if hintYourTurn.isHidden == false {
            hintYourTurn.isHidden = true
            isOpShow = true
        }
        
        hintInvalidRaise.isHidden = false
        let wait = SKAction.wait(forDuration:2)
        let action = SKAction.run {
            self.hintInvalidRaise.isHidden = true
            if isOpShow {
                self.showHintYourTurn()
            }
        }
        run(SKAction.sequence([wait,action]))
    }
    
    func showHintYourTurn() {
        var isOpShow : Bool = false
        if hintInvalidRaise.isHidden == false {
            hintInvalidRaise.isHidden = true
            isOpShow = true
        }
        
        hintYourTurn.isHidden = false
        let wait = SKAction.wait(forDuration:5)
        let action = SKAction.run {
            self.hintYourTurn.isHidden = true
            if isOpShow {
                self.showHintInvalidRaise()
            }
        }
        run(SKAction.sequence([wait,action]))
    }
    

    
    
    func checkWinner() -> Bool {
        let gameSceneTemp = CongratsScene(fileNamed: "CongratsScene")

        if (GameData.shared.winner == .HumanPlayer) {
            print("Human wins!!!")
            self.scene?.view?.presentScene(gameSceneTemp!, transition: SKTransition.crossFade(withDuration: 0.5))
            return true
            
        } else if (GameData.shared.winner == .AIPlayer) {
            print("AI wins!!!")
            self.scene?.view?.presentScene(gameSceneTemp!, transition: SKTransition.crossFade(withDuration: 0.5))
            return true
            
        } else {
            return false
        }
    }
    
    func endOneRound() {
        flipCard(node: picture1)
        pictureHumanValueLabel.isHidden = false
    }
    
    func checkGameState(showPocker : Bool = false) -> Bool {
        if (game.isFinished()) {
            //let winner : Int = game.endGame()
            game.endGameAndSetWinner()
            
            if (GameData.shared.winner == .HumanPlayer) {
                resetCoins(humanPlayerWin: true)
            } else if (GameData.shared.winner == .AIPlayer) {
                resetCoins(humanPlayerWin: false)
            } else {
                // End in draw
            }
            game.setWinnerAccordingToCoins()
            game.printPaintingValues()
            
            if showPocker {
                self.loadPaintingValueLabels()
                if (game.getHumanCoins() > 0 && game.getAICoins() > 0) {
                    let wait = SKAction.wait(forDuration:1)
                    let action = SKAction.run {
                        self.loadPaintingValueLabels()
                        self.moveCoins(numberOfCoins: 1, humanPlayer: true)
                        self.moveCoins(numberOfCoins: 1, humanPlayer: false)
                    }
                    run(SKAction.sequence([wait,action]))
                }
            }
            endOneRound()

            game.newRandomGame()
            newGame = true
            return true
        } else {
            return false
        }
    }
    
    //***BACKGROUND-MAGIC*********************************************************************
    //****************************************************************************************
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Tap to start new game
        if newGame {
            if checkWinner() {
                return
            }
            
            if checkGameState(showPocker: true) {
                return
            }

            let wait = SKAction.wait(forDuration:1)
            let action = SKAction.run {
                self.loadPaintingValueLabels()
                self.moveCoins(numberOfCoins: 1, humanPlayer: true)
                self.moveCoins(numberOfCoins: 1, humanPlayer: false)
            }
            run(SKAction.sequence([wait,action]))
            newGame = false
            return
        }

        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodeArray = self.nodes(at: location)
            if (nodeArray.first?.name == "btn_raise" && humanTurn) {
                // Button animation
                nodeArray.first?.run(moveNodeUp)
                let wait = SKAction.wait(forDuration:0.25)
                let action = SKAction.run {
                    nodeArray.first?.run(self.moveNodeDown)
                }
                run(SKAction.sequence([wait,action]))

                var coinsToRaise : Int = 0
                for child in self.children {
                    if let spriteNode = child as? SKSpriteNode {
                        if (spriteNode.name?.range(of:"coin") != nil) {
                            if (spriteNode.position.x > -self.scene!.size.width / 2 + 90 &&
                                spriteNode.position.x < self.scene!.size.width / 2 - 90) {
                                coinsToRaise += 1
                            }
                        }
                    }
                }
                // When human doesn't has any coin
                if (game.getHumanCoins() == 0) {
                    _ = self.checkGameState()
                    humanTurn = false
                    return
                }
                // When opponent doesn't has coins
                if (game.getAICoins() == 0) {
                    if ((coinsToRaise - game.getCoinsInPot()) == game.getLastRaise()) {
                        game.humanRaise(coinsAmount: coinsToRaise - game.getCoinsInPot())
                        _ = self.checkGameState()
                        humanTurn = false
                        return
                    } else {
                        showHintInvalidRaise()
                        print("Invalid raise")
                        return
                    }
                }
                // When human player doesn't have enought coins
                if (game.getHumanCoins() < game.getLastRaise()) {
                    if ((coinsToRaise - game.getCoinsInPot()) == game.getHumanCoins()) {
                        game.humanRaise(coinsAmount: coinsToRaise - game.getCoinsInPot())
                        _ = self.checkGameState()
                        humanTurn = false
                        return
                    } else {
                        showHintInvalidRaise()
                        print("Invalid raise")
                        return
                    }
                }
                // Normal condition
                if ((coinsToRaise - game.getCoinsInPot()) >= game.getLastRaise()) {
                    if ((((coinsToRaise - game.getCoinsInPot()) == game.getLastRaise()) && game.getLastRaise() != 0) ||
                        game.listRaiseAmount.contains(coinsToRaise - game.getCoinsInPot())) {
                        game.humanRaise(coinsAmount: coinsToRaise - game.getCoinsInPot())
                        _ = self.checkGameState()
                        humanTurn = false
                        return
                    } else {
                        showHintInvalidRaise()
                        print("Invalid raise")
                        return
                    }
                } else {
                    showHintInvalidRaise()
                    print("Invalid raise")
                    return
                }
            } else if (nodeArray.first?.name == "btn_fold" && humanTurn) {
                // Button animation
                nodeArray.first?.run(scaleUpAlongY)
                let wait = SKAction.wait(forDuration:0.25)
                let action = SKAction.run {
                    nodeArray.first?.run(self.scaleDownAlongY)
                }
                run(SKAction.sequence([wait,action]))
                
                game.fold(isHumanPlayer: true)
                resetCoins(humanPlayerWin: false)
                
                game.setWinnerAccordingToCoins()
                game.printPaintingValues()
                endOneRound()

                game.newRandomGame()
                humanTurn = false
                newGame = true
                return
            }
        }
        
        
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
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodeArray = self.nodes(at: location)
            if (nodeArray.first?.name == "btn_raise") {
                movableNode = nil
                return
            } else if (nodeArray.first?.name == "btn_fold") {
                movableNode = nil
                return
            }
        }

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
                if (location.y > -115 || location.x < -self.scene!.size.width / 2 + 90 || location.x > self.scene!.size.width / 2 - 90) {
                    movableNode?.position = originalPosition
                } else {
                    self.run(soundCoins2)
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
        // Move clouds
        moveClouds()
        
        // Stop timer
        if(isInitializingCoins == false) {
            if(gameTimer != nil) {
                gameTimer.invalidate()
                gameTimer = nil
            }
        }
        
        if (!humanTurn && !newGame) {
            let wait = SKAction.wait(forDuration:2)
            let action = SKAction.run {
                let AIRaiseAmount : Int = self.game.AIrandomlyRaise()
                print("AI raised coins: ", String(AIRaiseAmount))
                self.moveCoins(numberOfCoins: AIRaiseAmount, humanPlayer: false)
            }
            run(SKAction.sequence([wait,action]))
            
            let wait2 = SKAction.wait(forDuration:3)
            let action2 = SKAction.run {
                _ = self.checkGameState()
                self.showHintYourTurn()
            }
            run(SKAction.sequence([wait2,action2]))
            humanTurn = true
        }
    }
}
