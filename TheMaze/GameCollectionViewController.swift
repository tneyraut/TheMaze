//
//  GameCollectionViewController.swift
//  TheMaze
//
//  Created by Thomas Mac on 10/07/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit
import AudioToolbox
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


private let reuseIdentifier = "Cell"

class GameCollectionViewController: UICollectionViewController {

    fileprivate var score = 0
    
    fileprivate var timer = Timer()
    
    internal var scoreTableViewController = ScoreViewController()
    
    fileprivate var indiceDepart = -1
    
    fileprivate var indiceArrivee = -1
    
    fileprivate let ulv = UpLineView()
    
    fileprivate var touchEnd = true
    
    fileprivate let label = UILabel()
    
    fileprivate var chrono = 2.0
    
    fileprivate var tempsRestant = 0.0
    
    fileprivate var objectifDone = false
    
    fileprivate var oldPosition = CGPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.backgroundColor = UIColor.white
        
        self.title = "Score : " + String(self.score)
        
        self.navigationItem.setHidesBackButton(true, animated:true)
        
        let decalage = (self.navigationController?.navigationBar.frame.size.height)! + 20.0
        
        self.ulv.frame = CGRect(x: 0, y: decalage, width: self.view.frame.size.width, height: self.view.frame.size.height - decalage)
        
        self.ulv.backgroundColor = UIColor.clear
        
        self.view.addSubview(self.ulv)
        
        self.label.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.size.height)! + 20.0, width: self.view.frame.size.width, height: self.view.frame.size.height - (self.navigationController?.navigationBar.frame.size.height)! - 20.0)
        
        self.label.layer.borderColor = UIColor(red:213.0/255.0, green:210.0/255.0, blue:199.0/255.0, alpha:1.0).cgColor
        self.label.layer.borderWidth = 2.5
        self.label.layer.cornerRadius = 7.5
        self.label.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.label.layer.shadowColor = UIColor.lightGray.cgColor
        self.label.layer.shadowRadius = 8.0
        self.label.layer.shadowOpacity = 0.8
        self.label.layer.masksToBounds = false
        
        self.label.textAlignment = .center
        self.label.backgroundColor = UIColor.white
        self.label.font = UIFont(name:"HelveticaNeue-CondensedBlack", size:30.0)
        self.label.textColor = UIColor.black
        self.label.text = String(self.chrono)
        self.label.isHidden = false
        
        self.view.addSubview(self.label)
        
        self.tempsRestant = self.getTempsImparti()
        
        self.setIndicatorTempsRestant()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(SpecificCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated:true)
        
        self.setLevel()
        
        super.viewDidAppear(animated)
    }
    
    fileprivate func setLevel()
    {
        //self.tempsRestant = self.getTempsImparti()
        //self.setIndicatorTempsRestant()
        
        let number = Int(sqrt(Double(self.getNumberOfItems())))
        
        self.indiceArrivee = Int(arc4random_uniform(UInt32(number)))
        
        let cellArrivee = self.collectionView?.cellForItem(at: IndexPath(row:self.indiceArrivee, section:0)) as! SpecificCollectionViewCell
        
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
        
        cell.backgroundColor = UIColor.green
        cellArrivee.backgroundColor = UIColor.red
        
        let limit = self.collectionView?.numberOfItems(inSection: 0)
        var i = 0
        while (i < limit)
        {
            let cell = self.collectionView?.cellForItem(at: IndexPath(row:i, section:0)) as! SpecificCollectionViewCell
            if (!cell.isAlreadySet())
            {
                cell.setCellInCollectionView(self.collectionView!)
            }
            i += 1
        }
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.chronometre), userInfo:nil, repeats:true)
    }
    
    @objc fileprivate func chronometre()
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
            self.label.isHidden = true
            
            self.objectifDone = false
            self.touchEnd = false
            
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.tempsImparti), userInfo:nil, repeats:true)
        }
    }
    
    @objc fileprivate func tempsImparti()
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
    
    fileprivate func resetCollectionView()
    {
        self.collectionView?.reloadData()
        
        self.collectionView?.layoutIfNeeded()
        
        let limit = self.collectionView?.numberOfItems(inSection: 0)
        var i = 0
        while (i < limit)
        {
            (self.collectionView?.cellForItem(at: IndexPath(row:i, section:0)) as! SpecificCollectionViewCell).reset()
            i += 1
        }
        self.indiceDepart = -1
        self.indiceArrivee = -1
        self.ulv.line.removeAllPoints()
    }
    
    fileprivate func objectifAtteint()
    {
        self.objectifDone = true
        self.touchEnd = true
        self.timer.invalidate()
        
        self.chrono = 2
        self.label.isHidden = false
        self.label.text = String(self.chrono)
        
        self.score += 1
        self.title = "Score : " + String(self.score)
        
        self.tempsRestant += 1.0
        self.tempsRestant = Double(round(10 * self.tempsRestant) / 10)
        self.setIndicatorTempsRestant()
        
        self.resetCollectionView()
        self.setLevel()
    }
    
    fileprivate func endOfGame()
    {
        self.touchEnd = true
        self.timer.invalidate()
        
        let alertController = UIAlertController(title:"Fin de la partie", message:"La partie est finie, vous avez marqué " + String(self.score) + " point(s).", preferredStyle:.alert)
        
        let alertAction = UIAlertAction(title:"OK", style:.default) { (_) in
            if (self.score > 0)
            {
                self.scoreTableViewController.gameFinish(self.score)
            }
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(alertAction)
        
        if (!self.objectifDone)
        {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            present(alertController, animated:true, completion:nil)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.touchEnd || self.objectifDone)
        {
            return
        }
        
        let touch = touches.first
        let currentPos = touch?.location(in: self.ulv)
        self.oldPosition = currentPos!
        
        if (!self.pointIsInCell(currentPos!, cell:self.collectionView?.cellForItem(at: IndexPath(row:self.indiceDepart, section:0)) as! SpecificCollectionViewCell))
        {
            self.endOfGame()
        }
        self.ulv.line.move(to: currentPos!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.touchEnd || self.objectifDone)
        {
            return
        }
        let touch = touches.first
        let currentPos = touch?.location(in: self.ulv)
        
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
        if (self.pointIsInCell(currentPos!, cell:self.collectionView?.cellForItem(at: IndexPath(row:self.indiceArrivee, section:0)) as! SpecificCollectionViewCell))
        {
            self.objectifAtteint()
        }
        self.ulv.line.addLine(to: currentPos!)
        self.ulv.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!self.objectifDone)
        {
            self.touchEnd = true
        }
    }
    
    fileprivate func pointIsInWrongCell(_ point: CGPoint) -> Bool
    {
        let limit = self.getNumberOfItems()
        var i = 0
        while (i < limit)
        {
            let cell = self.collectionView?.cellForItem(at: IndexPath(row:i, section:0)) as! SpecificCollectionViewCell
            
            if (!cell.isAlreadySet() && self.pointIsInCell(point, cell:cell))
            {
                return true
            }
            i += 1
        }
        return false
    }
    
    fileprivate func pointIsInCell(_ point: CGPoint, cell: SpecificCollectionViewCell) -> Bool
    {
        return (point.x >= cell.frame.origin.x && point.x <= cell.frame.origin.x + cell.frame.size.width && point.y >= cell.frame.origin.y && point.y <= cell.frame.origin.y + cell.frame.size.height)
    }
    
    fileprivate func isBorderCross(_ pointOne: CGPoint, pointTwo: CGPoint) -> Bool
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
    
    fileprivate func getCellContainsPoint(_ point: CGPoint) -> SpecificCollectionViewCell
    {
        let limit = self.getNumberOfItems()
        var i = 1
        while (i < limit)
        {
            if (self.pointIsInCell(point, cell:self.collectionView?.cellForItem(at: IndexPath(row:i, section:0)) as! SpecificCollectionViewCell))
            {
                return self.collectionView?.cellForItem(at: IndexPath(row:i, section:0)) as! SpecificCollectionViewCell
            }
            i += 1
        }
        return SpecificCollectionViewCell()
    }
    
    fileprivate func getNumberOfItems() -> Int
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
    
    fileprivate func getTempsImparti() -> Double
    {
        return 5
    }
    
    fileprivate func setIndicatorTempsRestant()
    {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.8)
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        
        var title = "    Temps restant : " + String(self.tempsRestant) + "s"
        if (self.tempsRestant <= 0)
        {
            title = "    Temps restant : 0s"
        }
        
        let rightButton = UIBarButtonItem(title:title, style:UIBarButtonItemStyle.done, target:nil, action:nil)
        rightButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:245.0/255.0, green:245.0/255.0, blue:245.0/255.0, alpha:1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!], for:UIControlState())
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.getNumberOfItems()
    }
    
    func collectionView(_ collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:IndexPath) -> CGSize
    {
        return CGSize(width: self.view.frame.size.width / CGFloat(sqrt(Double(self.getNumberOfItems()))), height: (self.view.frame.size.height - (self.navigationController?.navigationBar.frame.size.height)! - 20.0) / CGFloat(sqrt(Double(self.getNumberOfItems()))))
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SpecificCollectionViewCell
    
        cell.backgroundColor = UIColor.white
        
        cell.indice = indexPath.row
        
        return cell
    }
    
}
