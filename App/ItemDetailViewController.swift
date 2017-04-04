//
//  ItemDetailViewController.swift
//  App
//
//  Created by Francesco Caposiena on 01/04/2017.
//  Copyright © 2017 Francesco Caposiena. All rights reserved.
//

import Foundation
import UIKit

class ItemDetailViewController: UIViewController {
    
    var item : Product?
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var descript: UITextView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    var favouriteButton : UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = 10
        if (item?.favourite)! {
            favouriteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "star"), style: .plain, target: self, action: #selector (addFavourite))
        } else {
            favouriteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "star-2.png"), style: .plain, target: self, action: #selector (addFavourite))
        }
        
        self.navigationItem.rightBarButtonItem = favouriteButton
        // Do any additional setup after loading the view.
        self.quantityLabel.text = "\(item!.quantity)"
        self.descript.text = item!.descr
        self.priceLabel.text = "\(item!.price) €"
        if (item?.inTheList)! {
            addButton.setTitle("Remove from List", for: .normal)
            addButton.backgroundColor = .red
        } else {
            addButton.setTitle( "Add to List", for: .normal)
            addButton.backgroundColor = UIColor.init(red: 92/255, green: 162/255, blue: 41/255, alpha: 1.0)
        }
    }
    
    func addFavourite () {
        item?.favourite = !(item?.favourite)!
        if (item?.favourite)! {
            favouriteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "star"), style: .plain, target: self, action: #selector (addFavourite))
        } else {
            favouriteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "star-2.png"), style: .plain, target: self, action: #selector (addFavourite))
        }
        self.navigationItem.rightBarButtonItem = favouriteButton
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func insertIntoList(_ sender: UIButton) {
        item?.inTheList = !(item?.inTheList)!
        if (item?.inTheList)! {
            addButton.setTitle("Remove from List", for: .normal)
            addButton.backgroundColor = .red
        } else {
            addButton.setTitle( "Add to List", for: .normal)
            addButton.backgroundColor = UIColor.init(red: 92/255, green: 162/255, blue: 41/255, alpha: 1.0)
        }
        
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        var value = Int.init(quantityLabel.text!)!
        value += 1
        quantityLabel.text = "\(value)"
        item?.quantity = Int32(value)
        PersistenceManager.saveContext()
    }
    
    @IBAction func removeButton(_ sender: UIButton) {
        var value = Int.init(quantityLabel.text!)!
        if value > 0{
            value -= 1
        }
        quantityLabel.text = "\(value)"
        item?.quantity = Int32(value)
        PersistenceManager.saveContext()
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
