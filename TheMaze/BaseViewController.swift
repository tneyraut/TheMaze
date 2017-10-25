//
//  BaseViewController.swift
//  TheMaze
//
//  Created by Thomas Mac on 24/10/2017.
//  Copyright © 2017 ThomasNeyraut. All rights reserved.
//

import UIKit

class BaseViewController : UIViewController
{
    func addCenterButtonInToolBar(title: String, target: Any?, selector: Selector?)
    {
        let shadow = NSShadow()
        
        shadow.shadowColor = AppColors.textShadowColor
        
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        
        let button = UIBarButtonItem(title: title, style: .plain, target:target, action: selector)
        
        button.setTitleTextAttributes([NSForegroundColorAttributeName: AppColors.textWhiteColor, NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:Constants.fontName, size:21.0)!], for:UIControlState())
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target:nil, action:nil)
        
        self.navigationController?.toolbar.setItems([flexibleSpace, button, flexibleSpace], animated:true)
    }
}
