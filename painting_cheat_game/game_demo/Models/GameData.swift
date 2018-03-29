//
//  GameData.swift
//  game_demo
//
//  Created by Jed on 18/03/2018.
//  Copyright © 2018 Jed. All rights reserved.
//

import Foundation

class GameData {
    static let shared = GameData()
    /**
     Human is the winer: return 1
     AI is the winer: return -1
     No winer: return 0
     */
    var winner = Winner.NoOne
    var newGame : Bool = false
    
    private init() { }
}

enum Winner: Int {
    case HumanPlayer = 1
    case AIPlayer = -1
    case NoOne = 0
    
    init() {
        self = .NoOne
    }
}
