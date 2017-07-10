//
//  InitialViewController.swift
//  Sleepwalkers
//
//  Created by Victoria Corrodi on 7/5/17.
//  Copyright © 2017 Olivia Corrodi. All rights reserved.
//

import Foundation
import UIKit

class InitialViewController: UIViewController{
    
    //Properties
    
    @IBOutlet weak var nextButton: UIButton!
    
    //Functions
    
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if defaults.string(forKey: "name") != nil {
            performSegue(withIdentifier: "toMainController", sender: self)
        } else {
            performSegue(withIdentifier: "segueToPreferences", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 15
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
    }
}
