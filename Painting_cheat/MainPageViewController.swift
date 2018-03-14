//
//  MainPageViewController.swift
//  Painting_cheat
//
//  Created by Jed on 13/03/2018.
//  Copyright © 2018 Jed. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {

    var numberOfBit = 0
    var test = 1
    
    @IBOutlet weak var BitsCount: UILabel!
    
    @IBAction func BitLeft(_ sender: UIButton) {
        print("Left player raises")
        numberOfBit += 1
        BitsCount.text = "Number of bits: \(numberOfBit)"
    }
    
    @IBAction func BitRight(_ sender: UIButton) {
        print("Right player raises")
        numberOfBit += 1
        BitsCount.text = "Number of bits: \(numberOfBit)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
