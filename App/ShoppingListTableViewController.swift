//
//  ShoppingListTableViewController.swift
//  App
//
//  Created by Francesco Caposiena on 01/04/2017.
//  Copyright © 2017 Francesco Caposiena. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}
enum PhotoError: Error {
    case imageCreationError
}

class ShoppingListTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    var list : Array<Product> = []
    let iS = ImageStore()
    
    var dataSource: Array<String> = []
    var picker = UIPickerView()
    var cellModified = ShoppingListTableViewCell()
    var itemModified = Product()
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()

    
    var tabArray:NSArray!
    var tabItem:UITabBarItem!
    var numberNot = 0
    let application = UIApplication.shared
    let center = UNUserNotificationCenter.current()
    
    @IBAction func updateQuantity(_ sender: UITextField) {
        let textFieldPosition = sender.convert(CGPoint(), to: tableView)
        let currentIndexPath = tableView.indexPathForRow(at: textFieldPosition)
        cellModified = tableView.cellForRow(at: currentIndexPath!) as! ShoppingListTableViewCell
        cellModified.quantityLabel.delegate = self
        cellModified.resignFirstResponder()
        tableView.resignFirstResponder()
        //let value = Int.init(cellModified.quantityLabel.text!)!
        //cellModified.quantityLabel.text = "\(value)"
        //picker.selectedRow(inComponent: value)
        itemModified = list[currentIndexPath!.row]
        //itemModified.quantity = Int32(value)
        //cellModified.quantityLabel.text = "\(value)"
        picker.selectRow(Int.init(cellModified.quantityLabel.text!)!-1, inComponent: 0, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        list = PersistenceManager.fetchList()
        tableView.reloadData()
        if list.count == 0{
            let noDataLabel:UILabel = UILabel()
            noDataLabel.text          = "Your shopping list is empty. \n Add an item"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            self.tableView.backgroundView = noDataLabel
            self.tableView.separatorStyle  = .none
        }else{
         self.tableView.backgroundView = nil
            self.tableView.separatorStyle  = .singleLine
        }
        numberNot = 0
        tabArray = self.tabBarController?.tabBar.items as NSArray!
        tabItem = tabArray?.object(at: 1) as! UITabBarItem
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        application.registerForRemoteNotifications()
        for index in 0..<list.count {
            if list[index].newPrice > 0 && self.list[index].bought == false{
                numberNot+=1
            }
        }
        if numberNot != 0{
            tabItem.badgeValue = String(numberNot)
            application.applicationIconBadgeNumber = numberNot
        }else{
            tabItem.badgeValue=nil
            application.applicationIconBadgeNumber = 0
        }

    }
    
    func inizializeData () {
        for index in 1...100 {
            dataSource.append("\(index)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
               
        picker.dataSource = self
        picker.delegate = self
        tableView.delegate = self
        inizializeData()
        
        
       // let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ShoppingListTableViewController.hideKeyboard))
       // tapGesture.cancelsTouchesInView = true
       // tableView.addGestureRecognizer(tapGesture)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    func hideKeyboard() {
        tableView.endEditing(true)
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
        let item = list[indexPath.row]
        cell.nameLabel.text = item.name!
        cell.departmentLabel.text = list[indexPath.row].department!
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
        cell.quantityLabel.text = "\(item.quantity)"
        cell.quantityLabel.inputView = picker
        
        if list[indexPath.row].bought{
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string:  cell.nameLabel.text!)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
            attributeString.addAttribute(NSStrikethroughColorAttributeName, value: UIColor.black, range: NSMakeRange(0, attributeString.length))
            cell.nameLabel.attributedText = attributeString
        }else{
            cell.nameLabel.attributedText = NSMutableAttributedString(string:  cell.nameLabel.text!)

        }
        
        if cell.departmentLabel.text == "Reparto"{
            OperationQueue.main.addOperation {
                cell.imgView.image = #imageLiteral(resourceName: "fruit-default.png")
                cell.imgView.backgroundColor = UIColor.white
            }
        }
        //carico l'immagine
        if iS.image(forKey: list[indexPath.row].barCode!) == nil && item.imageUrl != nil {
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
                } else {
                    OperationQueue.main.addOperation {
                        cell.imgView.image = #imageLiteral(resourceName: "Race-Registration-Image-Not-Found")
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
        
        /*if (item.imageUrl != nil) {
            OperationQueue.main.addOperation {
                let url = URL.init(string: (item.imageUrl)!)
                var dat : Data = Data()
                do {
                    dat = try Data.init(contentsOf: url!)
                } catch let error as NSError {
                    print("ERROR LOADING IMAGE: ",error)
                }
                let image = UIImage.init(data: dat, scale: 2.0)
                cell.imgView.image = image
            }
        }*/
        
        //
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ShoppingListTableViewController.donePicker))
        doneButton.tintColor = UIColor.green
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        
        if list[indexPath.row].newPrice >= 0 {
            cell.newPriceLabel.text = "\(list[indexPath.row].newPrice)"
        } else {
            cell.newPriceLabel.text = ""
        }
        
        cell.quantityLabel.inputAccessoryView = toolBar
        
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
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
            list[indexPath.row].inTheList = false
            list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            PersistenceManager.saveContext()
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
            let currentRow = tableView.indexPathForSelectedRow?.row
            let currentItem = list[currentRow!]
            let dstView = segue.destination as! ItemDetailViewController
            dstView.title = currentItem.name!
            dstView.item = currentItem
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
   
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cellModified.quantityLabel.text! = dataSource[row]
        itemModified.quantity = Int32.init(cellModified.quantityLabel.text!)!
        PersistenceManager.saveContext()
    }
    
    //cellModified.quantityLabel.resignFirstResponder()
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cellModified.quantityLabel.resignFirstResponder()
        return true
    }
    
    func donePicker() {
        
        cellModified.quantityLabel.resignFirstResponder()
        
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       
        let delete = UITableViewRowAction(style: .destructive, title: NSLocalizedString("Delete",comment: "")) { (action, indexPath) in
            // delete item at indexPath
            // Delete the row from the data source
            self.list[indexPath.row].inTheList = false
             self.list[indexPath.row].bought = false
            self.list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            PersistenceManager.saveContext()
            
            if self.list.count == 0{
                
                let noDataLabel:UILabel = UILabel()
                noDataLabel.text          = "Your shopping list is empty. \n Add an item"
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                self.tableView.backgroundView = noDataLabel
                self.tableView.separatorStyle  = .none
            }else{
                self.tableView.backgroundView = nil
                self.tableView.separatorStyle  = .singleLine
            }

            
            
            self.list = PersistenceManager.fetchList()
            self.numberNot = 0
            self.center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
            }
            self.application.registerForRemoteNotifications()
            for index in 0..<self.list.count{
                if self.list[index].newPrice > 0  && self.list[index].bought == false{
                    self.numberNot+=1
                }
            }
            if self.numberNot != 0{
                self.tabItem.badgeValue = String(self.numberNot)
                self.application.applicationIconBadgeNumber = self.numberNot
            }else{
                self.tabItem.badgeValue=nil
                self.application.applicationIconBadgeNumber = 0
            }


        }
        
        let item : Product
        item = self.list[indexPath.row]
        var done:UITableViewRowAction
        if item.bought == false{
        
            done = UITableViewRowAction(style: .default, title: NSLocalizedString("Bought",comment: "")) { (action, indexPath) in
                // add to shopping list
                self.list[indexPath.row].bought = true
                tableView.reloadData()
                PersistenceManager.saveContext()
                self.list = PersistenceManager.fetchList()
                self.numberNot = 0
                self.center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                    // Enable or disable features based on authorization.
                }
                self.application.registerForRemoteNotifications()
                for index in 0..<self.list.count {
                    if self.list[index].newPrice > 0 && self.list[index].bought == false{
                        self.numberNot+=1
                    }
                }
                if self.numberNot != 0 {
                    self.tabItem.badgeValue = String(self.numberNot)
                    self.application.applicationIconBadgeNumber = self.numberNot
                }else{
                    self.tabItem.badgeValue=nil
                    self.application.applicationIconBadgeNumber = 0
                }
        
            }
        }else{
            
                done = UITableViewRowAction(style: .default, title:NSLocalizedString("Add to List",comment:"")) { (action, indexPath) in
                    // add to shopping list
                    self.list[indexPath.row].bought = false
                    tableView.reloadData()
                    PersistenceManager.saveContext()
                    self.list = PersistenceManager.fetchList()
                    self.numberNot = 0
                    self.center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                        // Enable or disable features based on authorization.
                    }
                    self.application.registerForRemoteNotifications()
                    for index in 0..<self.list.count{
                        if self.list[index].newPrice > 0  && self.list[index].bought == false{
                            self.numberNot+=1
                        }
                    }
                    if self.numberNot != 0{
                        self.tabItem.badgeValue = String(self.numberNot)
                        self.application.applicationIconBadgeNumber = self.numberNot
                    }else{
                        self.tabItem.badgeValue=nil
                        self.application.applicationIconBadgeNumber = 0
                    }
        }
        
       
        }
        
        
        
        //addToList.backgroundColor = UIColor(patternImage: UIImage.init(imageLiteralResourceName: "/Users/mariocantalupo/Desktop/appShop/App/check-mark-white-on-black-circular-background-2.png"))
        done.backgroundColor = UIColor.orange
        
        
        
        
        return [delete, done]
    }

}

