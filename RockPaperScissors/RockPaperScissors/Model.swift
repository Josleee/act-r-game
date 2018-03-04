//
//  Model.swift
//  RockPaperScissors
//
//  Created by A.J. Stuive on 23/02/2018.
//  Copyright © 2018 A.J. Stuive. All rights reserved.
//

import UIKit

class Model: NSObject {

    override func viewDidLoad() { // This function is called when the App starts up super.viewDidLoad()
        model.loadModel("rps")
        model.run()
    }
    // The following function is called when the player pushed one of the buttons @IBAction func gameAction(sender: UIButton) {
    // The player action is the title of the button that was pressed let playerAction = sender.currentTitle!
    // The model action is in the choice slot in the action buffer let modelAction = model.lastAction("choice")!
    // Determine the outcome of the game
    switch (playerAction,modelAction) {
    case ("Rock","rock"),("Paper","paper"),("Scissors","scissors"):
    // Tie
    break
    case ("Rock","scissors"),("Paper","rock"),("Scissors","paper"):
    // Players wins pScore += 1 mScore -= 1
    default:
    // Model wins
    pScore -= 1
    mScore += 1
    }
    // Communicate the player's action back to the model by setting a slot // in the action buffer
    model.modifyLastAction("opponent", value: playerAction.lowercaseString) // And run the model again for the next trial
    model.run()
}
    
}
