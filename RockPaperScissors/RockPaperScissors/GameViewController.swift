//
//  GameViewController.swift
//  RockPaperScissors
//
//  Created by A.J. Stuive on 23/02/2018.
//  Copyright © 2018 A.J. Stuive. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var playerAction = String()
    var modelAction = String()
    var game = RockPaperScissors()
    var model = Model()

    @IBOutlet weak var modelChoice: UILabel!
    @IBOutlet weak var Result: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var scoremodel: UILabel!
    
    @IBAction func pressedReset(_ sender: Any) {
        model.reset()
        game.reset()
        Result.text = ""
        score.text = "You: \(game.passPlayerScore())"
        scoremodel.text = "Model: \(game.passModelScore())"
        modelChoice.text = "Model chose: "
    }
    
    @IBAction func PressButton(_ sender: UIButton) {
        model.loadModel(fileName: "rps")
        model.run()
        modelAction = model.lastAction(slot: "choice")!
        print("Model chose: \(modelAction)")
        modelChoice.text = "Model chose: \(modelAction)"
        
        if (sender.currentTitle == "ROCK")  {
            playerAction = "rock"
            Result.text = game.calcResults(playerAction: playerAction, modelAction: modelAction)
        } else if (sender.currentTitle == "PAPER")  {
            playerAction = "paper"
            Result.text = game.calcResults(playerAction: playerAction, modelAction: modelAction)
        } else if(sender.currentTitle == "SCISSORS")  {
            playerAction = "scissors"
            Result.text = game.calcResults(playerAction: playerAction, modelAction: modelAction)
        }
        
        score.text = "You: \(game.passPlayerScore())"
        scoremodel.text = "Model: \(game.passModelScore())"
    }

}
