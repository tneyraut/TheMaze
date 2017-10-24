//
//  UpLineView.swift
//  DrawTheForm
//
//  Created by Thomas Mac on 10/07/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

class UpLineView: UIView
{
    internal let line = UIBezierPath()
    
    override func draw(_ rect: CGRect)
    {
        self.backgroundColor = UIColor.clear
        
        UIColor.black.setStroke()
        UIColor.black.setFill()
        
        self.line.stroke()
        self.line.lineWidth = 3.0
    }
}
