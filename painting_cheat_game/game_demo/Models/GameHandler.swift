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
        setPainting(humanPainting: Int(arc4random_uniform(7) + 1), AIPainintg: Int(arc4random_uniform(7) + 1))
        lastRaise = 0
        raiseCount = 0
    }
    
    func newGame(humanPainting: Int, AIPainintg: Int) {
        setPainting(humanPainting: humanPainting, AIPainintg: AIPainintg)
        lastRaise = 0
        raiseCount = 0
    }
    
    func isFinished() -> Bool {
        if raiseCount == 3 {
            return true
        } else {
            return false
        }
    }
    
    func getLastRaise() -> Int {
        return lastRaise
    }
    
    func humanRaise(coinsAmount : Int) {
        do {
            try raise(amountCoins: coinsAmount, isHumanPlayer: true)
            lastRaise = coinsAmount - lastRaise
            raiseCount += 1
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func AIrandomlyRaise() -> Int {
        do {
            while true {
                let randomIndex = Int(arc4random_uniform(UInt32(listRaiseAmount.count)))
                if listRaiseAmount[randomIndex] >= lastRaise {
                    try raise(amountCoins: listRaiseAmount[randomIndex], isHumanPlayer: false)
                    lastRaise = listRaiseAmount[randomIndex] - lastRaise
                    raiseCount += 1
                    return listRaiseAmount[randomIndex]
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return 0
    }
    
    func printPaintingValues() {
        print("Human painting value: " + String(getHumanPainting()))
        print("AI painting value: " + String(getAIPainting()))
    }
    
}