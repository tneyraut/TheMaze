//
//  CollectionViewCellWithLabel.swift
//  BrainFuck
//
//  Created by Thomas Mac on 16/06/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

class SpecificCollectionViewCell: UICollectionViewCell {
    
    fileprivate var alreadySet = false
    
    internal var indice = -1
    
    fileprivate var ouverture = ""
    
    fileprivate let borderRight = UIImageView()
    
    fileprivate let borderLeft = UIImageView()
    
    fileprivate let borderUp = UIImageView()
    
    fileprivate let borderDown = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = UIColor.clear
        
        let size = CGFloat(5.0)
        let decalage = CGFloat(0)
        
        self.borderRight.frame = CGRect(x: self.frame.size.width, y: -decalage, width: size, height: self.frame.size.height + 2 * decalage)
        self.borderRight.image = UIImage(named:NSLocalizedString("BORDER_RIGHT_OR_LEFT", comment:""))
        self.borderRight.isHidden = false
        
        self.borderLeft.frame = CGRect(x: 0, y: -decalage, width: size, height: self.frame.size.height + 2 * decalage)
        self.borderLeft.image = UIImage(named:NSLocalizedString("BORDER_RIGHT_OR_LEFT", comment:""))
        self.borderLeft.isHidden = false
        
        self.borderUp.frame = CGRect(x: -decalage, y: 0, width: self.frame.size.width + decalage, height: size)
        self.borderUp.image = UIImage(named:NSLocalizedString("BORDER_UP_OR_DOWN", comment:""))
        self.borderUp.isHidden = false
        
        self.borderDown.frame = CGRect(x: -decalage, y: self.frame.size.height, width: self.frame.size.width + decalage, height: size)
        self.borderDown.image = UIImage(named:NSLocalizedString("BORDER_UP_OR_DOWN", comment:""))
        self.borderDown.isHidden = false
        
        self.addSubview(self.borderRight)
        self.addSubview(self.borderLeft)
        self.addSubview(self.borderUp)
        self.addSubview(self.borderDown)
    }
    
    internal func setAlreadySet()
    {
        self.alreadySet = true
    }
    
    internal func isAlreadySet() -> Bool
    {
        return self.alreadySet
    }
    
    internal func setCellInCollectionView(_ collectionView: UICollectionView) -> SpecificCollectionViewCell
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
            self.borderLeft.isHidden = true
            cell.borderRight.isHidden = true
        }
        else if (self.ouverture == "droite")
        {
            self.borderRight.isHidden = true
            cell.borderLeft.isHidden = true
        }
        else if (self.ouverture == "haut")
        {
            self.borderUp.isHidden = true
            cell.borderDown.isHidden = true
        }
        else if (self.ouverture == "bas")
        {
            self.borderDown.isHidden = true
            cell.borderUp.isHidden = true
        }
        return cell
    }
    
    fileprivate func getRandomNeighbourCellInCollectionView(_ collectionView: UICollectionView) -> SpecificCollectionViewCell
    {
        let number = Int(sqrt(Double(collectionView.numberOfItems(inSection: 0))))
        while (true)
        {
            let random = arc4random_uniform(4)
            if (random == 0 && self.indice % number != 0)
            {
                self.ouverture = "gauche"
                return collectionView.cellForItem(at: IndexPath(row:self.indice - 1, section:0)) as! SpecificCollectionViewCell
            }
            else if (random == 1 && (self.indice + 1) % number != 0)
            {
                self.ouverture = "droite"
                return collectionView.cellForItem(at: IndexPath(row:self.indice + 1, section:0)) as! SpecificCollectionViewCell
            }
            else if (random == 2 && self.indice - number >= 0)
            {
                self.ouverture = "haut"
                return collectionView.cellForItem(at: IndexPath(row:self.indice - number, section:0)) as! SpecificCollectionViewCell
            }
            else if (random == 3 && self.indice + number < number * number)
            {
                self.ouverture = "bas"
                return collectionView.cellForItem(at: IndexPath(row:self.indice + number, section:0)) as! SpecificCollectionViewCell
            }
        }
    }
    
    internal func allNeighbourCellAlreadySet(_ collectionView: UICollectionView) -> Bool
    {
        let number = Int(sqrt(Double(collectionView.numberOfItems(inSection: 0))))
        if (self.indice % number != 0 && !(collectionView.cellForItem(at: IndexPath(row:self.indice - 1, section:0)) as! SpecificCollectionViewCell).isAlreadySet())
        {
            return false
        }
        else if ((self.indice + 1) % number != 0 && !(collectionView.cellForItem(at: IndexPath(row:self.indice + 1, section:0)) as! SpecificCollectionViewCell).isAlreadySet())
        {
            return false
        }
        else if (self.indice - number >= 0 && !(collectionView.cellForItem(at: IndexPath(row:self.indice - number, section:0)) as! SpecificCollectionViewCell).isAlreadySet())
        {
            return false
        }
        else if (self.indice + number < number * number && !(collectionView.cellForItem(at: IndexPath(row:self.indice + number, section:0)) as! SpecificCollectionViewCell).isAlreadySet())
        {
            return false
        }
        return true
    }
    
    internal func reset()
    {
        self.backgroundColor = UIColor.clear
        self.borderDown.isHidden = false
        self.borderUp.isHidden = false
        self.borderRight.isHidden = false
        self.borderLeft.isHidden = false
        self.alreadySet = false
        self.ouverture = ""
    }
    
    internal func borderLeftIsHidden() -> Bool
    {
        return self.borderLeft.isHidden
    }
    
    internal func borderRightIsHidden() -> Bool
    {
        return self.borderRight.isHidden
    }
    
    internal func borderUpIsHidden() -> Bool
    {
        return self.borderUp.isHidden
    }
    
    internal func borderDownIsHidden() -> Bool
    {
        return self.borderDown.isHidden
    }
    
}
