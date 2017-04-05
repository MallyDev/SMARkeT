//
//  FavouritesTabTableViewController.swift
//  App
//
//  Created by Francesco Caposiena on 01/04/2017.
//  Copyright © 2017 Francesco Caposiena. All rights reserved.
//

import Foundation
import UIKit

class FavouritesTabTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate{
    
    var favourites = [Product]()
    var filtered : Array<Product> = []
    var resultSearchController: UISearchController?
   
    
    override func viewWillAppear(_ animated: Bool) {
        favourites = PersistenceManager.fetchFavourites()
        
        filtered.removeAll(keepingCapacity: true)
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definesPresentationContext = true
        
        self.resultSearchController = ({
            // creo un oggetto di tipo UISearchController
            let controller = UISearchController(searchResultsController: nil)
            // rimuove la tableView di sottofondo in modo da poter successivamente visualizzare gli elementi cercati
            controller.dimsBackgroundDuringPresentation = false
            
            // il searchResultsUpdater, ovvero colui che gestirà gli eventi di ricerca, sarà la ListaTableViewController (o self)
            controller.searchResultsUpdater = self
            
            // impongo alla searchBar, contenuta all'interno del controller, di adattarsi alle dimensioni dell'applicazioni
            controller.searchBar.sizeToFit()
            
            // atacco alla parte superiore della TableView la searchBar
            self.navigationItem.titleView = controller.searchBar
            
            controller.hidesNavigationBarDuringPresentation = false
            
            controller.searchBar.delegate = self
            
            // restituisco il controller creato
            return controller
        })()
        
        favourites = PersistenceManager.fetchFavourites()
        /*self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.editButtonItem.tintColor = UIColor.white
        UIBarButtonItem.appearance().tintColor = .white*/
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        self.filtraContenuti(testoCercato: searchController.searchBar.text!, scope: "Tutti")
    }
    
    func filtraContenuti(testoCercato: String, scope: String) {
        if testoCercato == ""{
            filtered.removeAll(keepingCapacity: true)
            filtered.append(contentsOf: favourites)
        }else{
            filtered.removeAll(keepingCapacity: true)
            for x in favourites {
                /*var justOne = false
                 for (_, categoria) in x.department.enumerate() {
                 if (scope == "Tutti" || categoria == scope) {
                 if((x.nome.rangeOfString(testoCercato.localizedLowercaseString) != nil) && justOne == false) {
                 print("aggiungo \(x.nome) alla listaFiltrata")
                 listaFiltrata.append(x)
                 justOne = true
                 }
                 }
                 }*/
                if (scope == "Tutti") {
                    if (x.name?.range(of: testoCercato) != nil) {
                        filtered.append(x)
                    }
                }
                
                self.tableView.reloadData()
            }
        }
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
        guard let controller = self.resultSearchController else {
            return 0
        }
        
        if controller.isActive {
            return self.filtered.count
        } else {
            return self.favourites.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteCell", for: indexPath) as! FavouritesTableViewCell
        
        let item : Product
        if self.resultSearchController!.isActive {
            item = filtered[indexPath.row]
        } else {
            item = favourites[indexPath.row]
        }
        cell.nameLabel.text = item.name!
        cell.priceLabel.text = "\(item.price)"
        cell.departmentLabel.text = item.department!
        if item.newPrice >= 0 {
            cell.newPriceLabel.text = "\(item.newPrice)"
        } else {
            cell.newPriceLabel.text = ""
        }
        //Inizializzare immagine di icona
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = .white
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        
        if segue.identifier == "showItem" {
            let currentRow = tableView.indexPathForSelectedRow?.row
            let currentItem = favourites[currentRow!]
            let dstView = segue.destination as! ItemDetailViewController
            dstView.title = currentItem.name!
            dstView.item = currentItem
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
     // Override to support editing the table view.
     /*override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let item : Product
            if self.resultSearchController!.isActive {
                item = filtered[indexPath.row]
                filtered.remove(at: indexPath.row)
            } else {
                item = favourites[indexPath.row]
                favourites.remove(at: indexPath.row)
            }
            item.favourite = false
            tableView.deleteRows(at: [indexPath], with: .fade)
            item.favourite = false
            PersistenceManager.saveContext()
        }
     }*/
    
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
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            let item : Product
            if self.resultSearchController!.isActive {
                item = self.filtered[indexPath.row]
                self.filtered.remove(at: indexPath.row)
            } else {
                item = self.favourites[indexPath.row]
                self.favourites.remove(at: indexPath.row)
            }
            item.favourite = false
            tableView.deleteRows(at: [indexPath], with: .fade)
            item.favourite = false
            PersistenceManager.saveContext()
        }

        
        let itemTest:Product
        if self.resultSearchController!.isActive {
            itemTest = self.filtered[indexPath.row]
        } else {
            itemTest = self.favourites[indexPath.row]
        }
        
        if itemTest.inTheList == false{
        
            
 
                        let addToList = UITableViewRowAction(style: .normal, title: "Add to List") { (action, indexPath) in
                                // add to shopping list
                                let item : Product
                                if self.resultSearchController!.isActive {
                                    item = self.filtered[indexPath.row]
                                } else {
                                    item = self.favourites[indexPath.row]
                                }
                                    if item.inTheList == true{
                                        tableView.reloadData()
                                    }else{
                                    
                                        item.inTheList = true
                                        PersistenceManager.saveContext()
                                        tableView.reloadData()
                                }
                        }

        
    
        //addToList.backgroundColor = UIColor(patternImage: UIImage.init(imageLiteralResourceName: "/Users/mariocantalupo/Desktop/appShop/App/check-mark-white-on-black-circular-background-2.png"))
        addToList.backgroundColor = UIColor.orange
        
        
    
    
        return [delete, addToList]
        }else{
            return [delete]
        }
        
    }
}
