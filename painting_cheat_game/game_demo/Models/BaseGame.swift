//
//  BaseGame.swift
//  game_demo
//
//  Created by Jed on 16/03/2018.
//  Copyright © 2018 Jed. All rights reserved.
//

import Foundation

enum RunTimeError: Error {
    case invalidAmount(Int)
}

//enum Turn: Bool {
//    typealias RawValue = Bool
//    case HumanPlayer = true
//    case AIPlayer = false
//}


class BaseGame {
    
    private var humanCoinsAmount : Int!
    private var AICoinsAmount : Int!
    private var coinsAmountInPot : Int = 0
    
    private var humanPaintingValue : Int = 0
    private var AIPaintingValue : Int = 0
    //private var turn : Turn =
    
    init() {
        humanCoinsAmount = 20
        AICoinsAmount = 20
    }
    
    func getCoinsInPot() -> Int {
        return coinsAmountInPot
    }
    
    func setPainting(humanPainting : Int, AIPainintg : Int) {
        humanPaintingValue = humanPainting
        AIPaintingValue = AIPainintg
        
        if (humanCoinsAmount >= 1 && AICoinsAmount >= 1) {
            humanCoinsAmount! -= 1
            AICoinsAmount! -= 1
            coinsAmountInPot += 2
        }
    }
    
    func getHumanCoins() -> Int {
        return humanCoinsAmount
    }
    
    func getAICoins() -> Int {
        return AICoinsAmount
    }

    func getHumanPaintingValue() -> Int {
        return humanPaintingValue
    }
    
    func getAIPaintingValue() -> Int {
        return AIPaintingValue
    }
    
    func raise(amountCoins : Int, isHumanPlayer : Bool) throws {
        if (isHumanPlayer) {
            if (humanCoinsAmount < amountCoins) {
                throw RunTimeError.invalidAmount(amountCoins)
            }
            humanCoinsAmount! -= amountCoins
            coinsAmountInPot += amountCoins
        } else {
            if (AICoinsAmount < amountCoins) {
                throw RunTimeError.invalidAmount(amountCoins)
            }
            AICoinsAmount! -= amountCoins
            coinsAmountInPot += amountCoins
        }
    }
    
    func fold(isHumanPlayer : Bool) {
        print("Coins in pot: " + String(coinsAmountInPot))
        if (isHumanPlayer) {
            AICoinsAmount! += coinsAmountInPot
        } else {
            humanCoinsAmount! += coinsAmountInPot
        }
        coinsAmountInPot = 0
    }
    
    /**
     Human wins: return 1
     AI wins: return -1
     End in draw: return 0
     */
    func evaluateCardsAndSetWinner(cardHuman: Card, cardAI: Card){
        humanPaintingValue = cardHuman.getCardValue()
        AIPaintingValue = cardAI.getCardValue()
        
        print("Coins in pot: " + String(coinsAmountInPot))
        if (humanPaintingValue > AIPaintingValue) {
            humanCoinsAmount! += coinsAmountInPot
            coinsAmountInPot = 0
            GameData.shared.winner = .HumanPlayer
//            return GameData.shared.winner
        } else if (humanPaintingValue < AIPaintingValue) {
            AICoinsAmount! += coinsAmountInPot
            coinsAmountInPot = 0
            GameData.shared.winner = .AIPlayer
//            return -1
        } else {
            GameData.shared.winner = .NoOne
//            return 0
        }
    }
    
    /**
     Human is the winer: return 1
     AI is the winer: return -1
     No winer: return 0
     */
    func setWinnerAccordingToCoins(){
        if (humanCoinsAmount <= 0 && getCoinsInPot() == 0) {
            GameData.shared.winner = .AIPlayer
        } else if (AICoinsAmount <= 0 && getCoinsInPot() == 0) {
            GameData.shared.winner = .HumanPlayer
        } else {
            return GameData.shared.winner = .NoOne
        }
    }
}
