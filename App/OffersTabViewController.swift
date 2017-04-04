//
//  OffersTabViewController.swift
//  App
//
//  Created by Francesco Caposiena on 01/04/2017.
//  Copyright © 2017 Francesco Caposiena. All rights reserved.
//

import Foundation
import UIKit

class OffersTabViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var typeOfferte: UISegmentedControl!
    @IBOutlet weak var myTableView: UITableView!
    
    //test
    var myList = [Product] ()
    let favouritesList:[String] = ["Favourite item 1","Favourite item 2", "Favourite item 3"]
    let dailyList:[String] = ["Expiring item 1", "Expiring item 2", "Expiring item 3", "Expiring item 4"]
    let allList:[String] = ["All item 1", "All item 2", "All item 3", "All item 4"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myList=PersistenceManager.fetchAll()
        myList.append(PersistenceManager.newEmptyProd())
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "showItem" {
            let currentRow = tableView.indexPathForSelectedRow?.row
            let currentItem = favourites[currentRow!]
            let dstView = segue.destination as! ItemDetailViewController
            dstView.title = currentItem.name!
            dstView.item = currentItem
        }
     }*/
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! OfferCellTableViewCell
        
        switch(typeOfferte.selectedSegmentIndex)
        {
        case 0:
            print("O")
            let item = myList[indexPath.row]
            myCell.name.text = item.name
            break
        case 1:
            let item = favouritesList[indexPath.row]
            myCell.name.text = item
            break
            
        case 2:
            let item = dailyList[indexPath.row]
            myCell.name.text = item
            break
            
        case 3:
            let item = allList[indexPath.row]
            myCell.name.text = item
            break
            
        default:
            break
            
        }
        
        
        return myCell
    }
    
    
    
    @IBAction func refreshButtonTapped(sender: AnyObject) {
        myTableView.reloadData()
        print("refresh")
    }
    
    @IBAction func segmentedControlActionChanged(sender: AnyObject) {
        
        myTableView.reloadData()
        print("actionChanged")
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var returnValue = 0
        
        switch(typeOfferte.selectedSegmentIndex)
        {
        case 0:
            print("0-2")
            returnValue = myList.count
            break
        case 1:
            returnValue = favouritesList.count
            break
            
        case 2:
            returnValue = dailyList.count
            break
        case 3:
            returnValue = allList.count
            break
        default:
            break
            
        }
        
        return returnValue
        
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = .white
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        if segue.identifier == "showItem" {
            let currentRow = myTableView.indexPathForSelectedRow?.row
            let currentItem = myList[currentRow!]
            let dstView = segue.destination as! ItemDetailViewController
            dstView.title = currentItem.name!
            dstView.item = currentItem
        }
    }

    
}

