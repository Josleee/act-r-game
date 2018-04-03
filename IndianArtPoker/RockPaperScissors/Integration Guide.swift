//
//  Integration Guide.swift
//  RockPaperScissors
//
//  Created by A.J. Stuive on 03/04/2018.
//  Copyright © 2018 A.J. Stuive. All rights reserved.
//

import UIKit

class Integration_Guide: NSObject {
    /*
     In the gameviewcontroller, create a variable to hold the actr model [var poker = Model()]
     to load the appropriate actr-model, execute:
     -----------------------------------
     poker.loadModel(fileName: "test")
     poker.run()s
     -----------------------------------
     JUST ONCE!!
     
     At the start of every new round:
     Determine whether the round number is even or uneven. [Uneven turns the human has the first turn, even turn the model has first turn]
     Determine the category of the HUMAN's painting value (high, mid, low)
     And pass those values on to the model:
     -----------------------------------
     poker.modifyLastAction(slot: "round", value: turn)             [turn is "even" or "uneven"
     poker.modifyLastAction(slot: "hcat", value: category)          [category is "high", "mid", "low"]
     poker.modifyLastAction(slot: "hvalue", value: String(value))   [The value of the painting]
     -----------------------------------
     
     For the turns there are several options with unique code:
     1. Model-Human
     2. Model-Human-Model
     3. Human-Model
     4. Human-Model-Human
     
     For turn option 1 (Model-Human):
     -----------------------------------
     Model:
     poker.run()
     pokerModelAction = poker.lastAction(slot: "maction")!
     
     Human:
     pokerHumanAction = [However this is determined in the game, but it needs to be a string, ie "raiselow", "raisemid", "raisehigh"]
    -----------------------------------
     
     Determine if the model needs a second turn. If unnecessary:
     
        -----------------------------------
        poker.modifyLastAction(slot: "secondturn", value: "no")
        poker.run()
        -----------------------------------
     
     If a second turn IS necessary, we have turn Option 2.
     
         For turn option 2 (Model-Human-Model):
         (This is after Option 1 code and whatever decides a turn is necessary!)
     
         -----------------------------------
         poker.modifyLastAction(slot: "secondturn", value: "yes")
         poker.run()
         poker.modifyLastAction(slot: "haction", value: pokerHumanAction)
         poker.run()
         pokerModelAction = poker.lastAction(slot: "maction")!
         -----------------------------------
     
     Determine the results and put in a string variable (gameResult below), options actr uses are "win", "draw", "lose", and "unnecessarylose". Lose when the human has a higher value, unnecessarylose when the model folded but would've won if it didn't.
     Process the results:
     
     -----------------------------------
     poker.modifyLastAction(slot: "results", value: gameResult)
     poker.run()
     -----------------------------------
     
     Set up for the following round:
     
     -----------------------------------
     poker.modifyLastAction(slot: "round", value: turn)
     poker.modifyLastAction(slot: "hcat", value: category)
     poker.modifyLastAction(slot: "hvalue", value: paintingValue)
     -----------------------------------
     
     Turn Option 3 (Human-Model):
     
     Determine human action
     
     -----------------------------------
     poker.modifyLastAction(slot: "haction", value: pokerHumanAction)
     -----------------------------------
     
     Start model turn
     -----------------------------------
     poker.run()
     poker.modifyLastAction(slot: "haction", value: pokerHumanAction)
     poker.run()
     pokerModelAction = poker.lastAction(slot: "maction")!
     -----------------------------------
     
     Again, determine if a second turn is necessary.
     
     -----------------------------------
     No second turn
     -----------------------------------
     
     Turn Option 4 (Human-Model-Human)
     -----------------------------------
     Human second turn
     pokerHumanAction = [However you do this]
     poker.modifyLastAction(slot: "haction", value: pokerHumanAction)
     poker.run()
     
     -----------------------------------
     
     Whether a human second turn or not:

     -----------------------------------
     poker.modifyLastAction(slot: "secondturn", value: "no")
     poker.run()
     -----------------------------------
     
     And set up for next round, same as before:
     
     -----------------------------------
     poker.modifyLastAction(slot: "results", value: gameResult)
     poker.run()
     poker.modifyLastAction(slot: "round", value: turn)
     poker.modifyLastAction(slot: "hcat", value: category)
     poker.modifyLastAction(slot: "hvalue", value: paintingValue)
     -----------------------------------
     
 */
    
    
    
    
    
    
    

}
