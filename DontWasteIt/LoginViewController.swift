//
//  ViewController.swift
//  DontWasteIt
//
//  Created by Dion Amini on 3/12/16.
//  Copyright © 2016 Dion Amini. All rights reserved.
//

import UIKit
import Firebase


class LoginViewController: UIViewController {
    let rootRef = Firebase(url: "https://luminous-inferno-5384.firebaseio.com")
    
    @IBOutlet weak var registered_user: UIButton!
    @IBOutlet weak var new_user: UIButton!
//    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }
    @IBAction func unwindToMainViewController (sender: UIStoryboardSegue){
        // bug? exit segue doesn't dismiss so we do it manually...
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

