//
//  ViewController.swift
//  TheMaze
//
//  Created by Thomas Mac on 10/07/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let ulv = UpLineView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ulv.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.addSubview(self.ulv)
        
        self.ulv.backgroundColor = UIColor.clearColor()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

