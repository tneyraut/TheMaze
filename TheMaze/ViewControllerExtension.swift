//
//  ViewControllerExtension.swift
//  TheMaze
//
//  Created by Thomas Mac on 25/10/2017.
//  Copyright © 2017 ThomasNeyraut. All rights reserved.
//

import UIKit

extension UIViewController
{
    func setRightNavBarButton(title: String)
    {
        let shadow = NSShadow()
        shadow.shadowColor = AppColors.textShadowColor
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        
        let rightButton = UIBarButtonItem(title:title, style:UIBarButtonItemStyle.done, target:nil, action:nil)
        
        rightButton.setTitleTextAttributes([NSForegroundColorAttributeName: AppColors.textWhiteColor, NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:Constants.fontName, size:21.0)!], for:UIControlState())
        
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    func setLeftNavBarButton(title: String)
    {
        let shadow = NSShadow()
        shadow.shadowColor = AppColors.textShadowColor
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        
        let leftButton = UIBarButtonItem(title:title, style:UIBarButtonItemStyle.done, target:nil, action:nil)
        
        leftButton.setTitleTextAttributes([NSForegroundColorAttributeName: AppColors.textWhiteColor, NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:Constants.fontName, size:21.0)!], for:UIControlState())
        
        self.navigationItem.leftBarButtonItem = leftButton
    }
}
