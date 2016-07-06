//
//  AddToInventoryViewController.swift
//  DontWasteIt
//
//  Created by Dion Amini on 3/14/16.
//  Copyright © 2016 Dion Amini. All rights reserved.
//

import UIKit
import Firebase
import Mixpanel



class AddToInventoryViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var imageP: UIImageView!
    var picker:UIImagePickerController?=UIImagePickerController()
   
    @IBOutlet weak var selectImage: UIButton!
    @IBOutlet weak var itemName: UITextField!
    
    var currentUserID = ""
    var currentUserName = ""
    var currentList = ""
    let mixpanel = Mixpanel.sharedInstanceWithToken("ec8c1e9c81dbe18278fe559889c8c902")
    
    
    
    var expire: NSDate!
    var newItem : InventoryItem!
    
    @IBOutlet weak var datePick: UIDatePicker!
    
    @IBAction func selectedImageButton(sender: AnyObject) {
        print("pressed select image")
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default)
        {
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
        {
            UIAlertAction in
        }
        // Add the actions
        picker?.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(alert, animated: true, completion: nil)
        }

    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        picker .dismissViewControllerAnimated(true, completion: nil)
        imageP.image=info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        print("picker cancel.")
    }
    
    
    @IBAction func pressedSaveButton(sender: AnyObject) {
//        let ref = Firebase(url: "https://luminous-inferno-5384.firebaseIO.com/users/")
//        let curr_uid = ref.authData.uid
//        let inventoryPath = ref.childByAppendingPath(curr_uid + "/inventory/")
//        let newItem = InventoryItem(itemName: itemName.text!, dateExpire: datePick.date)
//        inventoryPath.setValue(newItem.toAnyObject())
//        print(newItem.toAnyObject())

        let name = itemName.text
        let addDate = NSDate().dateStringWithFormat("MM-dd-yyyy")
        let expireDatePicked = datePick.date.dateStringWithFormat("MM-dd-yyyy")
        print("pressed SAVE!", name, addDate, expireDatePicked, "\n")
        
        
//        let imageData = UIImagePNGRepresentation(imageP.image!)
        

        let imageData = UIImageJPEGRepresentation(imageP.image!, 0.1)
        let base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        print("length of string:", base64String.characters.count)
//        print(base64String)
        
        if name != "" {
                //do stuff with the new object.
//                newItem = InventoryItem()
            let today = NSDate()
            let tomorrow = NSCalendar.currentCalendar().dateByAddingUnit(
                .Day,
                value: 1,
                toDate: today,
                options: NSCalendarOptions(rawValue: 0))
            let reminderDate : NSDate
            if(datePick.date == tomorrow){
                print("\n", tomorrow, "\n")
                reminderDate = NSDate().dateByAddingTimeInterval(15)
            }else{
                reminderDate = datePick.date.dateByAddingTimeInterval(-86400)
            }
            
            let notifyDateFormatted = reminderDate.dateStringWithFormat("MM-dd-yyyy")
            
            let newItemDic: Dictionary<String, AnyObject> = [
                "name": name!,
                "addDate": addDate,
                "expireDate": expireDatePicked,
                "notifyDate": notifyDateFormatted,
                "image" : base64String
            ]
            
            mixpanel.track("Added Item",
                properties: ["name": name!, "expireDate": expireDatePicked, "fireDate": reminderDate]);

            
            
            FireService.fireService.createNewItem(currentList, item: newItemDic)
            
            
            let notification = UILocalNotification()
            notification.fireDate = reminderDate
            notification.alertBody = "Reminder: You have an expiring food: \(name!)!"
            notification.alertAction = "Open Don't Waste It!"
            notification.soundName = UILocalNotificationDefaultSoundName
//            notification.userInfo = ["CustomField1": "w00t"]
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            
            
            
            self.dismissViewControllerAnimated(true, completion: nil);
//            if let navController = self.navigationController {
//                navController.popViewControllerAnimated(true)
//            }
            
        }else{
            print("no item name was given")
        }
        
        
        
//        name = itemName.text!
//        expire = datePick.date
    }
    
    
    
    
    @IBAction func datePickerChanged(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        let expireD = dateFormatter.stringFromDate(datePick.date)
        print("date changed to", expireD)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePick.setDate(NSDate(), animated: true)
        
        itemName.delegate = self
        
        
            
        // Get username of the current user, and set it to currentUsername, so we can add it to the Joke.
        FireService.fireService.CURRENT_USER_REF.observeEventType(FEventType.Value, withBlock: { snapshot in
                
            let currentUser = snapshot.value.objectForKey("uid") as! String
            let currentUserName = snapshot.value.objectForKey("username") as! String
            let currentList = snapshot.value.objectForKey("curr-inv") as! String
            print("f")
            print("UserID: \(currentUser)")
            print("UserName: \(currentUserName)")
            print("CurrentList: \(currentList)")
            
            self.currentUserID = currentUser
            self.currentUserName = currentUserName
            self.currentList = currentList
            
            
                }, withCancelBlock: { error in
                    print(error.description)
            })
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
       
        
        
        
        
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
    
    

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag: NSInteger = textField.tag + 1;
        // Try to find next responder
        if let nextResponder: UIResponder! = textField.superview!.viewWithTag(nextTag){
            nextResponder.becomeFirstResponder()
        }
        else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
            
        }
        return false // We do not want UITextField to insert line-breaks.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo: [NSObject : AnyObject] = notification.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0{
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height
                })
            }
        } else {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height
                    //- offset.height
            })
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }

    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            openGallery()
        }
    }
    func openGallery()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(picker!, animated: true, completion: nil)
        }

    }


}
