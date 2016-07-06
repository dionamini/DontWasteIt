//
//  FireService.swift
//  DontWasteIt
//
//  Created by Dion Amini on 3/20/16.
//  Copyright © 2016 Dion Amini. All rights reserved.
//

import Foundation
import Firebase

class FireService {
    static let fireService = FireService()
    
    static let BASE_URL = "https://luminous-inferno-5384.firebaseIO.com/"
    
    private var _BASE_REF = Firebase(url: "\(BASE_URL)")
    private var _USER_REF = Firebase(url: "\(BASE_URL)/users")
    private var _INV_REF = Firebase(url: "\(BASE_URL)/invs")
    
    var BASE_REF: Firebase {
        return _BASE_REF
    }
    
    var USER_REF: Firebase {
        return _USER_REF
    }
    
    var CURRENT_USER_REF: Firebase {
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        
        let currentUser = Firebase(url: "\(BASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
        
        return currentUser!
    }
    
    var INV_REF: Firebase {
        return _INV_REF
    }
    
    func createNewAccount(authData: FAuthData, username: String!){
        var newuser = [String: String]()
        var inv1 = [String: String]()
        
        let newUserEmptyInvRef = FireService.fireService.INV_REF.childByAutoId()
        newUserEmptyInvRef.setValue(newUserEmptyInvRef.key)
        
        if authData.provider == "password" {
            newuser = ["username": username, "provider": authData.provider!, "id": authData.providerData ["email"]! as! String, "inv-count": "1", "uid": authData.uid, "curr-inv": newUserEmptyInvRef.key]
        }
        else if authData.provider == "twitter" {
            newuser = ["username": username, "provider": authData.provider!, "id": authData.providerData ["id"]! as! String, "inv-count": "1", "uid": authData.uid, "curr-inv": newUserEmptyInvRef.key]
        
        }
        
        inv1 = ["uid": authData.uid, "items": ""]
        
        USER_REF.childByAppendingPath(authData.uid).setValue(newuser)
        USER_REF.childByAppendingPath(authData.uid).childByAppendingPath("inv-list").childByAppendingPath(newUserEmptyInvRef.key).setValue(newUserEmptyInvRef.key)
        INV_REF.childByAppendingPath(newUserEmptyInvRef.key).setValue(inv1)
        
    
    }
    
    
    func createNewItem(inv_list: String, item: Dictionary<String, AnyObject>){
        //Save the Item
        let firebaseNewItem = INV_REF.childByAppendingPath(inv_list).childByAppendingPath("items").childByAutoId()
        
        firebaseNewItem.setValue(item)
    
    }
    
}