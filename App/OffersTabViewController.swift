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
    
    let iS = ImageStore()
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
   
    @IBAction func orderBy(_ sender: UIBarButtonItem) {
        showPopup()
    }
    
    //Liste di appoggio
    var list: Array<Product> = []
    var favourites : Array<Product> = []
    
    //Liste per i tab
    var myList : [Product] = []
    var favouritesList : [Product] = []
    var dailyList: [Product] = []
    var allList: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onSwitch(_ sender: UISegmentedControl) {
        switch(typeOfferte.selectedSegmentIndex) {
        case 0:
            myTableView.reloadData()
            if myList.count == 0{
                let noDataLabel:UILabel = UILabel()
                noDataLabel.text          = "No products in list is on offer"
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                myTableView.backgroundView = noDataLabel
                myTableView.separatorStyle  = .none
            }else{
                myTableView.backgroundView = nil
                myTableView.separatorStyle  = .singleLine
            }
        case 1:
            myTableView.reloadData()
            if favourites.count == 0{
                let noDataLabel:UILabel = UILabel()
                noDataLabel.text          = "No products in favourites is on offer"
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                myTableView.backgroundView = noDataLabel
                myTableView.separatorStyle  = .none
            }else{
                myTableView.backgroundView = nil
                myTableView.separatorStyle  = .singleLine
            }
        case 2:
            myTableView.reloadData()
            if dailyList.count == 0{
                let noDataLabel:UILabel = UILabel()
                noDataLabel.numberOfLines = 2
                
                noDataLabel.text          = "The daily deals are available in the supermarket."
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                myTableView.backgroundView = noDataLabel
                myTableView.separatorStyle  = .none
            }else{
                myTableView.backgroundView = nil
                myTableView.separatorStyle  = .singleLine
            }
        case 3:
            myTableView.reloadData()
            if allList.count == 0{
                let noDataLabel:UILabel = UILabel()
                noDataLabel.text          = "There are no offers, now!"
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                myTableView.backgroundView = noDataLabel
                myTableView.separatorStyle  = .none
            }else{
                myTableView.backgroundView = nil
                myTableView.separatorStyle  = .singleLine
            }
        default:
            break
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        caricaListe()
        myTableView.reloadData()
        switch(typeOfferte.selectedSegmentIndex) {
        case 0:
            myTableView.reloadData()
            if myList.count == 0{
                let noDataLabel:UILabel = UILabel()
                noDataLabel.text          = "No products in list is on offer"
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                myTableView.backgroundView = noDataLabel
                myTableView.separatorStyle  = .none
            }else{
                myTableView.backgroundView = nil
                myTableView.separatorStyle  = .singleLine
            }
        case 1:
            myTableView.reloadData()
            if favourites.count == 0{
                let noDataLabel:UILabel = UILabel()
                noDataLabel.text          = "No products in favourites is on offer"
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                myTableView.backgroundView = noDataLabel
                myTableView.separatorStyle  = .none
            }else{
                myTableView.backgroundView = nil
                myTableView.separatorStyle  = .singleLine
            }
        case 2:
            myTableView.reloadData()
            if dailyList.count == 0{
                let noDataLabel:UILabel = UILabel()
                noDataLabel.text          = "The daily deals are available in the supermarket."
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                myTableView.backgroundView = noDataLabel
                myTableView.separatorStyle  = .none
            }else{
                myTableView.backgroundView = nil
                myTableView.separatorStyle  = .singleLine
            }
        case 3:
            myTableView.reloadData()
            if allList.count == 0{
                let noDataLabel:UILabel = UILabel()
                noDataLabel.text          = "There are no offers, now!"
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                myTableView.backgroundView = noDataLabel
                myTableView.separatorStyle  = .none
            }else{
                myTableView.backgroundView = nil
                myTableView.separatorStyle  = .singleLine
            }
        default:
            break
        }
    }

    func caricaListe() {
        list = PersistenceManager.fetchList()
        favourites = PersistenceManager.fetchFavourites()
        
        //Effettuare caricamento delle offerte
        allList = PersistenceManager.fetchOffers()
        
        dailyList = PersistenceManager.fetchDaily()
        
        myList = matchList (list)
        favouritesList = matchList (favourites)
    }
    
    func matchList (_ source: Array<Product>) -> Array<Product> {
        var temp = Array<Product> ()
        
        for item in allList {
            if source.contains(item) {
                temp.append(item)
            }
        }
        
        return temp
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! OfferCellTableViewCell
        let item: Product
        
        switch(typeOfferte.selectedSegmentIndex) {
            case 0:
                item = myList[indexPath.row]
            case 1:
                item = favouritesList[indexPath.row]
            case 2:
                item = dailyList[indexPath.row]
            case 3:
                item = allList[indexPath.row]
            default:
                item = allList[indexPath.row]
        }
        cell.nameLabel.text = item.name!
        cell.departmentLabel.text = item.department
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

        //AGGIUNGE IMMAGINE A IMGVIEW
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
    
    @IBAction func refreshButtonTapped(sender: AnyObject) {
        caricaListe()
        myTableView.reloadData()
    }
    
    @IBAction func segmentedControlActionChanged(sender: AnyObject) {
        caricaListe()
        myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        
        switch(typeOfferte.selectedSegmentIndex) {
            case 0:
                returnValue = myList.count
            case 1:
                returnValue = favouritesList.count
            case 2:
                returnValue = dailyList.count
            case 3:
                returnValue = allList.count
            default:
                returnValue = 0
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
            let item : Product
            switch (typeOfferte.selectedSegmentIndex){
                case 0:
                    item=myList[currentRow!]
                case 1:
                    item=favouritesList[currentRow!]
                case 2:
                    item=dailyList[currentRow!]
                case 3:
                    item=allList[currentRow!]
                default:
                    item=allList[currentRow!]
                }
            let dstView = segue.destination as! ItemDetailViewController
            dstView.title=item.name!
            dstView.item=item
        }
    }
    
    func showPopup(){
        
        let popUp = UIAlertController(title: NSLocalizedString("Order by",comment: ""),message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        self.present(popUp, animated: true, completion: nil)
        
        popUp.addAction(UIAlertAction(title: NSLocalizedString("Name",comment: ""),style: UIAlertActionStyle.default, handler:{(paramAction: UIAlertAction!) in
            
            switch (self.typeOfferte.selectedSegmentIndex){
            case 0:
                self.myList = self.myList.sorted(by: {$0.name! < $1.name! })
                self.myTableView.reloadData()
            case 1:
                self.favouritesList = self.favouritesList.sorted(by: {$0.name! < $1.name! })
                self.myTableView.reloadData()
            case 2:
                self.dailyList = self.dailyList.sorted(by: {$0.name! < $1.name! })
                self.myTableView.reloadData()
            case 3:
                self.allList = self.allList.sorted(by: {$0.name! < $1.name! })
                self.myTableView.reloadData()
            default:
                break
            }
            
        }))
        
        popUp.addAction(UIAlertAction(title: NSLocalizedString("Price",comment: ""), style: UIAlertActionStyle.default, handler:
            {(paramAction: UIAlertAction!) in
                switch (self.typeOfferte.selectedSegmentIndex){
                case 0:
                    self.myList = self.myList.sorted(by: {$0.newPrice < $1.newPrice })
                    self.myTableView.reloadData()
                case 1:
                    self.favouritesList = self.favouritesList.sorted(by: {$0.newPrice < $1.newPrice })
                    self.myTableView.reloadData()
                case 2:
                    self.dailyList = self.dailyList.sorted(by: {$0.newPrice < $1.newPrice })
                    self.myTableView.reloadData()
                case 3:
                    self.allList = self.allList.sorted(by: {$0.newPrice < $1.newPrice })
                    self.myTableView.reloadData()
                default:
                    break
                }
                
                
        }))
        
        popUp.addAction(UIAlertAction(title: NSLocalizedString("Convenience",comment: ""),style: UIAlertActionStyle.default, handler:
            {(paramAction: UIAlertAction!) in
                switch (self.typeOfferte.selectedSegmentIndex){
                case 0:
                    self.myList = self.myList.sorted(by: {($0.price - $0.newPrice) > ($1.price - $1.newPrice) })
                    self.myTableView.reloadData()
                case 1:
                    self.favouritesList = self.favouritesList.sorted(by: {($0.price - $0.newPrice) > ($1.price - $1.newPrice) })
                    self.myTableView.reloadData()
                case 2:
                    self.dailyList = self.dailyList.sorted(by: {($0.price - $0.newPrice) > ($1.price - $1.newPrice)})
                    self.myTableView.reloadData()
                case 3:
                    self.allList = self.allList.sorted(by: {($0.price - $0.newPrice) > ($1.price - $1.newPrice)})
                    self.myTableView.reloadData()
                default:
                    break
                }
                
        }))
        
        
        popUp.addAction(UIAlertAction(title: NSLocalizedString("Cancel",comment: ""), style: UIAlertActionStyle.destructive, handler:
            {(paramAction: UIAlertAction!) in
                self.viewDidLoad()
        }))
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

