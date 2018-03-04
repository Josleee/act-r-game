//
//  RockPaperScissors.swift
//  RockPaperScissors
//
//  Created by A.J. Stuive on 23/02/2018.
//  Copyright © 2018 A.J. Stuive. All rights reserved.
//

import UIKit

class RockPaperScissors: NSObject {
    var playerScore = 0
    var modelScore = 0
    
    func calcResults(playerAction: String, modelAction: String) -> String {
        var result = String()
        switch (playerAction, modelAction) {
        case ("rock", "rock"), ("paper", "paper"), ("scissors", "scissors"):
            result = "Draw"
        case ("rock", "paper"):
            result = "Lose"
            modelScore += 1
        case ("rock", "scissors"):
            result = "Win"
            playerScore += 1
        case ("paper", "rock"):
            result = "Win"
            playerScore += 1
        case ("paper", "scissors"):
            result = "Lose"
            modelScore += 1
        case ("scissors", "rock"):
            result = "Lose"
            modelScore += 1
        case ("scissors", "paper"):
            result = "Win"
            playerScore += 1
        default:
            result = "Error"
            break
        }
        return result
        
    }
    
    func passPlayerScore() -> Int {
        return playerScore
    }
    
    func passModelScore() -> Int {
        return modelScore
    }
    
    func reset() {
        playerScore = 0
        modelScore = 0
        
    }
    
}
