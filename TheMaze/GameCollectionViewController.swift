//
//  GameCollectionViewController.swift
//  TheMaze
//
//  Created by Thomas Mac on 10/07/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit
import AudioToolbox

private let reuseIdentifier = "Cell"

class GameCollectionViewController: UICollectionViewController {

    private var score = 0
    
    private var timer = NSTimer()
    
    internal var scoreTableViewController = ScoreTableViewController()
    
    private var indiceDepart = -1
    
    private var indiceArrivee = -1
    
    private let ulv = UpLineView()
    
    private var touchEnd = true
    
    private let label = UILabel()
    
    private var chrono = 2.0
    
    private var tempsRestant = 0.0
    
    private var objectifDone = false
    
    private var oldPosition = CGPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.backgroundColor = UIColor.whiteColor()
        
        self.title = "Score : " + String(self.score)
        
        self.navigationItem.setHidesBackButton(true, animated:true)
        
        let decalage = (self.navigationController?.navigationBar.frame.size.height)! + 20.0
        
        self.ulv.frame = CGRectMake(0, decalage, self.view.frame.size.width, self.view.frame.size.height - decalage)
        
        self.ulv.backgroundColor = UIColor.clearColor()
        
        self.view.addSubview(self.ulv)
        
        self.label.frame = CGRectMake(0, (self.navigationController?.navigationBar.frame.size.height)! + 20.0, self.view.frame.size.width, self.view.frame.size.height - (self.navigationController?.navigationBar.frame.size.height)! - 20.0)
        
        self.label.layer.borderColor = UIColor(red:213.0/255.0, green:210.0/255.0, blue:199.0/255.0, alpha:1.0).CGColor
        self.label.layer.borderWidth = 2.5
        self.label.layer.cornerRadius = 7.5
        self.label.layer.shadowOffset = CGSizeMake(0, 1)
        self.label.layer.shadowColor = UIColor.lightGrayColor().CGColor
        self.label.layer.shadowRadius = 8.0
        self.label.layer.shadowOpacity = 0.8
        self.label.layer.masksToBounds = false
        
        self.label.textAlignment = .Center
        self.label.backgroundColor = UIColor.whiteColor()
        self.label.font = UIFont(name:"HelveticaNeue-CondensedBlack", size:30.0)
        self.label.textColor = UIColor.blackColor()
        self.label.text = String(self.chrono)
        self.label.hidden = false
        
        self.view.addSubview(self.label)
        
        self.tempsRestant = self.getTempsImparti()
        
        self.setIndicatorTempsRestant()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(SpecificCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated:true)
        
        self.setLevel()
        
        super.viewDidAppear(animated)
    }
    
    private func setLevel()
    {
        //self.tempsRestant = self.getTempsImparti()
        //self.setIndicatorTempsRestant()
        
        let number = Int(sqrt(Double(self.getNumberOfItems())))
        
        self.indiceArrivee = Int(arc4random_uniform(UInt32(number)))
        
        let cellArrivee = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:self.indiceArrivee, inSection:0)) as! SpecificCollectionViewCell
        
        var cell = cellArrivee
        
        repeat
        {
            if (cell.allNeighbourCellAlreadySet(self.collectionView!))
            {
                self.resetCollectionView()
                self.setLevel()
                return
            }
            cell = cell.setCellInCollectionView(self.collectionView!)
        } while (cell.indice < number * number - number)
        self.indiceDepart = cell.indice
        cell.setAlreadySet()
        
        cell.backgroundColor = UIColor.greenColor()
        cellArrivee.backgroundColor = UIColor.redColor()
        
        let limit = self.collectionView?.numberOfItemsInSection(0)
        var i = 0
        while (i < limit)
        {
            let cell = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:i, inSection:0)) as! SpecificCollectionViewCell
            if (!cell.isAlreadySet())
            {
                cell.setCellInCollectionView(self.collectionView!)
            }
            i += 1
        }
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector:#selector(self.chronometre), userInfo:nil, repeats:true)
    }
    
    @objc private func chronometre()
    {
        self.chrono -= 0.1
        if (self.chrono > 0.9 && self.chrono < 1)
        {
            self.chrono = 0.9
        }
        self.label.text = String(self.chrono)
        
        if (self.chrono <= 0)
        {
            self.timer.invalidate()
            self.label.text = "0"
            self.label.hidden = true
            
            self.objectifDone = false
            self.touchEnd = false
            
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector:#selector(self.tempsImparti), userInfo:nil, repeats:true)
        }
    }
    
    @objc private func tempsImparti()
    {
        self.tempsRestant -= 0.1
        if (self.tempsRestant > 0.9 && self.tempsRestant < 1)
        {
            self.tempsRestant = 0.9
        }
        
        if (self.tempsRestant <= 0 && !self.objectifDone)
        {
            self.endOfGame()
        }
        self.setIndicatorTempsRestant()
    }
    
    private func resetCollectionView()
    {
        self.collectionView?.reloadData()
        
        self.collectionView?.layoutIfNeeded()
        
        let limit = self.collectionView?.numberOfItemsInSection(0)
        var i = 0
        while (i < limit)
        {
            (self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:i, inSection:0)) as! SpecificCollectionViewCell).reset()
            i += 1
        }
        self.indiceDepart = -1
        self.indiceArrivee = -1
        self.ulv.line.removeAllPoints()
    }
    
    private func objectifAtteint()
    {
        self.objectifDone = true
        self.touchEnd = true
        self.timer.invalidate()
        
        self.chrono = 2
        self.label.hidden = false
        self.label.text = String(self.chrono)
        
        self.score += 1
        self.title = "Score : " + String(self.score)
        
        self.tempsRestant += 1.0
        self.tempsRestant = Double(round(10 * self.tempsRestant) / 10)
        self.setIndicatorTempsRestant()
        
        self.resetCollectionView()
        self.setLevel()
    }
    
    private func endOfGame()
    {
        self.touchEnd = true
        self.timer.invalidate()
        
        let alertController = UIAlertController(title:"Fin de la partie", message:"La partie est finie, vous avez marqué " + String(self.score) + " point(s).", preferredStyle:.Alert)
        
        let alertAction = UIAlertAction(title:"OK", style:.Default) { (_) in
            if (self.score > 0)
            {
                self.scoreTableViewController.gameFinish(self.score)
            }
            self.navigationController?.popViewControllerAnimated(true)
        }
        alertController.addAction(alertAction)
        
        if (!self.objectifDone)
        {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            presentViewController(alertController, animated:true, completion:nil)
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (self.touchEnd || self.objectifDone)
        {
            return
        }
        
        let touch = touches.first
        let currentPos = touch?.locationInView(self.ulv)
        self.oldPosition = currentPos!
        
        if (!self.pointIsInCell(currentPos!, cell:self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:self.indiceDepart, inSection:0)) as! SpecificCollectionViewCell))
        {
            self.endOfGame()
        }
        self.ulv.line.moveToPoint(currentPos!)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (self.touchEnd || self.objectifDone)
        {
            return
        }
        let touch = touches.first
        let currentPos = touch?.locationInView(self.ulv)
        
        if (self.isBorderCross(self.oldPosition, pointTwo:currentPos!))
        {
            self.endOfGame()
            return
        }
        self.oldPosition = currentPos!
        
        /*if (self.pointIsInWrongCell(currentPos!) && !self.objectifDone)
        {
            self.endOfGame()
            return
        }*/
        if (self.pointIsInCell(currentPos!, cell:self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:self.indiceArrivee, inSection:0)) as! SpecificCollectionViewCell))
        {
            self.objectifAtteint()
        }
        self.ulv.line.addLineToPoint(currentPos!)
        self.ulv.setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (!self.objectifDone)
        {
            self.touchEnd = true
        }
    }
    
    private func pointIsInWrongCell(point: CGPoint) -> Bool
    {
        let limit = self.getNumberOfItems()
        var i = 0
        while (i < limit)
        {
            let cell = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:i, inSection:0)) as! SpecificCollectionViewCell
            
            if (!cell.isAlreadySet() && self.pointIsInCell(point, cell:cell))
            {
                return true
            }
            i += 1
        }
        return false
    }
    
    private func pointIsInCell(point: CGPoint, cell: SpecificCollectionViewCell) -> Bool
    {
        return (point.x >= cell.frame.origin.x && point.x <= cell.frame.origin.x + cell.frame.size.width && point.y >= cell.frame.origin.y && point.y <= cell.frame.origin.y + cell.frame.size.height)
    }
    
    private func isBorderCross(pointOne: CGPoint, pointTwo: CGPoint) -> Bool
    {
        let number = Int(sqrt(Double(self.getNumberOfItems())))
        
        let cellOne = self.getCellContainsPoint(pointOne)
        let cellTwo = self.getCellContainsPoint(pointTwo)
        
        if (cellTwo.indice == cellOne.indice - 1 && !cellOne.borderLeftIsHidden() && !cellTwo.borderRightIsHidden())
        {
            // cell2 à gauche
            return true
        }
        else if (cellTwo.indice == cellOne.indice + 1 && !cellOne.borderRightIsHidden() && !cellTwo.borderLeftIsHidden())
        {
            // cell2 à Droite
            return true
        }
        else if (cellTwo.indice == cellOne.indice - number && !cellOne.borderUpIsHidden() && !cellTwo.borderDownIsHidden())
        {
            // cell2 en haut
            return true
        }
        else if (cellTwo.indice == cellOne.indice + number && !cellOne.borderDownIsHidden() && !cellTwo.borderUpIsHidden())
        {
            // cell2 en bas
            return true
        }
        return false
    }
    
    private func getCellContainsPoint(point: CGPoint) -> SpecificCollectionViewCell
    {
        let limit = self.getNumberOfItems()
        var i = 1
        while (i < limit)
        {
            if (self.pointIsInCell(point, cell:self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:i, inSection:0)) as! SpecificCollectionViewCell))
            {
                return self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow:i, inSection:0)) as! SpecificCollectionViewCell
            }
            i += 1
        }
        return SpecificCollectionViewCell()
    }
    
    private func getNumberOfItems() -> Int
    {
        var number = 3
        var i = 0
        while (self.score >= (i + 1) * 5)
        {
            i += 1
        }
        number += i
        
        while (self.view.frame.size.width / CGFloat(number) < 40.0)
        {
            number -= 1
        }
        return number * number
    }
    
    private func getTempsImparti() -> Double
    {
        return 5
    }
    
    private func setIndicatorTempsRestant()
    {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.8)
        shadow.shadowOffset = CGSizeMake(0, 1)
        
        var title = "    Temps restant : " + String(self.tempsRestant) + "s"
        if (self.tempsRestant <= 0)
        {
            title = "    Temps restant : 0s"
        }
        
        let rightButton = UIBarButtonItem(title:title, style:UIBarButtonItemStyle.Done, target:nil, action:nil)
        rightButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:245.0/255.0, green:245.0/255.0, blue:245.0/255.0, alpha:1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!], forState:UIControlState.Normal)
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.getNumberOfItems()
    }
    
    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
    {
        return CGSizeMake(self.view.frame.size.width / CGFloat(sqrt(Double(self.getNumberOfItems()))), (self.view.frame.size.height - (self.navigationController?.navigationBar.frame.size.height)! - 20.0) / CGFloat(sqrt(Double(self.getNumberOfItems()))))
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SpecificCollectionViewCell
    
        cell.backgroundColor = UIColor.whiteColor()
        
        cell.indice = indexPath.row
        
        return cell
    }
    
}
