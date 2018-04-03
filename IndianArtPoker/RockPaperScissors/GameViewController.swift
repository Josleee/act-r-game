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
    var poker = Model()
    var setup = false
    var pokerHumanAction = String()
    var pokerModelAction = String()
    var round = 0                   // even = model first turn, uneven = human first turn
    var category = String()
    var turn = String()
    var whofirst = 1;       // 1 = model, 0 = human
    var humansecondturn = false
    var humanturndone = 0
    var gameResult = "none"
    var first = true
    var modelPainting = UInt32()
    var humanPainting = UInt32()

    @IBOutlet weak var humanValue: UILabel!
    
    /*
        PROTECT buttons from clicking when not your turn, or already folded!
     right now at start:
     results win productions work fine, lose don't
     
     first round:   H M H worked
     second round:  H M (fold) worked!!
     
     
     FIRST MODEL TURN BY FUNC MODELTURN, MODEL TURNS AFTER HUMAN (OR
     
     
     
     */
    
    @IBAction func setUpGame(_ sender: UIButton) {          // MODEL FIRST TURN
        print("Setting up")
        if !setup { poker.loadModel(fileName: "test"); setup = true;
            poker.run() } //indianArtPoker
        round += 1
        if round%2 == 1 { turn = "uneven" } else { turn = "even" }
        humanPainting = (arc4random_uniform(7) + 1)
        modelPainting = (arc4random_uniform(7) + 1)
        if humanPainting > 5 { category = "high" }
        if humanPainting < 3 { category = "low" }
        if humanPainting >= 3, humanPainting <= 5 { category = "mid" }
        humanValue.text = "\(humanPainting)"
        
        print("\t\t\t\t Passing: round \(turn), cat \(category), hvalue \(String(humanPainting))")
        poker.modifyLastAction(slot: "round", value: turn)
        poker.modifyLastAction(slot: "hcat", value: category)
        poker.modifyLastAction(slot: "hvalue", value: String(humanPainting))
    }
        
    @IBAction func humanChoseAction(_ sender: UIButton) {                   // HUMAN reacts to model first turn
        pokerHumanAction = (sender.currentTitle?.lowercased())!
        print("\t\t\t\thuman chose: \(pokerHumanAction)")
        
        if !humansecondturn {   // not the human's second turn
            
            if whofirst == 1 { // model had first
                print("\t\t\t\t model had first turn already")
                if (pokerHumanAction != pokerModelAction && pokerModelAction != "fold") {
                    poker.modifyLastAction(slot: "secondturn", value: "yes")         // yes doesn't work?
                    print("\t\t\t\t\t model gets second turn")
                    poker.run()
                    poker.modifyLastAction(slot: "haction", value: pokerHumanAction) // pokerHumanAction
                    print("\t\t\t\t modified haction: " + poker.lastAction(slot: "haction")!)
                    poker.run()
                    pokerModelAction = poker.lastAction(slot: "maction")!
                    print("model chose on second turn: \(pokerModelAction). go to results")
                } else {  // no second turn is necessary
                    print("\t\t\t\t model needs no second turn")
                    poker.modifyLastAction(slot: "secondturn", value: "no")
                    poker.run()
                }

                if (pokerModelAction == "fold" ) {
                    gameResult = "unnecessarylose"
                } else {
                    if (humanPainting < modelPainting) { gameResult = "lose" } else { gameResult = "win" }
                }
                poker.modifyLastAction(slot: "results", value: gameResult)  // win/lose/draw
                            print("modified results4: " + poker.lastAction(slot: "results")! + ". model painting value: \(modelPainting)")
                whofirst = 1
                poker.run()
                poker.modifyLastAction(slot: "round", value: "even")
                poker.modifyLastAction(slot: "hcat", value: category)
                poker.modifyLastAction(slot: "hvalue", value: "4")
                first = true
                
            } else {            // human has first turn
                print("\t\t\t\t human has first turn")
                poker.modifyLastAction(slot: "haction", value: pokerHumanAction)
                print("did it succesfully transfer haction? : " + poker.lastAction(slot: "haction")!)
                print("\t\t\t\tmodel should choose an action now w/ start-uneven-turn")
                poker.run()
                poker.modifyLastAction(slot: "haction", value: pokerHumanAction)
                poker.run()
                pokerModelAction = poker.lastAction(slot: "maction")!
                print("\t\t\t\tmodel reaction: " + pokerModelAction)
            if (pokerHumanAction != pokerModelAction && pokerModelAction != "fold") && whofirst == 0 {
                    print("human needs second turn")
                    humansecondturn = true
                    
                } else if (pokerHumanAction != pokerHumanAction && pokerModelAction != "fold") && whofirst == 1 {
                    
                    //((pokerHumanAction == "raisehigh" && pokerModelAction != "raisehigh") || (pokerHumanAction == "raisemid" && (pokerModelAction == "raiselow" || pokerModelAction == "fold"))) && whofirst == 1 {
                        print("this shouldn't happen here")
                } else { // if (pokerModelAction == pokerHumanAction || pokerModelAction == "fold" || pokerHumanAction == "fold"){
                    humansecondturn = false
                    print("THIS SHOULD ALWASYS BE EXECUTED when everything is fine to go to results")
                    poker.modifyLastAction(slot: "secondturn", value: "no")
                    poker.run()
            
                    if (pokerModelAction == "fold" ) {
                        gameResult = "unnecessarylose"
                    } else {
                   if (humanPainting < modelPainting) { gameResult = "lose" } else { gameResult = "win" }
                    }
                                // unnecessarylose worked after H M !
                
                    poker.modifyLastAction(slot: "results", value: gameResult)  // win/lose/draw
                                print("modified results4: " + poker.lastAction(slot: "results")! + ". model painting value: \(modelPainting)")
                    whofirst = 1
                    poker.run()
                    print("NEW ROUND")
                    poker.modifyLastAction(slot: "round", value: "even")
                    poker.modifyLastAction(slot: "hcat", value: category)
                    poker.modifyLastAction(slot: "hvalue", value: "4")
                    first = true
                
                
                }
                    
            }   // END else for human first turn
            
        } else {        // human second turn
            print("asdasdas" )
            pokerHumanAction = (sender.currentTitle?.lowercased())!
            print("\t\t\t\thuman second action: \(pokerHumanAction)")
            poker.modifyLastAction(slot: "haction", value: pokerHumanAction)
            poker.run()
            humansecondturn = false
            humanturndone = 0
            if (pokerModelAction == "fold" ) {
                gameResult = "unnecessarylose"
            } else {
                if (humanPainting < modelPainting) { gameResult = "lose" } else { gameResult = "win" }
            }
            poker.modifyLastAction(slot: "secondturn", value: "no")
            poker.run()
            poker.modifyLastAction(slot: "results", value: gameResult)  // win/lose/draw
                        print("modified results4: " + poker.lastAction(slot: "results")! + ". model painting value: \(modelPainting)")
            whofirst = 1
            poker.run()
            print("NEW ROUND")
            poker.modifyLastAction(slot: "round", value: "even")
            poker.modifyLastAction(slot: "hcat", value: category)
            poker.modifyLastAction(slot: "hvalue", value: "4")
            first = true
        }
    }
    
    
    @IBAction func modelTurn(_ sender: UIButton) {      //
        if humanturndone == 0 {
            print("testing whether this works")
            poker.modifyLastAction(slot: "round", value: "even")
            print("result: " + poker.lastAction(slot: "round")!)
        }
        
        if first {      // very first turn
            first = false
            print("\t\t\t\t model has first turn")
            poker.run()
            pokerModelAction = poker.lastAction(slot: "maction")!
            print("\t\t\t\tmodel chose: " + pokerModelAction)
        } else {        // later turn (which shouldn't happen)
            print("\t\t\t\t  ?!?!?!?!?!?!??!?!?!")
            poker.run()
            pokerModelAction = poker.lastAction(slot: "maction")!
            print("\t\t\t\tmodel chose: " + pokerModelAction)
            poker.modifyLastAction(slot: "secondturn", value: "no")
            poker.run()
            
            if pokerModelAction == "fold" {
                gameResult = "unnecessarylose"
            } else {
                if (humanPainting < modelPainting) { gameResult = "lose" } else { gameResult = "win" }
            }
            
            poker.modifyLastAction(slot: "results", value: gameResult)  // win/lose/draw/unnecessarylose    (last is when model folded but turns out models value was higher)
            print("modified results4: " + poker.lastAction(slot: "results")! + ". model painting value: \(modelPainting)")
            print("IT SHOULD RESET ETC HERE BUT DOESN'T!!")
            whofirst = 1
            poker.run()
            print("NEW ROUND")
            first = true
            }
        }

    
    @IBAction func humanAction(_ sender: UIButton) {
        humanturndone = 1
        print("human")
        poker.modifyLastAction(slot: "round", value: "uneven")
        whofirst = 0;
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
    
    
    // --------------------------------------------             ROCK PAPER SCISSORS
    
    @IBOutlet weak var modelChoice: UILabel!
    @IBOutlet weak var Result: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var scoremodel: UILabel!
    
    var playerAction = String()
    var modelAction = String()
    var game = RockPaperScissors()
    var model = Model()
    var first2 = true

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

    @IBAction func reset(_ sender: UIButton) {
        model.reset()         
    }
}
/*   =action>
isa move
opponent =decision
==>
 */
