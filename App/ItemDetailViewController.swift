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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
        self.quantityLabel.text = "\(item!.quantity)"
        self.descript.text = item!.descr
        self.priceLabel.text = "\(item!.price)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        var value = Int.init(quantityLabel.text!)!
        value += 1
        quantityLabel.text = "\(value)"
        item?.quantity = Int32.init(quantityLabel.text!)!
        PersistenceManager.saveContext()
    }
    
    @IBAction func removeButton(_ sender: UIButton) {
        var value = Int.init(quantityLabel.text!)!
        if value > 0{
           value -= 1 
        }
        quantityLabel.text = "\(value)"
        item?.quantity = Int32.init(quantityLabel.text!)!
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

