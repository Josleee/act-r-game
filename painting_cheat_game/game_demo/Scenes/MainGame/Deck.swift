//
//  Deck.swift
//  PaintingBluff
//
//  Created by BlaueBeere on 03/04/2018.
//  Copyright © 2018 Jed. All rights reserved.
//

import Foundation

let amountOfCategories = 7 //TODO: For simple testing 3, later 7
let amountOfCardsInCategory = 10

class Deck{
    private let totalAmountOfCards = 52
    var deck: [Card] = [] //empty array
    private let paintings = Paintings.paintObject
    
    static let object = Deck()
    
    //Create a deck and init the cards in it
    private init(){
        print(totalAmountOfCards)
        for i in 0..<totalAmountOfCards{
            print(i)
            deck.insert(Card(), at: i)
            print(i)
        }
        print("Deck.init() count", deck.count)
        print(deck)
        print("Deck.init.end.")
    }
    
    //picks a card from the deck and deletes it from deck
    func pickCard() -> Card {
        let card: Card = deck.removeFirst()
        return card
    }
    
}

class Paintings {
    
    static let paintObject = Paintings()
    var mypaintings = [[String]]()
    
    
    
    private init() {
        var pathToFile: String
        
        //create 2d array with picnames
        for category in 0...amountOfCategories  {
            var subArray = [String]()
            for cardInCategory in 0...amountOfCardsInCategory {
                //For 2d array: subArray.append(String(x) + "pic" + String(y))
                pathToFile = "S" + String(category + 1) + "P (" + String(cardInCategory + 1) + ")"
                print(pathToFile)
                subArray.append(pathToFile)
            }
            mypaintings.append(subArray)
        }
    }
    
    
    
    //Returns a specific filename of specific category
    func getFileName(category : Int, number: Int) -> String {
        print("category")
        print(category)
        print("number")
        print(number)
        print(mypaintings)
        return mypaintings[category][number]
    }
    
    
    //Returns a random filename of specific category
    func getRandomFileNameOfCategory(category : Int) -> String {
        let randomPicOfCategory = (Int(arc4random_uniform(UInt32(amountOfCardsInCategory))) + 1)
        return mypaintings[category][randomPicOfCategory]
    }
    
}

