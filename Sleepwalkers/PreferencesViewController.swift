//
//  PreferencesViewController.swift
//  Sleepwalkers
//
//  Created by Victoria Corrodi on 7/9/17.
//  Copyright © 2017 Olivia Corrodi. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController {
    
    var sleepHeaviness: Float = 0.4
    
    var move: Int = 6
    
    @IBOutlet weak var segmentedControl1: UISegmentedControl!
    
    @IBOutlet weak var segmentedControl2: UISegmentedControl!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func firstIndexChanged(_ sender: UISegmentedControl) {
        
        switch segmentedControl1.selectedSegmentIndex {
        case 0:
            sleepHeaviness = 0.2
            defaults.set(sleepHeaviness, forKey:"sleepHeaviness");
            
        case 1:
            sleepHeaviness = 0.4
            defaults.set(sleepHeaviness, forKey:"sleepHeaviness");
            
        case 2:
            sleepHeaviness = 0.6
            defaults.set(sleepHeaviness, forKey:"sleepHeaviness");
        
        default:
            break;
            
        }
    }
    
    @IBAction func secondIndexChanged(_ sender: UISegmentedControl) {
        
        switch segmentedControl2.selectedSegmentIndex {
        case 0:
            move = 8
            defaults.set(move, forKey:"move");
            
        case 1:
            move = 9
            defaults.set(move, forKey:"move");
            
        case 2:
            move = 10
            defaults.set(move, forKey:"move");
            
        default:
            break;
        
        }
    }
    
    
    @IBAction func nextButtonTapped2(_ sender: Any) {
        self.performSegue(withIdentifier: "signUpSegue", sender: self)
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
