//
//  RoundedTableViewCell.swift
//  TheMaze
//
//  Created by Thomas Mac on 24/10/2017.
//  Copyright © 2017 ThomasNeyraut. All rights reserved.
//

import UIKit

class RoundedTableViewCell : UITableViewCell
{
    @IBOutlet var titleLabel : UILabel!
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.layer.borderColor = AppColors.grayColor.cgColor
        
        self.layer.borderWidth = 2.5
        self.layer.cornerRadius = 7.5
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowColor = AppColors.shadowColor.cgColor
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 0.8
        self.layer.masksToBounds = false
    }
}
