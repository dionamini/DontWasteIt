//
//  ViewController.swift
//  DontWasteIt
//
//  Created by Dion Amini on 3/12/16.
//  Copyright © 2016 Dion Amini. All rights reserved.
//

import UIKit
import Firebase


class RegisteredViewController: UIViewController, UITextFieldDelegate {
    let transitionManager = RegisteredTransitionManager()
    
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPass: UITextField!
    
    @IBOutlet weak var log_in: UIButton!
    
    var mesgFrame = UIView()
    var activityInd = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.transitioningDelegate = self.transitionManager
        textEmail.delegate = self
        textEmail.tag = 0
        textPass.delegate = self
        textPass.tag = 1
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
//        view.addGestureRecognizer(tap)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)

        
    }
    
    @IBAction func loginTouched(sender: AnyObject){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondView =  storyboard.instantiateViewControllerWithIdentifier("tabControl") as! UITabBarController
        let email = textEmail.text
        let pass = textPass.text
        
        if email != "" && pass != "" {
            progressBarDisplayer("Logging In", true)
            dispatch_async(dispatch_get_main_queue()){
            
                FireService.fireService.BASE_REF.authUser(email, password: pass, withCompletionBlock: { error, authData in
                    if error != nil {
                        //error
                        print("FAIL")
                        self.loginErrorAlert("Log In Error", message: "Unable to log in. Check email and password", preferred: .ActionSheet)
                        
                        dispatch_async(dispatch_get_main_queue()){
                            self.mesgFrame.removeFromSuperview()
                        }
                    }else {
                    //logged in
                        print("Successful email login. authData:", authData)
                        
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                        
                        dispatch_async(dispatch_get_main_queue()){
                            self.mesgFrame.removeFromSuperview()
                        }
                        self.presentViewController(secondView, animated: true, completion: nil)
                        
                    }})
            }
        }else{
            loginErrorAlert("Oops.", message: "Missing either email or password!", preferred: .Alert)
        }
    }
    
    func loginErrorAlert(title: String, message: String, preferred: UIAlertControllerStyle) {
        
        // Called upon login error to let the user know login didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferred)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
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
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height
                })
            }
        } else {
            print("else in here")
            UIView.animateWithDuration(0.1, animations: { () -> Void in
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
            loginTouched(textField.resignFirstResponder())
            
        }
        return false // We do not want UITextField to insert line-breaks.
    }
    
    func progressBarDisplayer(msg:String, _ indicator:Bool ) {
        print(msg)
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        mesgFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50))
        mesgFrame.layer.cornerRadius = 15
        mesgFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
            activityInd = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityInd.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityInd.startAnimating()
            mesgFrame.addSubview(activityInd)
        }
        mesgFrame.addSubview(strLabel)
        view.addSubview(mesgFrame)
    }
}

