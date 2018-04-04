//
//  Card.swift
//  game_demo
//
//  Created by BlaueBeere on 19/03/2018.
//  Copyright © 2018 BlaueBeere. All rights reserved.
//
import SpriteKit
import Foundation


//TODO: Some node magic required and image :D
class Card : SKSpriteNode {
    var visible = false
    //    let cardValue : Int
    //    let cardName : String //TODO get cardname from 2D array of pictures maybe create class of pictures
    let backgroundpicture = "BG"
    let pics = Paintings.paintObject
    let cardValue = Int(arc4random_uniform(UInt32(amountOfCategories)))  //0-6
    let cardName : String
    // let cardName = pics.getFileName(category: cardValue, number: 1)
    let sizeX : CGFloat = 122 //(self.scene!.size.width / 6)
    let sizeY : CGFloat = 82 //(self.scene!.size.height / 5)
    
    
    init() {
        //        print(pics)
        //        self.cardName = pics.getFileName(category: cardValue, number: 0)
        self.cardName = pics.getFileName(category: cardValue, number: 0)
        print(self.cardName)
        let texture = SKTexture(imageNamed: backgroundpicture)
        super.init(texture: texture, color: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), size: CGSize(width: 122, height: 82))
        //        self.cardValue = Int(arc4random_uniform(UInt32(amountOfCategories))) + 1 //1-7
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func getCardValue() -> Int {
        return cardValue
    }
    
    //Returns the card name jpg string
    func getCardName() -> String {
        return cardName
    }
    
    //Make card visible
    func revealCardAndShowImage(){
        print(self.getCardName())
        self.texture = SKTexture(imageNamed: self.getCardName())
        self.visible = true
    }
    
}










