//
//  CollectionViewCellWithLabel.swift
//  BrainFuck
//
//  Created by Thomas Mac on 16/06/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

class SpecificCollectionViewCell: UICollectionViewCell {
    
    private var alreadySet = false
    
    internal var indice = -1
    
    private var ouverture = ""
    
    private let borderRight = UIImageView()
    
    private let borderLeft = UIImageView()
    
    private let borderUp = UIImageView()
    
    private let borderDown = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = UIColor.clearColor()
        
        let size = CGFloat(5.0)
        let decalage = CGFloat(0)
        
        self.borderRight.frame = CGRectMake(self.frame.size.width, -decalage, size, self.frame.size.height + 2 * decalage)
        self.borderRight.image = UIImage(named:NSLocalizedString("BORDER_RIGHT_OR_LEFT", comment:""))
        self.borderRight.hidden = false
        
        self.borderLeft.frame = CGRectMake(0, -decalage, size, self.frame.size.height + 2 * decalage)
        self.borderLeft.image = UIImage(named:NSLocalizedString("BORDER_RIGHT_OR_LEFT", comment:""))
        self.borderLeft.hidden = false
        
        self.borderUp.frame = CGRectMake(-decalage, 0, self.frame.size.width + decalage, size)
        self.borderUp.image = UIImage(named:NSLocalizedString("BORDER_UP_OR_DOWN", comment:""))
        self.borderUp.hidden = false
        
        self.borderDown.frame = CGRectMake(-decalage, self.frame.size.height, self.frame.size.width + decalage, size)
        self.borderDown.image = UIImage(named:NSLocalizedString("BORDER_UP_OR_DOWN", comment:""))
        self.borderDown.hidden = false
        
        self.addSubview(self.borderRight)
        self.addSubview(self.borderLeft)
        self.addSubview(self.borderUp)
        self.addSubview(self.borderDown)
        
        /*self.layer.borderColor = UIColor(red:213.0/255.0, green:210.0/255.0, blue:199.0/255.0, alpha:1.0).CGColor
        
        self.layer.borderWidth = 2.5
        self.layer.cornerRadius = 7.5
        //self.layer.shadowOffset = CGSizeMake(0, 1)
        //self.layer.shadowColor = UIColor.lightGrayColor().CGColor
        //self.layer.shadowRadius = 8.0
        //self.layer.shadowOpacity = 0.8
        self.layer.masksToBounds = false*/
    }
    
    internal func setAlreadySet()
    {
        self.alreadySet = true
    }
    
    internal func isAlreadySet() -> Bool
    {
        return self.alreadySet
    }
    
    internal func setCellInCollectionView(collectionView: UICollectionView) -> SpecificCollectionViewCell
    {
        self.setAlreadySet()
        
        var cell = self.getRandomNeighbourCellInCollectionView(collectionView)
        
        if (self.allNeighbourCellAlreadySet(collectionView))
        {
            cell = self.getRandomNeighbourCellInCollectionView(collectionView)
        }
        else
        {
            while (cell.isAlreadySet())
            {
                cell = self.getRandomNeighbourCellInCollectionView(collectionView)
            }
        }
        if (self.ouverture == "gauche")
        {
            self.borderLeft.hidden = true
            cell.borderRight.hidden = true
        }
        else if (self.ouverture == "droite")
        {
            self.borderRight.hidden = true
            cell.borderLeft.hidden = true
        }
        else if (self.ouverture == "haut")
        {
            self.borderUp.hidden = true
            cell.borderDown.hidden = true
        }
        else if (self.ouverture == "bas")
        {
            self.borderDown.hidden = true
            cell.borderUp.hidden = true
        }
        return cell
    }
    
    private func getRandomNeighbourCellInCollectionView(collectionView: UICollectionView) -> SpecificCollectionViewCell
    {
        let number = Int(sqrt(Double(collectionView.numberOfItemsInSection(0))))
        while (true)
        {
            let random = arc4random_uniform(4)
            if (random == 0 && self.indice % number != 0)
            {
                self.ouverture = "gauche"
                return collectionView.cellForItemAtIndexPath(NSIndexPath(forRow:self.indice - 1, inSection:0)) as! SpecificCollectionViewCell
            }
            else if (random == 1 && (self.indice + 1) % number != 0)
            {
                self.ouverture = "droite"
                return collectionView.cellForItemAtIndexPath(NSIndexPath(forRow:self.indice + 1, inSection:0)) as! SpecificCollectionViewCell
            }
            else if (random == 2 && self.indice - number >= 0)
            {
                self.ouverture = "haut"
                return collectionView.cellForItemAtIndexPath(NSIndexPath(forRow:self.indice - number, inSection:0)) as! SpecificCollectionViewCell
            }
            else if (random == 3 && self.indice + number < number * number)
            {
                self.ouverture = "bas"
                return collectionView.cellForItemAtIndexPath(NSIndexPath(forRow:self.indice + number, inSection:0)) as! SpecificCollectionViewCell
            }
        }
    }
    
    internal func allNeighbourCellAlreadySet(collectionView: UICollectionView) -> Bool
    {
        let number = Int(sqrt(Double(collectionView.numberOfItemsInSection(0))))
        if (self.indice % number != 0 && !(collectionView.cellForItemAtIndexPath(NSIndexPath(forRow:self.indice - 1, inSection:0)) as! SpecificCollectionViewCell).isAlreadySet())
        {
            return false
        }
        else if ((self.indice + 1) % number != 0 && !(collectionView.cellForItemAtIndexPath(NSIndexPath(forRow:self.indice + 1, inSection:0)) as! SpecificCollectionViewCell).isAlreadySet())
        {
            return false
        }
        else if (self.indice - number >= 0 && !(collectionView.cellForItemAtIndexPath(NSIndexPath(forRow:self.indice - number, inSection:0)) as! SpecificCollectionViewCell).isAlreadySet())
        {
            return false
        }
        else if (self.indice + number < number * number && !(collectionView.cellForItemAtIndexPath(NSIndexPath(forRow:self.indice + number, inSection:0)) as! SpecificCollectionViewCell).isAlreadySet())
        {
            return false
        }
        return true
    }
    
    internal func reset()
    {
        self.backgroundColor = UIColor.clearColor()
        self.borderDown.hidden = false
        self.borderUp.hidden = false
        self.borderRight.hidden = false
        self.borderLeft.hidden = false
        self.alreadySet = false
        self.ouverture = ""
    }
    
    internal func borderLeftIsHidden() -> Bool
    {
        return self.borderLeft.hidden
    }
    
    internal func borderRightIsHidden() -> Bool
    {
        return self.borderRight.hidden
    }
    
    internal func borderUpIsHidden() -> Bool
    {
        return self.borderUp.hidden
    }
    
    internal func borderDownIsHidden() -> Bool
    {
        return self.borderDown.hidden
    }
    
}
