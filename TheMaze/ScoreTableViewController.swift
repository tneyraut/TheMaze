//
//  ScoreTableViewController.swift
//  TheMaze
//
//  Created by Thomas Mac on 10/07/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

class ScoreTableViewController: UITableViewController {

    private let sauvegarde = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier:"cell1")
        self.tableView.registerClass(TableViewCellWithImage.classForCoder(), forCellReuseIdentifier:"cell")
        
        self.title = "The Maze : Menu Principal"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated:true)
        
        self.navigationController?.toolbar.barTintColor = UIColor(red:0.439, green:0.776, blue:0.737, alpha:1)
        
        let shadow = NSShadow()
        
        shadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.8)
        
        shadow.shadowOffset = CGSizeMake(0, 1)
        
        let buttonPlay = UIBarButtonItem(title:"Play", style:.Plain, target:self, action:#selector(self.buttonPlayActionListener))
        
        buttonPlay.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:245.0/255.0, green:245.0/255.0, blue:245.0/255.0, alpha:1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!], forState:UIControlState.Normal)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target:nil, action:nil)
        
        self.navigationController?.toolbar.setItems([flexibleSpace, buttonPlay, flexibleSpace], animated:true)
        
        super.viewDidAppear(animated)
    }
    
    @objc private func buttonPlayActionListener()
    {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let gameCollectionViewController = GameCollectionViewController(collectionViewLayout:layout)
        
        gameCollectionViewController.scoreTableViewController = self
        
        self.navigationController?.pushViewController(gameCollectionViewController, animated:true)
    }
    
    private func getNumberOfItems() -> Int
    {
        return self.sauvegarde.integerForKey("NumberOfScores")
    }
    
    internal func gameFinish(score: Int)
    {
        if (score == 0)
        {
            return
        }
        self.sauvegarde.setInteger(self.sauvegarde.integerForKey("NumberOfScores") + 1, forKey:"NumberOfScores")
        if (self.getNumberOfItems() == 1)
        {
            self.sauvegarde.setInteger(score, forKey:"Score0")
        }
        else
        {
            var i = 0
            while (i < self.getNumberOfItems() && i < 10)
            {
                if (self.sauvegarde.integerForKey("Score" + String(i)) < score)
                {
                    self.sauvegarde.setInteger(self.sauvegarde.integerForKey("Score" + String(self.getNumberOfItems() - 2)), forKey:"Score" + String(self.getNumberOfItems() - 1))
                    var j = self.getNumberOfItems() - 2
                    while (j > i)
                    {
                        self.sauvegarde.setInteger(self.sauvegarde.integerForKey("Score" + String(j - 1)), forKey:"Score" + String(j))
                        j -= 1
                    }
                    self.sauvegarde.setInteger(score, forKey:"Score" + String(i))
                    break
                }
                i += 1
            }
            i = 10
            while (i < self.getNumberOfItems())
            {
                self.sauvegarde.removeObjectForKey("Score" + String(i))
            }
        }
        self.sauvegarde.synchronize()
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (self.getNumberOfItems() == 0)
        {
            return 1
        }
        return self.getNumberOfItems()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75.0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (self.getNumberOfItems() == 0)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath)
            
            cell.selectionStyle = .None
            
            cell.textLabel?.textAlignment = .Center
            
            cell.textLabel?.text = "Aucun score enregistré"
            
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text = "Score N°" + String(indexPath.row + 1) + " : " + String(self.sauvegarde.integerForKey("Score" + String(indexPath.row))) + " point(s)"
        
        cell.imageView?.image = UIImage(named:NSLocalizedString("ICON_SCORE", comment:""))
        
        cell.selectionStyle = .None

        return cell
    }
 
}
