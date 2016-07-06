//
//  InventoryViewController.swift
//  DontWasteIt
//
//  Created by Dion Amini on 3/13/16.
//  Copyright © 2016 Dion Amini. All rights reserved.
//

import UIKit
import Firebase



class InventoryViewController: UITableViewController {
    // MARK : Constants
    let LoginToList = "LoginToList"
    let ref = Firebase(url: "https://luminous-inferno-5384.firebaseIO.com/grocery-items")
    
    
    
    // MARK: Properties
//    var newItem: InventoryItem = nil
    var items = [InventoryItem]()
    var user: User!
    var tems = [InventoryItem]()
    var currentUsername: String = ""
    var toPass : InventoryItem!
    
    var mesgFrame = UIView()
    var activityInd = UIActivityIndicatorView()
    var strLabel = UILabel()
    
//    @IBAction func addButtonTouched(sender: AnyObject){
//        let alert = UIAlertController(title: "Spogooter",
//            message: "Add an item",
//            preferredStyle: .Alert)
//        
//        let saveAction = UIAlertAction(title: "Save Item",
//            style: .Default) { (action: UIAlertAction) -> Void in
//                
//                let itemDic : [String:String] = [
//                "name" =
//                
//                ]
//                
//                let textField = alert.textFields![0]
//                let invItem = InventoryItem(itemName: textField.text!, dateExpire: NSDate())
//                
//                let invItemRef = self.ref.childByAppendingPath(textField.text?.lowercaseString)
//                
//                invItemRef.setValue(invItem.toAnyObject())
//                
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction) -> Void in
//        }
//        alert.addTextFieldWithConfigurationHandler({
//            (textField: UITextField!) -> Void in
//        })
//        
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//        
//        presentViewController(alert, animated: true, completion: nil)
//    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up swipe to delete
        tableView.allowsMultipleSelectionDuringEditing = false
        
//        var i1dic : [String:String] = 
//        items = [ InventoryItem(itemName: "example", dateExpire: NSDate(), currlist: "")]
//        items = [ InventoryItem(key: "", dictionary: ["name" = "testname", "addDate" = NSDate().dateStringWithFormat("MM-dd-yyyy"), "expireDate" = NSDate().dateStringWithFormat("dd-yyyy")], currlist: "whoknows")]
        
        progressBarDisplayer("Loading", true)
        dispatch_async(dispatch_get_main_queue()){
            self.loadTable()
            dispatch_async(dispatch_get_main_queue()){
                self.mesgFrame.removeFromSuperview()
            }
        }
        
        
            
            
            
            
            
//            let currlist = snapshot.value.objectForKey("inv-list")!.queryOrderedByKey().queryStartingAtValue(listnum).queryEndingAtValue(listnum)
//            
//            FireService.fireService.INV_REF.observeEventType(FEventType.Value, withBlock: {snapshot in
//                let theInventory = snapshot.value.objectForKey(currlist)
//                print(theInventory)
//                
//            
//            })
            
            
        
        
        
        
 

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func loadTable(){
        let curr_user = FireService.fireService.CURRENT_USER_REF
        
        curr_user.observeEventType(FEventType.Value, withBlock: { snapshot in
            
            let currentUser = snapshot.value.objectForKey("id") as! String
            
            
            //            let enumerator = snapshot.children
            //
            //            while let child = enumerator.nextObject() as? FDataSnapshot {
            //                print("CHILD:", child)
            //                print("value: ", child.childSnapshotForPath("inv-list").value)
            //            }
            
            //            let inv_lists = snapshot.value.objectForKey("inv-list") as! NSDictionary
            
            
            curr_user.childByAppendingPath("inv-list").queryLimitedToFirst(1).observeEventType(.ChildAdded, withBlock: {snapshots in
                let currList = snapshots.key
                print("---s---\nK:", snapshots.key, "\nV:", snapshots.value, "\n---e---")
//                print("thelistV:\n", snapshots.value)
                
                NSUserDefaults.standardUserDefaults().setValue(currList, forKey: "currList")
                
                FireService.fireService.INV_REF.childByAppendingPath(currList).childByAppendingPath("items").observeEventType(
                    .Value,
                    withBlock: { snapshots in
                        self.items = []
                        if let snaps = snapshots.children.allObjects as? [FDataSnapshot]{
                            
                            for snap in snaps {
                                if snaps.count > 40 { break }
                                if let itemDic = snap.value as? Dictionary<String, AnyObject>{
                                    let key = snap.key
                                    let item = InventoryItem(key: key, dictionary: itemDic, currlist: currList)
                                    self.items.insert(item, atIndex: 0)
                                }
                                
                            }
                        }
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tableView.reloadData()
                        }
                        
                        
                })
                
            })
            print("currentUsername: \(currentUser)")
            
            //            print(snapshot.value)
            self.currentUsername = currentUser
            

            }, withCancelBlock: { error in
                print("CURRENT_USER_REF error:", error.description)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancel(segue:UIStoryboardSegue) {
        print("canceled add to inventory")
    }
    
    @IBAction func done(segue:UIStoryboardSegue) {
        print("left adding, back to table.")
        
        
        
//        var newItem =  InventoryItem(itemName: newItemVC.name!, dateExpire: newItemVC.expire)
        
//        newItem = InventoryItem.init(itemName: newItemVC.name!, dateExpire: newItemVC.expire)
        
//        items.append(newItem)
        tableView.reloadData()
        
        
        
//        let invItemRef = self.ref.childByAppendingPath(newItem.itemName.lowercaseString)
//                
//        invItemRef.setValue(newItem.toAnyObject())
        
        
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("You selected cell number: \(indexPath.row)!")
        
        
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //        return 0
        
//        return items.count
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ref.observeAuthEventWithBlock { authData in
//            if authData != nil {
//                print("invVC authData: ", authData)
//            }
        }
        loadTable()
//        ref.observeEventType(.Value, withBlock: { snapshot in
//            
//            var newItems = [InventoryItem]()
//            
//            for item in snapshot.children {
//                
//                let invItem = InventoryItem(snapshot: item as! FDataSnapshot)
//                newItems.append(invItem)
//            }
//            self.items = newItems
//            self.tableView.reloadData()
//    
//        })
    }
        
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
            
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell") as! TableViewCell
        let inventoryItem = items[indexPath.row]
        
//        let dateFormatter = NSDateFormatter()
        
//        dateFormatter.dateFormat = "MM-dd-yyyy"
        
//        let expireDate : String = dateFormatter.dateFromString(inventoryItem.expireDate)
        
//        cell.textLabel?.text = inventoryItem.itemName
//        cell.detailTextLabel?.text = inventoryItem.itemExpireDate
        
        
        cell.itemTitle.text = inventoryItem.itemName
        cell.expireSubtitle.text = inventoryItem.itemExpireDate
        
//        let imageData = NSData (base64EncodedString: inventoryItem.itemImage, options: NSDataBase64DecodingOptions(rawValue: 0))
        

        

        //create image instance 
//        let image : UIImage = UIImage(named:"blueButton.png")!
        
        let decodedData = NSData(base64EncodedString: inventoryItem.itemImage, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        
//        let imageData = UIImagePNGRepresentation(image)
//        let base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
//        print(base64String)
        
        //OR with path var url:NSURL = NSURL(string : "urlHere")! var imageData:NSData = NSData.dataWithContentsOfURL(url, options: nil, error: nil)

        cell.itemImage.image = UIImage(data: decodedData!)
        
        
        // Determine whether the cell is checked
//        toggleCellCheckbox(cell, isCompleted: groceryItem.completed)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Find the snapshot and remove the value
//            items.removeAtIndex(indexPath.row)
            print("item in items:", items[indexPath.item])
            let remove = items[indexPath.item].itemRef
            print(remove)
            remove.removeValue()
            
            print("indexPath.item:", indexPath.item)
            
            items.removeAtIndex(indexPath.row)
            
            
            tableView.reloadData()
        }
    }
    
    
    @IBAction func cancelToInvViewController(segue:UIStoryboardSegue) {
    }
    
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
//     MARK: - Navigation

//     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//         Get the new view controller using segue.destinationViewController.
//         Pass the selected object to the new view controller.
        
        if(segue.identifier == "itemDetailSegue"){
            let svc = segue.destinationViewController as! ItemDetailViewController
            let selectedRow = tableView.indexPathForSelectedRow!.row
            
            svc.theItem = items[selectedRow]
        
        }
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
