//
//  Card.swift
//  game_demo
//
//  Created by BlaueBeere on 19/03/2018.
//  Copyright © 2018 BlaueBeere. All rights reserved.
//
import SpriteKit
import Foundation


let amountOfCategories = 3 //TODO: For simple testing 3, later 7
let amountOfCardsInCategory = 2

//TODO: Some node magic required and image :D
class Card : SKSpriteNode {
    var visible = false
    let cardValue = Int(arc4random_uniform(UInt32(amountOfCategories))) + 1 //1-7
    let cardName = "pic3"//TODO get cardname from 2D array of pictures maybe create class of pictures

    func getCardValue() -> Int {
        return cardValue
    }
    
    //Returns the card name jpg string
    func getCardName() -> String {
        return cardName
    }
    
    //Make card visible
    func revealCardAndShowImage(){
        self.visible = true
    }
    
    //Later for pictures:
    //------------------
    //var image = 0//TODO: image CGImage
    //Get image
    //func getImage()
    
    //Get a random cardValue
    //    func getCardValue() -> Int {
    //        return -1
    //    }
    
}


class Pictures {
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    
    var storage = [[String]]()
    init() {
        //create 2d array with picnames
        for x in 0..<amountOfCategories  {
            var subArray = [String]()
            for y in 0..<amountOfCategories {
                subArray.append(String(x) + "pic" + String(y))
            }
            storage.append(subArray)
        }
    }
    
    //Returns a random filename of specific category
    func getRandomFileNameOfCategory(category : Int) -> String {
        let randomPicOfCategory = (Int(arc4random_uniform(UInt32(amountOfCardsInCategory))) + 1)
        return storage[category][randomPicOfCategory]
    }
    
    //Returns a specific filename of specific category
    func getFileName(category : Int, number: Int) -> String {
        return storage[category][number]
    }
    
//    subscript(row: Int, column: Int ) -> String {
//        get {
//            // This could validate arguments.
//            return storage[row][(Int(arc4random_uniform(UInt32(amountOfCardsInCategory))) + 1)] //Name of card = Categorynumber + pic + amountofcardsincategory]
//        }
//        set {
//            // This could also validate.
//            storage[row][column] = newValue
//        }
//    }
    
    
    
}

class CardHelper {
    
    let cardPicture : [[String]] = [[]]
    
    func choosePicture(){
        
    }
}

