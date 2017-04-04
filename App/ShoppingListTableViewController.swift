//
//  ShoppingListTableViewController.swift
//  App
//
//  Created by Francesco Caposiena on 01/04/2017.
//  Copyright © 2017 Francesco Caposiena. All rights reserved.
//

import Foundation
import UIKit

class ShoppingListTableViewController: UITableViewController {
    
    var list : Array<Product> = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        list = PersistenceManager.fetchList()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return list.count
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingListCell", for: indexPath) as!ShoppingListTableViewCell
        
        // Configure the cell...
        cell.nameLabel.text = list[indexPath.row].name!
        cell.departmentLabel.text = list[indexPath.row].department
        cell.priceLabel.text = "\(list[indexPath.row].price) €"
        cell.quantityLabel.text = "\(list[indexPath.row].quantity)"
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
     }
 
    @IBAction func addButton(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint(), to: tableView)
        let currentIndexPath = tableView.indexPathForRow(at: buttonPosition)
        let cell = tableView.cellForRow(at: currentIndexPath!) as! ShoppingListTableViewCell
        
        var value = Int.init(cell.quantityLabel.text!)!
        value += 1
        
        cell.quantityLabel.text = "\(value)"
        let item = list[currentIndexPath!.row]
        item.quantity = Int32(value)
        PersistenceManager.saveContext()
    }
 
    
    @IBAction func removeButton(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint(), to: tableView)
        let currentIndexPath = tableView.indexPathForRow(at: buttonPosition)
        let cell = tableView.cellForRow(at: currentIndexPath!) as! ShoppingListTableViewCell
        
        
        var value = Int.init(cell.quantityLabel.text!)!
        if value > 0 {
            value -= 1
        }
        
        cell.quantityLabel.text = "\(value)"
        let item = list[currentIndexPath!.row]
        item.quantity = Int32(value)
        PersistenceManager.saveContext()
    }
 
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        // Delete the row from the data source
            PersistenceManager.deleteProduct(product: list[indexPath.row])
            list.remove(at: indexPath.row)
            PersistenceManager.saveContext()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
     }
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = .white
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed

        if segue.identifier == "showItem" {
            print("i'm in!")
            let currentRow = tableView.indexPathForSelectedRow?.row
            let currentItem = list[currentRow!]
            let dstView = segue.destination as! ItemDetailViewController
            dstView.title = currentItem.name!
            dstView.item = currentItem
        }
    }
}

