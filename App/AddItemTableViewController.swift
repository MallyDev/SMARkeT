//
//  AddItemTableViewController.swift
//  App
//
//  Created by Francesco Caposiena on 01/04/2017.
//  Copyright © 2017 Francesco Caposiena. All rights reserved.
//

import Foundation
import UIKit

class AddItemTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var resultSearchController: UISearchController?
    var products : Array<Product> = []
    var filtered : Array<Product> = []
    let iS = ImageStore()
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    public func updateSearchResults(for searchController: UISearchController) {
        self.filtraContenuti(testoCercato: searchController.searchBar.text!, scope: "Tutti")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        products = PersistenceManager.fetchAll()
        
        filtered.removeAll(keepingCapacity: true)
        
        self.tableView.reloadData()
            self.resultSearchController = ({
                // creo un oggetto di tipo UISearchController
                let controller = UISearchController(searchResultsController: nil)
                // rimuove la tableView di sottofondo in modo da poter successivamente visualizzare gli elementi cercati
                controller.dimsBackgroundDuringPresentation = false
                
                // il searchResultsUpdater, ovvero colui che gestirà gli eventi di ricerca, sarà la ListaTableViewController (o self)
                controller.searchResultsUpdater = self
                
                // impongo alla searchBar, contenuta all'interno del controller, di adattarsi alle dimensioni dell'applicazioni
                controller.searchBar.sizeToFit()
                
                // attacco alla parte superiore della TableView la searchBar
                self.navigationItem.titleView = controller.searchBar
                
                controller.hidesNavigationBarDuringPresentation = false
                
                controller.searchBar.delegate = self
                
                
                
                // restituisco il controller creato
                return controller
            })()
        

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filtraContenuti(testoCercato: "", scope: "Tutti")
        tableView.reloadData()
    }
    
    func filtraContenuti(testoCercato: String, scope: String) {
        if testoCercato == "" {
            filtered.removeAll(keepingCapacity: true)
            filtered.append(contentsOf: products)
        } else {
            filtered.removeAll(keepingCapacity: true)
            for x in products {
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
                    if (x.name?.localizedLowercase.range(of: testoCercato.localizedLowercase) != nil) {
                        filtered.append(x)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func addItem(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint(), to: tableView)
        let currentRow = tableView.indexPathForRow(at: buttonPosition)
        let item : Product
        
        //aggiungiElemento
        if self.resultSearchController!.isActive {
            item = filtered[currentRow!.row]
        } else {
            item = products[currentRow!.row]
        }
        if item.inTheList {
            item.quantity = 0
        } else {
            item.quantity = 1
        }
        item.inTheList = !item.inTheList
        PersistenceManager.saveContext()
        
        //cambia icona
        if item.inTheList {
            sender.setImage(#imageLiteral(resourceName: "check-mark-white-on-black-circular-background-2.png"), for: .normal)
        } else {
            sender.setImage(#imageLiteral(resourceName: "plus-button-2.png"), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definesPresentationContext = true
        
        //inizializza la lista di prodotti
        products = PersistenceManager.fetchAll()
        UIBarButtonItem.appearance().tintColor = .white
        
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
        guard let controller = self.resultSearchController else {
            return 0
        }
        
        if controller.isActive {
            return self.filtered.count
        } else {
            return self.products.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addItemTableCell", for: indexPath) as! AddItemTableViewCell
        
        // Configure the cell...
        let item : Product
        if self.resultSearchController!.isActive {
            item = filtered[indexPath.row]
        } else {
            item = products[indexPath.row]
        }
        cell.nameLabel.text = item.name!
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
        cell.departmentLabel.text = item.department!
                
        if item.inTheList {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        if iS.image(forKey: item.barCode!) == nil && item.imageUrl != nil {
            let url = URL.init(string: (item.imageUrl)!)
            let request = URLRequest(url: url! as URL)
            let task = session.dataTask(with: request, completionHandler: {
                (data, response, error) -> Void in
                let result = self.processImageRequest(data: data, error: error as NSError?)
                
                if case let .success(image) = result {
                    OperationQueue.main.addOperation {
                        cell.imgView.backgroundColor = UIColor.white
                        cell.imgView.image = image
                        cell.imageView?.contentMode = UIViewContentMode.scaleAspectFit
                    }
                }
            })
            task.resume()
        } else if item.imageUrl == nil {
            switch item.department! {
            case "Food":
                OperationQueue.main.addOperation {
                    cell.imgView.backgroundColor = UIColor.white
                    cell.imgView.image = #imageLiteral(resourceName: "fruit-default.png")
                    cell.imageView?.contentMode = UIViewContentMode.scaleAspectFit
                }
            case "Item":
                OperationQueue.main.addOperation {
                    cell.imgView.backgroundColor = UIColor.white
                    cell.imgView.image = #imageLiteral(resourceName: "item-default.png")
                    cell.imageView?.contentMode = UIViewContentMode.scaleAspectFit
                }
            case "Drink":
                OperationQueue.main.addOperation {
                    cell.imgView.backgroundColor = UIColor.white
                    cell.imgView.image = #imageLiteral(resourceName: "water")
                    cell.imageView?.contentMode = UIViewContentMode.scaleAspectFit
                }
            default:
                OperationQueue.main.addOperation {
                    cell.imgView.backgroundColor = UIColor.white
                    cell.imgView.image = #imageLiteral(resourceName: "item-default.png")
                    cell.imageView?.contentMode = UIViewContentMode.scaleAspectFit
                }
            }
        } else {
            OperationQueue.main.addOperation {
                cell.imgView.image = self.iS.image(forKey: item.barCode!)
            }
        }
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
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
    
     /*override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showItem", sender: tableView)
     }*/
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "showItem" {
            let dst = segue.destination as! ItemDetailViewController
            let currentRow = self.tableView.indexPathForSelectedRow!.row
            if self.resultSearchController!.isActive {
                dst.title = filtered[currentRow].name!
                dst.item = filtered[currentRow]
            } else {
                dst.title = products[currentRow].name!
                dst.item = products[currentRow]
            }
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

