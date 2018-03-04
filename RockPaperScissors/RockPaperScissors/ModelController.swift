//
//  ModelController.swift
//  RockPaperScissors
//
//  Created by A.J. Stuive on 23/02/2018.
//  Copyright © 2018 A.J. Stuive. All rights reserved.
//

import UIKit

class ModelController: NSObject {

    var model = Model()
    
    model.loadModel("rps")
    model.run()
    
    
    
    
}
