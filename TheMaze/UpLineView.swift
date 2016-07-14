//
//  UpLineView.swift
//  DrawTheForm
//
//  Created by Thomas Mac on 10/07/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

class UpLineView: UIView {
    
    internal let line = UIBezierPath()
    
    override func drawRect(rect: CGRect) {
        
        self.backgroundColor = UIColor.clearColor()
        
        UIColor.blackColor().setStroke()
        UIColor.blackColor().setFill()
        self.line.stroke()
        self.line.lineWidth = 3.0
        
        // Mask to Path
        /*let shapeLayer = CAShapeLayer()
        shapeLayer.path = line.CGPath
        self.layer.mask = shapeLayer*/
    }

}
