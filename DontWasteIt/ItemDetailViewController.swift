//
//  ItemDetailViewController.swift
//  DontWasteIt
//
//  Created by Dion Amini on 4/9/16.
//  Copyright © 2016 Dion Amini. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {

    var theItem : InventoryItem!
    
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var expireDate: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var notifyDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        print(theItem)
        itemName.text = theItem.itemName
        expireDate.text = theItem.itemExpireDate
        notifyDate.text = theItem.itemNotifyDate
        let myDateF = NSDateFormatter()
        let myDate = myDateF.dateFromString( theItem.itemExpireDate )
//        if myDate!.timeIntervalSinceNow.isSignMinus {
//            //myDate is earlier than Now (date and time)
//            print("got in here")
//        } else {
//            //myDate is equal or after than Now (date and time)
//            print("got in there")
//        }
        
        
        
        let decodedData = NSData(base64EncodedString: theItem.itemImage, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        imageView.image = UIImage(data: decodedData!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
