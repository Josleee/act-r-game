//
//  GameScene.swift
//  game_demo
//
//  Created by Jed on 15/03/2018.
//  Copyright © 2018 Jed. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private let moveNodeUp = SKAction.moveBy(x: 0, y: 10, duration: 0.2)
    private let moveNodeDown = SKAction.moveBy(x: 0, y: -10, duration: 0.2)
    private let model = Classifier()
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.black
        
        let myLabel = SKLabelNode(fontNamed: "Chalkduster")
        myLabel.text = "Welcome to Painting Bluff @~@"
        myLabel.fontSize = 28
        myLabel.position = CGPoint(x: 0, y: 30)
        self.addChild(myLabel)
        
        let startLabel = SKLabelNode(fontNamed: "Chalkduster")
        startLabel.text = "Start  Game"
        startLabel.name = "start"
        startLabel.fontSize = 17
        startLabel.position = CGPoint(x: 0, y: -35)
        self.addChild(startLabel)
        
        let ruleLabel = SKLabelNode(fontNamed: "Chalkduster")
        ruleLabel.text = "Check Rules"
        ruleLabel.name = "rule"
        ruleLabel.fontSize = 17
        ruleLabel.position = CGPoint(x: 0, y: -75)
        self.addChild(ruleLabel)
    }
    
    func convertUIImageToCGImage(uiImage:UIImage) -> CGImage {
        var cgImage = uiImage.cgImage
        
        if cgImage == nil {
            let ciImage = uiImage.ciImage
            cgImage = self.convertCIImageToCGImage(ciImage: ciImage!)
        }
        return cgImage!
    }
    
    func convertCIImageToCGImage(ciImage:CIImage) -> CGImage{
        let ciContext = CIContext.init()
        let cgImage:CGImage = ciContext.createCGImage(ciImage, from: ciImage.extent)!
        return cgImage
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameSceneTemp = MainGameScene(fileNamed: "MainGameScene")
        let rulesSceneTemp = RulesScene(fileNamed: "RulesScene")
        
        //new game, get touch
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodeArray = self.nodes(at: location)
            
            //Raise button pressed
            if (nodeArray.first?.name == "start") {
                self.scene?.view?.presentScene(gameSceneTemp!, transition: SKTransition.flipVertical(withDuration: 1))

            } else if (nodeArray.first?.name == "rule") {
                let testImage = UIImage(named: "pic")
                if let pixelBuffer = ImageProcessor.pixelBuffer(forImage: convertUIImageToCGImage(uiImage: testImage!)) {
                    guard let scene = try? model.prediction(input__0: pixelBuffer) else {fatalError("Unexpected runtime error")}
                    print(scene.classLabel)
                }
//                self.scene?.view?.presentScene(rulesSceneTemp!, transition: SKTransition.flipVertical(withDuration: 1))
            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
