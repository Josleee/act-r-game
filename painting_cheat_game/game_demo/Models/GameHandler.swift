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
    public let listRaiseAmount : [Int] = [1, 3, 6]
    
    private var lastRaise : Int = 0
    
    private func randomlyGetPaintingName() -> String {
        let value = Int(arc4random_uniform(7) + 1)
        return "S" + String(value) + "P (" + String(arc4random_uniform(10) + 1) + ")"
    }
    
    // isFold : whether AI player folds
    func newRandomGame(isFold : Bool, winner : Winner = Winner.Nil) {
        let humanPaintingName : String = randomlyGetPaintingName()
        let AIPaintingName : String = randomlyGetPaintingName()
        let humanPaintingValue : Int = Int(humanPaintingName.substring(from: 1, to: 2))!
        let AIPaintingValue : Int = Int(AIPaintingName.substring(from: 1, to: 2))!
        
        setPainting(humanPainting: humanPaintingValue, AIPainintg: AIPaintingValue,
                    HPName: humanPaintingName, AIPName: AIPaintingName,
                    wn: winner, isFold: isFold)
        
        lastRaise = 0
        raiseCount = 0
    }
    
    func newGame(humanPainting: Int, AIPainintg: Int, isFold : Bool) {
        setPainting(humanPainting: humanPainting, AIPainintg: AIPainintg, HPName: "", AIPName: "", wn: Winner.Nil, isFold: isFold)
        lastRaise = 0
        raiseCount = 0
    }
    
    func isFinished() -> Bool {
        print("Last raise is \(lastRaise), raise count is \(raiseCount), getAICoins is \(getAICoins()) and getHumanCoins is \(getHumanCoins())")
        if (raiseCount == 3 || (raiseCount == 2 && lastRaise <= 0) ||
            (getAICoins() <= 0 && lastRaise == 0) || (getHumanCoins() <= 0 && lastRaise == 0)) {
            print("Finish in last raise \(lastRaise) and raise count is \(raiseCount)")
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
            print("Last raise: " + String(lastRaise))
            raiseCount += 1
            
            if coinsAmount == 1 {
                print("Human raise ACT-R low")
                print("---poker.modifyLastAction(slot: \"haction\", value: \"raiselow\")")
                poker.modifyLastAction(slot: "haction", value: "raiselow")
                print("---poker.run()")
                poker.run()
                print("---poker.modifyLastAction(slot: \"haction\", value: \"raiselow\")")
                poker.modifyLastAction(slot: "haction", value: "raiselow")
                print("---poker.run()")
                poker.run()
            } else if coinsAmount >= 5 {
                print("Human raise ACT-R high")
                print("---poker.modifyLastAction(slot: \"haction\", value: \"raisehigh\")")
                poker.modifyLastAction(slot: "haction", value: "raisehigh")
                print("---poker.run()")
                poker.run()
                print("---poker.modifyLastAction(slot: \"haction\", value: \"raisehigh\")")
                poker.modifyLastAction(slot: "haction", value: "raisehigh")
                print("---poker.run()")
                poker.run()
            } else {
                print("Human raise ACT-R mid")
                print("---poker.modifyLastAction(slot: \"haction\", value: \"raisemid\")")
                poker.modifyLastAction(slot: "haction", value: "raisemid")
                print("---poker.run()")
                poker.run()
                print("---poker.modifyLastAction(slot: \"haction\", value: \"raisemid\")")
                poker.modifyLastAction(slot: "haction", value: "raisemid")
                print("---poker.run()")
                poker.run()
            }
            
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func AIRaise(coinsAmount : Int) {
        do {
            try raise(amountCoins: coinsAmount, isHumanPlayer: false)
            lastRaise = coinsAmount - lastRaise
            print("Last raise: " + String(lastRaise))
            raiseCount += 1
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func ACTRRaise() -> Int {
        print("raiseCount: " + String(raiseCount))
        print("lastRaise: " + String(lastRaise))
        
        do {
            if getAICoins() == 0 {
                raiseCount += 1
                return 0
            }
            
            if lastRaise > getAICoins() {
                lastRaise = getAICoins() - lastRaise
                let restCoins : Int = getAICoins()
                try raise(amountCoins: getAICoins(), isHumanPlayer: false)
                raiseCount += 1
                return restCoins
            }
            
            if raiseCount == 2 {
                if lastRaise < 0 {
                    raiseCount += 1
                    return 0
                }
                try raise(amountCoins: lastRaise, isHumanPlayer: false)
                raiseCount += 1
                return lastRaise
            }
            
            print("AI turn !!!!!!!!!!!!!!")
            print("---poker.lastAction(slot: \"maction\")!")
            let pokerModelAction = poker.lastAction(slot: "maction")!
            print(pokerModelAction)
            print("AI turn !!!!!!!!!!!!!!")
            
            switch pokerModelAction {
            case "raiselow":
                print("AI decides to raiselow.")
                var numberToRaise : Int = 1
                if (lastRaise <= numberToRaise || lastRaise == 0) {
                    if (numberToRaise <= getAICoins()) {
                        numberToRaise = 1
                    } else {
                        numberToRaise = getAICoins()
                    }
                } else {
                    if (lastRaise <= getAICoins()) {
                        numberToRaise = lastRaise
                    } else {
                        numberToRaise = getAICoins()
                    }
                }
                if lastRaise == numberToRaise {
                    print("---poker.modifyLastAction(slot: \"secondturn\", value: \"yes\")")
                    poker.modifyLastAction(slot: "secondturn", value: "yes")
                    print("---poker.run()")
                    poker.run()
                } else {
                    print("---poker.modifyLastAction(slot: \"secondturn\", value: \"no\")")
                    poker.modifyLastAction(slot: "secondturn", value: "no")
                    print("---poker.run()")
                    poker.run()
                }
                raiseCount += 1
                try raise(amountCoins: numberToRaise, isHumanPlayer: false)
                lastRaise = numberToRaise - lastRaise
                print("last raise : " + String(lastRaise))
                return numberToRaise
                
            case "raisemid":
                print("AI decides to raisemid.")
                var numberToRaise : Int = 3
                if (lastRaise <= numberToRaise || lastRaise == 0) {
                    if (numberToRaise <= getAICoins()) {
                        numberToRaise = 3
                    } else {
                        numberToRaise = getAICoins()
                    }
                } else {
                    if (lastRaise <= getAICoins()) {
                        numberToRaise = lastRaise
                    } else {
                        numberToRaise = getAICoins()
                    }
                }
                if lastRaise == numberToRaise {
                    print("---poker.modifyLastAction(slot: \"secondturn\", value: \"yes\")")
                    poker.modifyLastAction(slot: "secondturn", value: "yes")
                    print("---poker.run()")
                    poker.run()
                } else {
                    print("---poker.modifyLastAction(slot: \"secondturn\", value: \"no\")")
                    poker.modifyLastAction(slot: "secondturn", value: "no")
                    print("---poker.run()")
                    poker.run()
                }
                raiseCount += 1
                try raise(amountCoins: numberToRaise, isHumanPlayer: false)
                lastRaise = numberToRaise - lastRaise
                print("last raise : " + String(lastRaise))
                return numberToRaise
                
            case "raisehigh":
                print("AI decides to raisehigh.")
                var numberToRaise : Int = 5
                if (lastRaise <= numberToRaise || lastRaise == 0) {
                    if (numberToRaise <= getAICoins()) {
                        numberToRaise = 5
                    } else {
                        numberToRaise = getAICoins()
                    }
                } else {
                    if (lastRaise <= getAICoins()) {
                        numberToRaise = lastRaise
                    } else {
                        numberToRaise = getAICoins()
                    }
                }
                if lastRaise == numberToRaise {
                    print("---poker.modifyLastAction(slot: \"secondturn\", value: \"yes\")")
                    poker.modifyLastAction(slot: "secondturn", value: "yes")
                    print("---poker.run()")
                    poker.run()
                } else {
                    print("---poker.modifyLastAction(slot: \"secondturn\", value: \"no\")")
                    poker.modifyLastAction(slot: "secondturn", value: "no")
                    print("---poker.run()")
                    poker.run()
                }
                raiseCount += 1
                try raise(amountCoins: numberToRaise, isHumanPlayer: false)
                lastRaise = numberToRaise - lastRaise
                print("last raise : " + String(lastRaise))
                return numberToRaise
                
            case "fold":
                print("AI decides to fold.")
                fold(isHumanPlayer: false)
                print("---poker.modifyLastAction(slot: \"secondturn\", value: \"no\")")
                poker.modifyLastAction(slot: "secondturn", value: "no")
                print("---poker.run()")
                poker.run()
                return -1
                
            default:
                print("ERROR")
                print("---poker.modifyLastAction(slot: \"secondturn\", value: \"no\")")
                poker.modifyLastAction(slot: "secondturn", value: "no")
                print("---poker.run()")
                poker.run()
                var numberToRaise : Int = Int(arc4random_uniform(3) + 1) * 3
                if (lastRaise <= numberToRaise || lastRaise == 0) {
                    if (numberToRaise > getAICoins()) {
                        numberToRaise = getAICoins()
                    }
                } else {
                    if (lastRaise <= getAICoins()) {
                        numberToRaise = lastRaise
                    } else {
                        numberToRaise = getAICoins()
                    }
                }
                raiseCount += 1
                try raise(amountCoins: numberToRaise, isHumanPlayer: false)
                lastRaise = numberToRaise - lastRaise
                print("last raise : " + String(lastRaise))
                return numberToRaise
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
        return 0
    }
    
    func AIrandomlyRaise() -> Int {
        print("raiseCount: " + String(raiseCount))
        print("lastRaise: " + String(lastRaise))
        
        do {
            if getAICoins() == 0 {
                raiseCount += 1
                return 0
            }
            
            if lastRaise > getAICoins() {
                lastRaise = getAICoins() - lastRaise
                let restCoins : Int = getAICoins()
                try raise(amountCoins: getAICoins(), isHumanPlayer: false)
                raiseCount += 1
                return restCoins
            }
            
            if raiseCount == 2 {
                if lastRaise < 0 {
                    raiseCount += 1
                    return 0
                }
                try raise(amountCoins: lastRaise, isHumanPlayer: false)
                raiseCount += 1
                return lastRaise
            }
            
            
            
            while true {
                let randomIndex = Int(arc4random_uniform(UInt32(listRaiseAmount.count)))
                if (listRaiseAmount[randomIndex] >= lastRaise && listRaiseAmount[randomIndex] <= getAICoins()) {
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
        print("")
        print("Human painting value: " + String(getHumanPaintingValue()))
        print("AI painting value: " + String(getAIPaintingValue()))
        print("Human coins: " + String(getHumanCoins()))
        print("AI coins: " + String(getAICoins()))
        print()
    }
    
}
