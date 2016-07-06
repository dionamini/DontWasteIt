//
//  TableViewCell.swift
//  DontWasteIt
//
//  Created by Dion Amini on 3/13/16.
//  Copyright © 2016 Dion Amini. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    var item : InventoryItem!
    
    
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var expireSubtitle: UILabel!
    
    @IBOutlet weak var itemImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(item: InventoryItem){
    
    
        self.item = item
        
        // Set the labels and textView.
        
        self.itemTitle.text = item.itemName
        
        let imageData = NSData (base64EncodedString: item.itemImage, options: NSDataBase64DecodingOptions(rawValue: 0))
        self.itemImage.image = UIImage(data: imageData!)
        
        
        self.expireSubtitle.text = item.itemExpireDate
        
    }
}
