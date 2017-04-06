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
    let iS = ImageStore()
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
   
    
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filtraContenuti(testoCercato: "", scope: "Tutti")
        tableView.reloadData()
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
        cell.departmentLabel.text = item.department!
        if item.newPrice <= 0{
            cell.priceLabel.text = "\(item.price) €"
            cell.priceLabel.textColor = UIColor(red: 68/255, green: 149/255, blue: 52/255, alpha: 1)
            cell.newPriceLabel.text = ""
        }else{
            cell.priceLabel.text = "\(item.price) €"
            cell.priceLabel.textColor = UIColor.red
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string:  cell.priceLabel.text!)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
            attributeString.addAttribute(NSStrikethroughColorAttributeName, value: UIColor.red, range: NSMakeRange(0, attributeString.length))
            cell.priceLabel.attributedText = attributeString
            
            cell.newPriceLabel.text = "\(item.newPrice) €"
        }
        if item.inTheList {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        //Inizializzare immagine di icona
        if iS.image(forKey: item.barCode!) == nil && item.imageUrl != nil {
            let url = URL.init(string: (item.imageUrl)!)
            let request = URLRequest(url: url! as URL)
            let task = session.dataTask(with: request, completionHandler: {
                (data, response, error) -> Void in
                let result = self.processImageRequest(data: data, error: error as NSError?)
                
                if case let .success(image) = result {
                    OperationQueue.main.addOperation {
                        cell.imageLabel.backgroundColor = UIColor.white
                        cell.imageLabel.image = image
                        cell.imageView?.contentMode = UIViewContentMode.scaleAspectFit
                    }
                }
            })
            task.resume()
        } else if item.imageUrl == nil {
            switch item.department! {
            case "Food":
                OperationQueue.main.addOperation {
                    cell.imageLabel.backgroundColor = UIColor.white
                    cell.imageLabel.image = #imageLiteral(resourceName: "fruit-default.png")
                    cell.imageLabel.contentMode = UIViewContentMode.scaleAspectFit
                }
            case "Item":
                OperationQueue.main.addOperation {
                    cell.imageLabel.backgroundColor = UIColor.white
                    cell.imageLabel.image = #imageLiteral(resourceName: "item-default.png")
                    cell.imageView?.contentMode = UIViewContentMode.scaleAspectFit
                }
            case "Drink":
                OperationQueue.main.addOperation {
                    cell.imageLabel.backgroundColor = UIColor.white
                    cell.imageLabel.image = #imageLiteral(resourceName: "water")
                    cell.imageView?.contentMode = UIViewContentMode.scaleAspectFit
                }
            default:
                OperationQueue.main.addOperation {
                    cell.imageLabel.backgroundColor = UIColor.white
                    cell.imageLabel.image = #imageLiteral(resourceName: "item-default.png")
                    cell.imageView?.contentMode = UIViewContentMode.scaleAspectFit
                }
            }
        } else {
            OperationQueue.main.addOperation {
                cell.imageLabel.image = self.iS.image(forKey: item.barCode!)
            }
        }
        
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
        
        let delete = UITableViewRowAction(style: .destructive, title: NSLocalizedString("Delete",comment: "")) { (action, indexPath) in
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
        
            let addToList = UITableViewRowAction(style: .normal, title: NSLocalizedString("Add to List",comment : "")) { (action, indexPath) in
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
                                        item.quantity = 1
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
    
    func processImageRequest(data: Data?, error: NSError?) -> ImageResult {
        guard let
            imageData = data,
            let image = UIImage(data: imageData) else {
                
                // Couldn't create an image
                if data == nil {
                    return .failure(error!)
                }
                else {
                    return .failure(PhotoError.imageCreationError)
                }
        }
        return .success(image)
    }
}
