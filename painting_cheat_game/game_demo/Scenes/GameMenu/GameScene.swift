//
//  GameScene.swift
//  game_demo
//
//  Created by Jed on 15/03/2018.
//  Copyright © 2018 Jed. All rights reserved.
//

import SpriteKit
import GameplayKit
import Vision
import CoreML

class GameScene: SKScene {
    
    private let moveNodeUp = SKAction.moveBy(x: 0, y: 10, duration: 0.2)
    private let moveNodeDown = SKAction.moveBy(x: 0, y: -10, duration: 0.2)
    private let machineLearningClassifier = Classifier()
    
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
    
    
    func resizeImage(image: UIImage, newLength: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: newLength, height: newLength))
        image.draw(in: CGRect(x: 0, y: 0, width: newLength, height: newLength))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameSceneTemp = MainGameScene(fileNamed: "MainGameScene")
        let rulesSceneTemp = RulesScene(fileNamed: "RulesScene")
        
        let touch = touches.first
        if let location = touch?.location(in: self) {
            let nodeArray = self.nodes(at: location)
            
            if (nodeArray.first?.name == "start") {
                var poker = Model()
                poker.loadModel(fileName: "test")
                poker.run()
//                self.scene?.view?.presentScene(gameSceneTemp!, transition: SKTransition.flipVertical(withDuration: 1))

            } else if (nodeArray.first?.name == "rule") {
                let testImage = UIImage(named: "S1P (1)")

                DispatchQueue.global(qos: .userInitiated).async {
                    // Resnet50 expects an image 224 x 224, so we should resize and crop the source image
                    let inputImageSize: CGFloat = 224.0
                    let minLen = min((testImage?.size.width)!, (testImage?.size.height)!)
                    let resizedImage = testImage?.resize(to: CGSize(width: inputImageSize * (testImage?.size.width)! / minLen, height: inputImageSize * (testImage?.size.height)! / minLen))
                    let cropedToSquareImage = resizedImage?.cropToSquare()

                    guard let pixelBuffer = cropedToSquareImage?.pixelBuffer() else {
                        fatalError()
                    }
                    guard let classifierOutput = try? self.machineLearningClassifier.prediction(input__0: pixelBuffer) else {
                        fatalError()
                    }

                    DispatchQueue.main.async {
                        print(classifierOutput.classLabel)
                    }
                }

//                let sizedImage = resizeImage(image: testImage!, newLength: 224)
//                if let pixelBuffer = ImageProcessor.pixelBuffer(forImage: (sizedImage?.cgImage)!) {
//                    guard let scene = try? model.prediction(input__0: pixelBuffer) else {fatalError("Unexpected runtime error")}
//                    print(scene.classLabel)
//                }
//                self.scene?.view?.presentScene(rulesSceneTemp!, transition: SKTransition.flipVertical(withDuration: 1))
            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}


extension UIImage {
    
    func resize(to newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newSize.width, height: newSize.height), true, 1.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
    func cropToSquare() -> UIImage? {
        guard let cgImage = self.cgImage else {
            return nil
        }
        var imageHeight = self.size.height
        var imageWidth = self.size.width
        
        if imageHeight > imageWidth {
            imageHeight = imageWidth
        }
        else {
            imageWidth = imageHeight
        }
        
        let size = CGSize(width: imageWidth, height: imageHeight)
        
        let x = ((CGFloat(cgImage.width) - size.width) / 2).rounded()
        let y = ((CGFloat(cgImage.height) - size.height) / 2).rounded()
        
        let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
        if let croppedCgImage = cgImage.cropping(to: cropRect) {
            return UIImage(cgImage: croppedCgImage, scale: 0, orientation: self.imageOrientation)
        }
        
        return nil
    }
    
    func pixelBuffer() -> CVPixelBuffer? {
        let width = self.size.width
        let height = self.size.height
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(width),
                                         Int(height),
                                         kCVPixelFormatType_32ARGB,
                                         attrs,
                                         &pixelBuffer)
        
        guard let resultPixelBuffer = pixelBuffer, status == kCVReturnSuccess else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(resultPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(resultPixelBuffer)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(data: pixelData,
                                      width: Int(width),
                                      height: Int(height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(resultPixelBuffer),
                                      space: rgbColorSpace,
                                      bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
                                        return nil
        }
        
        context.translateBy(x: 0, y: height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(resultPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        return resultPixelBuffer
    }
}
