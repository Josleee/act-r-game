//
//  RulesScene.swift
//  game_demo
//
//  Created by BlaueBeere on 3/27/18.
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
        

        startGameButton = SKLabelNode(fontNamed: "text")
        startGameButton.fontSize = 65
        startGameButton.position = CGPoint(x: 270, y: -145)
        startGameButton.name = "btn_startGame"
        startGameButton.text = "Start Game"
        startGameButton.fontSize = 65
        startGameButton.zPosition = 1
        self.addChild(startGameButton)
        
        
        //Rules txt // TODO: nice layout
        let myRules = SKLabelNode(fontNamed: "Chalkduster")
        myRules.text = "1 Introduction This game is a variation of the original ”indian poker” game. The value of the cards, which are numbers in the original game, are changed to be pictures with different values. 2.1 Start The game consists of two players, the human player and the model. Every player gets 25 coins in the beginning. Ten rounds are being played or until all coins are lost. There are in total 20 cards with pictures of a certain value. In each round each player gets one card and has to put it on their forehead, so that they can not see the image on the card themselves but each player can see the image of the other player. 2.2 Aim of the game The aim of the game is to posses a card which is more valuable than the op- ponents card. Because a player can not see their own card, they have to guess their cards value by looking at the opponents card and guessing the possibility of having a higher card or not. Now everyone has to guess if the value of the own card is higher than the value of the other player. Turns are switched after each round. 2.3 Bets Each round a player has to put in one coin to participate in the game. The first player is on turn and guesses his/her own cards value. Dependant on this he/she has to place a bet. Possible bets are: 1,2, 3 coins. 2.4 Possible moves The fist move can only be raising (betting 1,2 or 3 coins) The opponents move can only be: - Folding - Calling (putting the same bet than the other players bet) - Raising (putting a higher amount than the other player) 2.5 Folding If a player wants to quit this current round and not invest a bet, then he can fold. This means that his bets are going to the opponent as well as the first coin he placed to participate in the game. 2.6 Special rule If a player has a card with the highest value and folds, then he has to give 10 coins away as a penalty. 2.7 Value of the cards The value of the cards are the following: 1: A simple line 2: Geometric forms, i.e. circles, triangles 3: Emojis 4: Children’s painting without colors 5: Children’s painting with colors 6: Photos 7: Rembrandt, van Gogh"
        myRules.numberOfLines = 33
        myRules.preferredMaxLayoutWidth = 600
        myRules.fontSize = 12
        myRules.position = CGPoint(x: 0, y: 10)
        self.addChild(myRules)
            
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
