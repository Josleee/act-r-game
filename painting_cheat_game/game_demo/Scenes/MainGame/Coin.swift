//
//  Coin.swift
//  game_demo
//
//  Created by BlaueBeere on 29/03/2018.
//  Copyright © 2018 Jed. All rights reserved.
//

import SpriteKit
import Foundation

class Coin : SKSpriteNode {
    public var coinOwner = CoinOwner.none
    public var isMoveable = false
    public var parentNode: SKNode?
    
    var xposition: CGFloat = 0
    var yposition: CGFloat = 0
    private var originalPosition : CGPoint!
    
    func ismoveableXpos() -> Bool{
        return (self.xposition < -300)
    }
    func ismoveableYpos() -> Bool{
        return (self.yposition >= -115)
    }
    func isCoinMoveable() -> Bool {
        print("xy")
        print(self.xposition)
        print(self.yposition)
        print("moveable: " + String(ismoveableYpos()))
        print("moveable: " + String(ismoveableXpos()))
        return ismoveableYpos() && ismoveableXpos()
    }
    
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        self.xposition = (touches.first?.location(in: self).x)!
    //        self.yposition = (touches.first?.location(in: self).y)!
    //
    //        print(isMoveable)
    //        isCoinMoveable(xposition: Int(self.xposition), yposition: Int(self.yposition))
    //        print(isMoveable)
    //    }
    
    //update moveability, owner, access
    func updateCoin(xposition: CGFloat, yposition: CGFloat) -> Bool{
        self.xposition = xposition
        self.yposition = yposition
        
        print(ismoveableXpos())
        print(ismoveableYpos())
        if ismoveableXpos() && ismoveableYpos() {
            //then moveable
            print("moveable")
            isMoveable = true
            self.isUserInteractionEnabled = false
            coinOwner = .humanPlayer
            return true
        }else{
            print("NOT moveable")
            self.isUserInteractionEnabled = true
            isMoveable = false
            coinOwner = .aiPlayer
            return false
        }
    }
}

enum CoinOwner: Int{
    case humanPlayer = 1
    case aiPlayer = -1
    case none = 0
}

