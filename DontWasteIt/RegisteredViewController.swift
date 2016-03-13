//
//  ViewController.swift
//  DontWasteIt
//
//  Created by Dion Amini on 3/12/16.
//  Copyright © 2016 Dion Amini. All rights reserved.
//

import UIKit
import Firebase


class RegisteredViewController: UIViewController {
    let transitionManager = RegisterTransitionManager()
    
    var rootRef = Firebase(url: "https://luminous-inferno-5384.firebaseio.com")
    
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPass: UITextField!
    
    @IBOutlet weak var log_in: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.transitioningDelegate = self.transitionManager
        
    }
    
//    @IBAction func loginTouched(sender: AnyObject){
////        rootRef.createUser(textFieldemail.text, password: textFieldpassword.text, withValueCompletionBlock: { error, result in
////            
////            if error != nil {
////                //error
////            }else{
////                let uid = result["uid"] as? String
////                print("successful creation with uid: \(uid)")
////                self.rootRef.authUser(self.textFieldemail.text, password: self.textFieldpassword.text, withCompletionBlock: { error, authData in
////                    if error != nil {
////                        //error
////                    }else{
////                        //logged in
////                    }
////                })
////            }
////        })
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

