//
//  TableViewCellWithImage.swift
//  CellLibrary
//
//  Created by Thomas Mac on 06/06/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

class TableViewCellWithImage: UITableViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let decalage = CGFloat(10.0)
        
        self.imageView?.frame = CGRect(x: decalage, y: decalage, width: self.frame.size.height - 2 * decalage, height: self.frame.size.height - 2 * decalage)
        
        self.textLabel?.frame = CGRect(x: (self.imageView?.frame.size.width)! + 2 * decalage, y: 0.0, width: self.frame.size.width - (self.imageView?.frame.size.width)! - 3 * decalage, height: self.frame.size.height)
        
        self.layer.borderColor = UIColor(red:213.0/255.0, green:210.0/255.0, blue:199.0/255.0, alpha:1.0).cgColor
        
        self.layer.borderWidth = 2.5
        self.layer.cornerRadius = 7.5
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 0.8
        self.layer.masksToBounds = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
