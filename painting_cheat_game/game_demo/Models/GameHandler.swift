//
//  GameHandler.swift
//  game_demo
//
//  Created by Jed on 16/03/2018.
//  Copyright © 2018 Jed. All rights reserved.
//

import Foundation

class GameHandler: BaseGame {
    
    private var raiseCount : Int = 0
    private let listRaiseAmount : [Int] = [1, 3, 6]
    
    private var lastRaise : Int = 0
    
    func newRandomGame() {
        setPainting(humanPainting: Int(arc4random_uniform(6) + 1), AIPainintg: Int(arc4random_uniform(6) + 1))
    }
    
    func getLastRaise() -> Int {
        return lastRaise
    }
    
    func humanRaise(coinsAmount : Int) {
        do {
            try raise(amountCoins: coinsAmount, isHumanPlayer: true)
            lastRaise = coinsAmount - lastRaise
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func AIrandomlyRaise() {
        do {
            while true {
                let randomIndex = Int(arc4random_uniform(UInt32(listRaiseAmount.count)))
                if listRaiseAmount[randomIndex] >= lastRaise {
                    try raise(amountCoins: listRaiseAmount[randomIndex], isHumanPlayer: false)
                    return
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func printPaintingValues() {
        print("Human painting value: " + String(getHumanPainting()))
        print("AI painting value: " + String(getAIPainting()))
    }
    
}
