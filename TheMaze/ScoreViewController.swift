//
//  ScoreTableViewController.swift
//  TheMaze
//
//  Created by Thomas Mac on 10/07/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

class ScoreViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var tableView : UITableView!
    
    fileprivate let userDefaults = UserDefaults()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.title = NSLocalizedString("SCORE_VIEW_TITLE", comment: "")
        
        NotificationCenter.default.addObserver(self, selector: #selector(gameOver), name: Notification.Name.init(Constants.gameOverMessage), object: nil)
    }

    override func viewDidAppear(_ animated: Bool)
    {
        self.navigationController?.setToolbarHidden(false, animated:true)
        
        addCenterButtonInToolBar(
            title: NSLocalizedString("SCORE_VIEW_PLAY", comment: ""),
            target: self,
            selector: #selector(self.playCommand))
        
        super.viewDidAppear(animated)
    }
    
    @objc fileprivate func playCommand()
    {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let gameCollectionViewController = GameCollectionViewController(collectionViewLayout:layout)
        
        self.navigationController?.pushViewController(gameCollectionViewController, animated:true)
    }
    
    fileprivate func getNumberOfItems() -> Int
    {
        return self.userDefaults.integer(forKey: Constants.numberOfScoresCacheKey)
    }
    
    internal func gameOver(notification: NSNotification)
    {
        let score = notification.object as! Int
        
        if score == 0
        {
            return
        }
        if self.userDefaults.integer(forKey: Constants.numberOfScoresCacheKey) < Constants.limitNbScores
        {
            self.userDefaults.set(self.userDefaults.integer(forKey: Constants.numberOfScoresCacheKey) + 1, forKey: Constants.numberOfScoresCacheKey)
        }
        if self.getNumberOfItems() == 1
        {
            self.userDefaults.set(score, forKey:"\(Constants.scoreCacheKey)0")
        }
        else
        {
            var i = 0
            while i < self.getNumberOfItems() && i < Constants.limitNbScores
            {
                if self.userDefaults.integer(forKey: "\(Constants.scoreCacheKey)\(i)") < score
                {
                    self.userDefaults.set(self.userDefaults.integer(forKey: "\(Constants.scoreCacheKey)\(self.getNumberOfItems() - 2)"), forKey: "\(Constants.scoreCacheKey)\(self.getNumberOfItems() - 1)")
                    
                    var j = self.getNumberOfItems() - 2
                    while j > i
                    {
                        self.userDefaults.set(self.userDefaults.integer(forKey: "\(Constants.scoreCacheKey)\(j - 1)"), forKey: "\(Constants.scoreCacheKey)\(j)")
                        
                        j -= 1
                    }
                    
                    self.userDefaults.set(score, forKey: "\(Constants.scoreCacheKey)\(i)")
                    break
                }
                i += 1
            }
            
            i = Constants.limitNbScores
            while i < self.getNumberOfItems()
            {
                self.userDefaults.removeObject(forKey: "\(Constants.scoreCacheKey)\(i)")
            }
        }
        
        self.userDefaults.synchronize()
        
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let nbItems = self.getNumberOfItems()
        
        if (nbItems == 0)
        {
            return 1
        }
        return nbItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if self.getNumberOfItems() == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.roundedCellId, for: indexPath) as! RoundedTableViewCell
            
            cell.titleLabel.text = NSLocalizedString("SCORE_VIEW_NO_SCORE", comment: "")
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.imageTextCellId, for: indexPath) as! ImageTextTableViewCell

        let score = self.userDefaults.integer(forKey: "\(Constants.scoreCacheKey)\(indexPath.row)")
        
        cell.titleLabel.text = "\(NSLocalizedString("SCORE_VIEW_SCORE_NUMBER", comment: ""))\(indexPath.row + 1) : \(score) \(score > 1 ? NSLocalizedString("SCORE_VIEW_POINTS", comment: "") : NSLocalizedString("SCORE_VIEW_POINT", comment: ""))"
        
        cell.iconView.image = UIImage(named:NSLocalizedString("ICON_SCORE", comment:""))

        return cell
    }
}
