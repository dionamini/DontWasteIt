//
//  InventoryItem.swift
//  DontWasteIt
//
//  Created by Dion Amini on 3/13/16.
//  Copyright © 2016 Dion Amini. All rights reserved.
//

import Foundation
import Firebase


struct InventoryItem{
    private var _itemRef: Firebase!
    private var _itemKey: String!
    private var _itemName: String!
    private var _itemAddDate: String!
    private var _itemExpireDate: String!
    private var _itemNotifyDate: String!
    private var _itemsList: String!
    private var _itemImage: String!
    
    var itemKey: String {
        return _itemKey
    }
    var itemName: String{
        return _itemName
    }
    var itemAddDate: String {
        return _itemAddDate
    }
    var itemExpireDate: String {
        return _itemExpireDate
    }
    var itemRef: Firebase{
        return _itemRef
    }
    var itemImage: String{
        return _itemImage
    }
    var itemNotifyDate: String{
        return _itemNotifyDate
    }
    
    init(key: String, dictionary: Dictionary<String, AnyObject>, currlist: String){
        self._itemKey = key
        
        //this will be the childAutoID
        self._itemsList = currlist
        
        if let name = dictionary["name"] as? String {
            self._itemName = name
        }
        if let addDate = dictionary["addDate"] as? String {
            self._itemAddDate = addDate
        }
        if let expireDate = dictionary["expireDate"] as? String {
            self._itemExpireDate = expireDate
        }
        if let image = dictionary["image"] as? String {
            self._itemImage = image
        }
        if let notifyDate = dictionary["notifyDate"] as? String {
            self._itemNotifyDate = notifyDate
        }
        
        
//        still need to implement itemRef
        self._itemRef = FireService.fireService.INV_REF.childByAppendingPath(self._itemsList).childByAppendingPath("items").childByAppendingPath(self._itemKey)
        
        
    
    }
    
    init(snapshot: FDataSnapshot) {
        self._itemKey = snapshot.key
        self._itemName = snapshot.value["name"] as! String
        self._itemAddDate = snapshot.value["addDate"] as! String
        self._itemExpireDate = snapshot.value["expireDate"] as! String
        self._itemNotifyDate = snapshot.value["notifyDate"] as! String
        self._itemImage = snapshot.value["image"] as! String
    }
    
//    let key: String!
//    let itemName: String
//    var addDate: String!
//    let expireDate: String
//    let ref: Firebase?
//    
//    //Initialize from arbitrary data
//    init(itemName: String, dateExpire: NSDate, key: String = ""){
//        self.itemName = itemName
//        self.key = key
//        self.addDate = NSDate().dateStringWithFormat("MM-dd-yyyy")
//        self.expireDate = dateExpire.dateStringWithFormat("MM-dd-yyyy")
//        ref = nil
//        
//    }
//    
//    init(snapshot: FDataSnapshot){
//        key = snapshot.key
//        self.itemName = snapshot.value["itemName"] as! String
//        addDate = snapshot.value["addDate"] as! String
//        expireDate = snapshot.value["expireDate"] as! String
//        ref = snapshot.ref
//    }
//    
//    func toAnyObject() -> AnyObject {
//        return [
//            "itemName": itemName,
//            "expireDate": expireDate,
//            "addDate": addDate,
//        ]
//    }
    

    
}

extension NSDate {
    func dateStringWithFormat(format: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(self)
    }
}