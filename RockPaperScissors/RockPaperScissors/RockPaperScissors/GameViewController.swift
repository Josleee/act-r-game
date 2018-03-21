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

/* test text
 
 (p bullshit
 =goal>
 isa goal
 state start
 ==>
 =goal>
 isa goal
 state end
 )
 
 (p done
 =goal>
 isa goal
 state end
 ==>
 =goal>
 isa goal
 state nil
 )
 
 (p start-up-without-action
 =goal>
 isa goal
 state startadasdasd
 try =x
 ==>
 =goal>
 isa goal
 state start
 +action>
 isa experiment
 testing passingbuffersdirectly
 )
 
 (p start2
 =goal>
 isa goal
 state start2
 =action>
 isa experiment
 testing passingbuffersdirectly
 ==>
 =goal>
 isa goal
 state asdasdasd
 )
 
 */

class GameViewController: UIViewController {
    var poker = Model()
    var setup = false
    var pokerHumanAction = String()
    var pokerModelAction = String()
    var round = 1
    var category = String()
    var turn = String()

    @IBOutlet weak var humanValue: UILabel!
    
    @IBAction func setUpGame(_ sender: UIButton) {
        if !setup { poker.loadModel(fileName: "test"); setup = true; poker.run() } //indianArtPoker
        round += 1
        if round%2 == 1 { turn = "uneven" } else { turn = "even" }
        let value = 5      // (arc4random_uniform(7) + 1)
        if value > 5 { category = "high" }
        if value < 3 { category = "low" }
        if value >= 3, value <= 5 { category = "mid" }
        humanValue.text = "\(value)"
        
        
        print("\t\t\t\t Passing: round \(turn), cat \(category), hvalue \(String(value))")
        poker.modifyLastAction(slot: "round", value: turn)
        poker.modifyLastAction(slot: "hcat", value: category)
        poker.modifyLastAction(slot: "hvalue", value: String(value))
     //   poker.modifyLastAction(slot: "haction", value: "raisemid")      // after human turn
        
        print("\t\t\t\t next run")
        poker.run()
        pokerModelAction = poker.lastAction(slot: "maction")!
        print("\t\t\t\tmodel chose: " + pokerModelAction)
                    // rest of turn below after human pressed buttons
        }
        
        
        
/* General interaction looks like this:
 Set up the model by something like:
         if !setup { poker.loadModel(fileName: "indianArtPoker"); setup = true }
         poker.run() to create the necessary action buffer slots.
 
 in UNeven turns human goes first, it should look like this:
     poker.modifyLastAction(slot: "round", value: uneven)
         poker.modifyLastAction(slot: "hcat", value: category)      ;; category variable says high/mid/low
         poker.modifyLastAction(slot: "hvalue", value: String(value))
     poker.modifyLastAction(slot: "haction", value: humanAction)
     poker.run()
     print("model chose: " + poker.lastAction(slot: "maction")!)
  in even turns model goes first, it should look like this:
     poker.modifyLastAction(slot: "round", value: even)
     poker.modifyLastAction(slot: "hcat", value: category)
     poker.modifyLastAction(slot: "hvalue", value: String(value))
     poker.run()
     print("model chose: " + poker.lastAction(slot: "maction")!)
         IF NECESSARY, another model turn by                        SOMETHING TO DIFFERENTIATE THIS !!
         poker.modifyLastAction(slot: "haction", value: humanAction)
         poker.run()
         retrieve poker.lastAction(slot: "maction")
 */
        
        
        
        
/* WHAT WORKS:                  in other words, act-r needs to create action buffer slots first!
        poker.run()
        let result = poker.lastAction(slot: "testing")!
        print(result)
        poker.run()
       */

/* WHAT DOESN"T WORK:
        poker.modifyLastAction(slot: "testing", value: "passingbuffersdirectly")
        model.run()
        let success = poker.lastAction(slot: "testing")!
        print("yay or nay?: " + success)
 */
    
    
    @IBAction func humanChoseAction(_ sender: UIButton) {
        pokerHumanAction = (sender.currentTitle?.lowercased())!
        print("\t\t\t\thuman chose: \(pokerHumanAction)")
        
        
        if (pokerHumanAction == "raisehigh" && pokerModelAction != "raisehigh") || (pokerHumanAction == "raisemid" && (pokerModelAction == "raiselow" || pokerModelAction == "fold")) {
            poker.modifyLastAction(slot: "secondturn", value: "yes")         // yes doesn't work?
            print("\t\t\t\tSECOND TURN RUN FOLLOWS")
        } else {
            poker.modifyLastAction(slot: "secondturn", value: "no")
        }
        poker.run()
        pokerHumanAction = poker.lastAction(slot: "haction")!
        print("after start-even-turn-second")
        
        print("what's in haction : " + poker.lastAction(slot: "haction")!)
        poker.modifyLastAction(slot: "haction", value: pokerHumanAction) // pokerHumanAction
        print("modified haction: " + poker.lastAction(slot: "haction")! + "\n")
        
        poker.run()
        
        print("done with run after start-even-turn-second fires")
       // pokerModelAction = poker.lastAction(slot: "maction")!
       // print("\t\t\t\tmodel chose 2nd: " + pokerModelAction)
        
        let gameResult = "lose"
        poker.modifyLastAction(slot: "results", value: gameResult)  // win/lose/draw
        print("modified results: " + poker.lastAction(slot: "results")!)
        poker.run()
    }
    
    
    // --------------------------------------------             ROCK PAPER SCISSORS
    
    @IBOutlet weak var modelChoice: UILabel!
    @IBOutlet weak var Result: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var scoremodel: UILabel!
    
    var playerAction = String()
    var modelAction = String()
    var game = RockPaperScissors()
    var model = Model()
    var first = true

    @IBAction func pressedReset(_ sender: Any) {
        model.reset()
        game.resetGame()
        Result.text = ""
        score.text = "You: \(game.passPlayerScore())"
        scoremodel.text = "Model: \(game.passModelScore())"
        modelChoice.text = "Model chose: "
    }
    
    @IBAction func PressButton(_ sender: UIButton) {
        if first { model.loadModel(fileName: "rps"); first = false }
        
        model.run()
        modelAction = model.lastAction(slot: "choice")!
        print("Model chose: \(modelAction)")
        modelChoice.text = "Model chose: \(modelAction)"
        
        if (sender.currentTitle == "ROCK")  {
            playerAction = "rock"
        } else if (sender.currentTitle == "PAPER")  {
            playerAction = "paper"
        } else if(sender.currentTitle == "SCISSORS")  {
            playerAction = "scissors"
        }
        Result.text = game.calcResults(playerAction: playerAction, modelAction: modelAction)
        score.text = "You: \(game.passPlayerScore())"
        scoremodel.text = "Model: \(game.passModelScore())"
        model.modifyLastAction(slot: "opponent", value: playerAction)
        print("Check: ")
        let saved = model.lastAction(slot: "opponent")!
        print(saved)
    }

}
/*   =action>
isa move
opponent =decision
==>
 */
