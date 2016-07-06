    //
//  ViewController.swift
//  DontWasteIt
//
//  Created by Dion Amini on 3/12/16.
//  Copyright © 2016 Dion Amini. All rights reserved.
//

import UIKit
import Firebase


class NewUserViewController: UIViewController, UITextFieldDelegate {
    let transitionManager = NewUserTransitionManager()
    let loginToInventory = "inventoryTableView"
    
    
    
    
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPass: UITextField!
    @IBOutlet weak var textName: UITextField!
    
    @IBOutlet weak var sign_up: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.transitioningDelegate = self.transitionManager
        textName.delegate = self
        textName.tag = 0
        textEmail.delegate = self
        textEmail.tag = 1
        textPass.delegate = self
        textPass.tag = 2
        //        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        //        view.addGestureRecognizer(tap)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        

    }
    
    @IBAction func signUpTouched(sender: AnyObject){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondView =  storyboard.instantiateViewControllerWithIdentifier("tabControl") as! UITabBarController
        
        let email = textEmail.text
        let pass = textPass.text
        let name = textName.text
        
        if email != "" && pass != "" && name != "" {
            FireService.fireService.BASE_REF.createUser(email, password: pass, withValueCompletionBlock: { error, result in
                if error == nil {
                    if( result != nil) {
                        print("result:", result)
                        
                        let uid = result["uid"] as? String
                        print("successful creation with uid: \(uid)")
                        FireService.fireService.BASE_REF.authUser(email, password: pass, withCompletionBlock: { error, authData in
                            if error != nil {
                                //error
                                print("error authorizing user after creation")
                                self.signupErrorAlert("Authorization Error", message: "Couldn't authorize user after creation.", preferred: .ActionSheet)
                            }else{
                                //logged in
//                                let newUser = User(authData: authData)
//                                var newUserRef = "users/" + (authData.uid as String)
//                                var r = FireService.fireService.BASE_REF.childByAppendingPath(newUserRef)
//                                print(r)
//                                r.setValue(authData.uid.lowercaseString)
//                                r = r.childByAppendingPath("userInfo/")
//                                r.setValue("test")
                                
                                FireService.fireService.createNewAccount(authData, username: name)
                                
                                NSUserDefaults.standardUserDefaults().setValue(result ["uid"], forKey: "uid")
                                
                                self.presentViewController(secondView, animated: true, completion: nil)
                                
                                
                            }
                        })
                    }
                    else{
                        print("error == nil but result was nil")
                    }
                }
                else{
                    print("error: couldnt create a user")
                    print("ERROR_CODE = ", error.code)
                    switch(error.code){
                        case -9:
                            print("error: email taken")
                            self.signupErrorAlert("Email taken", message: "Email already has an account. Please login or signup with a different email address.", preferred:  .ActionSheet)
                            break
                        case -5:
                            print("error: invalid email")
                            self.signupErrorAlert("Invalid Email", message: "Email entered was invalid. Please check spelling", preferred: .ActionSheet)
                        default:
                            print("error: default error")
                            self.signupErrorAlert(
                                
                                "Error", message: "There was an error creating your account", preferred: .ActionSheet)
                    }
                    
                    print("error:", error)
                }
                
                
            })
        }else{
            print("error: textEmail or textPass or textName == \"\"")
        }
    }
    
    func signupErrorAlert(title: String, message: String, preferred: UIAlertControllerStyle) {
        
        // Called upon signup error to let the user know signup didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferred)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

    
    
    @IBAction func twitterAuthTouched(sender: AnyObject){
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        indicator.frame = CGRectMake(0.0, 0.0, 60.0, 60.0);
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubviewToFront(view)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        indicator.startAnimating()
        
        
        
        let twitterAuthHelper = TwitterAuthHelper(firebaseRef: FireService.fireService.BASE_REF, apiKey:"sn1gOzxnapaFHRonsHG67Q9TC")
        
        twitterAuthHelper.selectTwitterAccountWithCallback { error, accounts in
            if error != nil {
                // Error retrieving Twitter accounts
                print("error no twitters")
            } else{ //if accounts.count > 1 {
                // Select an account. Here we pick the first one for simplicity
                
                print("accounts: ", accounts)

                NSThread.sleepForTimeInterval(2)
                
                var account : ACAccount?
                var accfound : Bool = false
                let alertController = UIAlertController(title: "Twitter Accounts", message: "Choose one to sign up.", preferredStyle: .ActionSheet)
                var last = 0
                
           
//                if(accounts.count > 1){
                    for accountIter in accounts{
                        
                        let accName  = accountIter.accountDescription as String
                        let aAction = UIAlertAction(title: accName, style: .Destructive) { (action) in
                            // ...
                            accfound = true
                            account = (accountIter as! ACAccount)
                            print("POPOPOPOPOPOP:", account)
                            
                        }
                        alertController.addAction(aAction)
                        last += 1
                        if last == accounts.count{
                            let cancelAction = UIAlertAction(title: "Cancel", style: .Default){ (action) in
                                //...
                                accfound = false
                            }
                            alertController.addAction(cancelAction)
                        }
                        
                    }
                    
                    self.presentViewController(alertController, animated: true){
                        // ...
                        
                    }
//                }else {
//                    accfound = true
//                    account = accounts[0] as! ACAccount
//                }
                
                if accfound{
                    
                    twitterAuthHelper.authenticateAccount(account, withCallback: { error, authData in
                        if error != nil {
                            // Error authenticating account
                            print("error authenticating")
                        } else {
                            print("success twitters")
                            //HERE AUTHDATA LIVES.
                            //TODO: CREATE THE NEW TWITTER USER ACCOUNT
                            
                        }
                    })
                }else{
                    
                    let ally = UIAlertController(title: "Twitter Account.", message: "Must choose one for twitter authentication.", preferredStyle: .Alert)
                    let aAction = UIAlertAction(title: "Ok", style: .Default) { (action) in
                        // ...
                        
                    }
                    ally.addAction(aAction)
                    
                    self.presentViewController(ally, animated: true){}
                }
                
                
            }
//            else{
//                let account = accounts[0] as? ACAccount
//                twitterAuthHelper.authenticateAccount(account, withCallback: { error, authData in
//                    if error != nil {
//                        //error
//                        print("error authenticating")
//                    }else{
//                        print("success twitter")
//                        
//                        
//                        
//                    }})
//            }
        }
        indicator.stopAnimating()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        storyboard.instantiateViewControllerWithIdentifier("tabControl") as! UITabBarController
        
//        
//        let ref = rootRef
//        ref.observeAuthEventWithBlock({ authData in
//            if authData != nil {
//                //user authenticated
//                print("authData twitter:", authData)
//                
//                self.presentViewController(secondView, animated: true, completion: nil)
//            }
//            else {
//                //no user is signed in
//                print("no user signed in")
//            }
//        })
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    /**
     * remove your observers before you leave the view to prevent unnecessary messages from being transmitted.
     */
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo: [NSObject : AnyObject] = notification.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        if keyboardSize.height == offset.height {
            print("keyboard height is offset height")
            if self.view.frame.origin.y == 0{
                UIView.animateWithDuration(0.0, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height
                })
                
            }
        } else {
            print("else in here")
            UIView.animateWithDuration(0.0, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag: NSInteger = textField.tag + 1;
        // Try to find next responder
        if let nextResponder: UIResponder! = textField.superview!.viewWithTag(nextTag){
            nextResponder.becomeFirstResponder()
        }
        else {
            // Not found, so remove keyboard.
            print("text:", textField.text)
            
            if(textField == textPass){
                print("inside of if statement")
                textField.resignFirstResponder()
                signUpTouched(textPass)
            }else{
                textField.resignFirstResponder()
            }
            
        }
        return false // We do not want UITextField to insert line-breaks.
    }
    
    
    
}

