//
//  BaseGame.swift
//  game_demo
//
//  Created by Jed on 16/03/2018.
//  Copyright © 2018 Jed. All rights reserved.
//

import Foundation
import SpriteKit
import CoreML


enum RunTimeError: Error {
    case invalidAmount(Int)
}


class BaseGame {
    
    private var humanCoinsAmount : Int!
    private var AICoinsAmount : Int!
    private var coinsAmountInPot : Int = 0
    
    private var humanPaintingValue : Int = 0
    private var humanPaintingName : String!
    
    private var AIPaintingValue : Int = 0
    private var AIPaintingName : String!
    
    public let poker = Model()
    private var isFirstPlayAI : Bool = false
    private let machineLearningClassifier = Classifier()
    
    init() {
        print("---poker.loadModel(fileName: \"test\")")
        poker.loadModel(fileName: "test")
        print("---poker.run()")
        poker.run()
        
        humanCoinsAmount = 20
        AICoinsAmount = 20
    }
    
    func getCoinsInPot() -> Int {
        return coinsAmountInPot
    }
    
    func setPainting(humanPainting : Int, AIPainintg : Int, HPName : String, AIPName : String, wn : Winner, isFold : Bool) {
        humanPaintingValue = humanPainting
        AIPaintingValue = AIPainintg
        humanPaintingName = HPName
        AIPaintingName = AIPName
        
        if wn != Winner.Nil {
            print("Conclude a round.")
            if wn == Winner.AIPlayer {
                print("---poker.modifyLastAction(slot: \"results\", value: \"win\")")
                poker.modifyLastAction(slot: "results", value: "win")
                print("---poker.run()")
                poker.run()
            } else if wn == Winner.HumanPlayer {
                if isFold {
                    print("---poker.modifyLastAction(slot: \"results\", value: \"unnecessarylose\")")
                    poker.modifyLastAction(slot: "results", value: "unnecessarylose")
                    print("---poker.run()")
                    poker.run()
                } else {
                    print("---poker.modifyLastAction(slot: \"results\", value: \"lose\")")
                    poker.modifyLastAction(slot: "results", value: "lose")
                    print("---poker.run()")
                    poker.run()
                }
            } else {
                print("---poker.modifyLastAction(slot: \"results\", value: \"draw\")")
                poker.modifyLastAction(slot: "results", value: "draw")
                print("---poker.run()")
                poker.run()
            }
        }
        
        if (humanCoinsAmount >= 1 && AICoinsAmount >= 1) {
            humanCoinsAmount! -= 1
            AICoinsAmount! -= 1
            coinsAmountInPot += 2
        }
        
        print("Initialize ACTR model.")
        if isFirstPlayAI {
            print("---poker.modifyLastAction(slot: \"round\", value: \"even\")")
            poker.modifyLastAction(slot: "round", value: "even")
        } else {
            print("---poker.modifyLastAction(slot: \"round\", value: \"uneven\")")
            poker.modifyLastAction(slot: "round", value: "uneven")
        }
        
        let evaluatedValue = evaluatePainting(name: HPName)
        if evaluatedValue <= 2 {
            print("---poker.modifyLastAction(slot: \"hcat\", value: \"low\")")
            poker.modifyLastAction(slot: "hcat", value: "low")
        } else if evaluatedValue >= 6 {
            print("---poker.modifyLastAction(slot: \"hcat\", value: \"high\")")
            poker.modifyLastAction(slot: "hcat", value: "high")
        } else {
            print("---poker.modifyLastAction(slot: \"hcat\", value: \"mid\")")
            poker.modifyLastAction(slot: "hcat", value: "mid")
        }
        
        print("---poker.modifyLastAction(slot: \"hvalue\", value: " + String(evaluatedValue) + ")")
        poker.modifyLastAction(slot: "hvalue", value: String(evaluatedValue))
        
        print(poker.lastAction(slot: "round")!)
    }
    
    func evaluatePainting(name : String) -> Int {
        let testImage = UIImage(named: name)
        
        //        DispatchQueue.global(qos: .userInitiated).async {
        //            // Resnet50 expects an image 224 x 224, so we should resize and crop the source image
        //            let inputImageSize: CGFloat = 224.0
        //            let minLen = min((testImage?.size.width)!, (testImage?.size.height)!)
        //            let resizedImage = testImage?.resize(to: CGSize(width: inputImageSize * (testImage?.size.width)! / minLen, height: inputImageSize * (testImage?.size.height)! / minLen))
        //            let cropedToSquareImage = resizedImage?.cropToSquare()
        //
        //            guard let pixelBuffer = cropedToSquareImage?.pixelBuffer() else {
        //                fatalError()
        //            }
        //            guard let classifierOutput = try? self.machineLearningClassifier.prediction(input__0: pixelBuffer) else {
        //                fatalError()
        //            }
        //
        //            DispatchQueue.main.async {
        //                print(classifierOutput.classLabel)
        //            }
        //        }
        
        let sizedImage = ImageProcessor.resizeImage(image: testImage!, newLength: 224)
        if let pixelBuffer = ImageProcessor.pixelBuffer(forImage: (sizedImage?.cgImage)!) {
            guard let scene = try? machineLearningClassifier.prediction(input__0: pixelBuffer) else {fatalError("Unexpected runtime error")}
            let value : String = scene.classLabel.substring(from: 1, to: 2)
            print("Evalueated class: " + scene.classLabel)
            print("Evaluated painting value (by machine learning model): " + value)
            return Int(value)!
        } else {
            return -1
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
    
    func getHumanPaintingName() -> String {
        return humanPaintingName
    }
    
    func getAIPaintingName() -> String {
        return AIPaintingName
    }
    
    func setFirstPlayerAI(isAI : Bool) {
        isFirstPlayAI = isAI
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
            print("Human folds")
            print("---poker.modifyLastAction(slot: \"haction\", value: \"fold\")")
            poker.modifyLastAction(slot: "haction", value: "fold")
            print("---poker.run()")
            poker.run()
            print("---poker.modifyLastAction(slot: \"haction\", value: \"fold\")")
            poker.modifyLastAction(slot: "haction", value: "fold")
            print("---poker.run()")
            poker.run()
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
    func evaluateCardsAndSetWinner() -> Winner {
        
        print("Coins in pot: " + String(coinsAmountInPot))
        if (humanPaintingValue > AIPaintingValue) {
            humanCoinsAmount! += coinsAmountInPot
            coinsAmountInPot = 0
            return Winner.HumanPlayer
            
        } else if (humanPaintingValue < AIPaintingValue) {
            AICoinsAmount! += coinsAmountInPot
            coinsAmountInPot = 0
            return Winner.AIPlayer
            
        } else {
            GameData.shared.winner = .NoOne
            return Winner.NoOne
            
        }
    }
    
    /**
     Human is the winer: return 1
     AI is the winer: return -1
     No winer: return 0
     */
    func setWinnerAccordingToCoins() -> Winner {
        if (humanCoinsAmount <= 0 && getCoinsInPot() == 0) {
            return Winner.AIPlayer
        } else if (AICoinsAmount <= 0 && getCoinsInPot() == 0) {
            return Winner.HumanPlayer
        } else {
            return Winner.NoOne
        }
    }
}
