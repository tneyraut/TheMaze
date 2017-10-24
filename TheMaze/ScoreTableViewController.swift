//
//  ScoreTableViewController.swift
//  TheMaze
//
//  Created by Thomas Mac on 10/07/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

class ScoreTableViewController: UITableViewController {

    fileprivate let sauvegarde = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier:"cell1")
        self.tableView.register(TableViewCellWithImage.classForCoder(), forCellReuseIdentifier:"cell")
        
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

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated:true)
        
        self.navigationController?.toolbar.barTintColor = UIColor(red:0.439, green:0.776, blue:0.737, alpha:1)
        
        let shadow = NSShadow()
        
        shadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.8)
        
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        
        let buttonPlay = UIBarButtonItem(title:"Play", style:.plain, target:self, action:#selector(self.buttonPlayActionListener))
        
        buttonPlay.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:245.0/255.0, green:245.0/255.0, blue:245.0/255.0, alpha:1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!], for:UIControlState())
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target:nil, action:nil)
        
        self.navigationController?.toolbar.setItems([flexibleSpace, buttonPlay, flexibleSpace], animated:true)
        
        super.viewDidAppear(animated)
    }
    
    @objc fileprivate func buttonPlayActionListener()
    {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let gameCollectionViewController = GameCollectionViewController(collectionViewLayout:layout)
        
        gameCollectionViewController.scoreTableViewController = self
        
        self.navigationController?.pushViewController(gameCollectionViewController, animated:true)
    }
    
    fileprivate func getNumberOfItems() -> Int
    {
        return self.sauvegarde.integer(forKey: "NumberOfScores")
    }
    
    internal func gameFinish(_ score: Int)
    {
        if (score == 0)
        {
            return
        }
        if (self.sauvegarde.integer(forKey: "NumberOfScores") < 10)
        {
            self.sauvegarde.set(self.sauvegarde.integer(forKey: "NumberOfScores") + 1, forKey:"NumberOfScores")
        }
        if (self.getNumberOfItems() == 1)
        {
            self.sauvegarde.set(score, forKey:"Score0")
        }
        else
        {
            var i = 0
            while (i < self.getNumberOfItems() && i < 10)
            {
                if (self.sauvegarde.integer(forKey: "Score" + String(i)) < score)
                {
                    self.sauvegarde.set(self.sauvegarde.integer(forKey: "Score" + String(self.getNumberOfItems() - 2)), forKey:"Score" + String(self.getNumberOfItems() - 1))
                    var j = self.getNumberOfItems() - 2
                    while (j > i)
                    {
                        self.sauvegarde.set(self.sauvegarde.integer(forKey: "Score" + String(j - 1)), forKey:"Score" + String(j))
                        j -= 1
                    }
                    self.sauvegarde.set(score, forKey:"Score" + String(i))
                    break
                }
                i += 1
            }
            i = 10
            while (i < self.getNumberOfItems())
            {
                self.sauvegarde.removeObject(forKey: "Score" + String(i))
            }
        }
        self.sauvegarde.synchronize()
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (self.getNumberOfItems() == 0)
        {
            return 1
        }
        return self.getNumberOfItems()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (self.getNumberOfItems() == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
            
            cell.selectionStyle = .none
            
            cell.textLabel?.textAlignment = .center
            
            cell.textLabel?.text = "Aucun score enregistré"
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = "Score N°" + String(indexPath.row + 1) + " : " + String(self.sauvegarde.integer(forKey: "Score" + String(indexPath.row))) + " point(s)"
        
        cell.imageView?.image = UIImage(named:NSLocalizedString("ICON_SCORE", comment:""))
        
        cell.selectionStyle = .none

        return cell
    }
 
}
