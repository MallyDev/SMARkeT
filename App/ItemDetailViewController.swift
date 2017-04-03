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
    @IBOutlet weak var minusButton: NSLayoutConstraint!
    @IBOutlet weak var descript: UITextView!
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
        if item != nil {
            self.navigationItem.title = item!.name
            self.quantityLabel.text = "\(item!.quantity)"
            self.descript.text = item!.descr
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButton(_ sender: Any) {
        var value = Int.init(quantityLabel.text!)!
        value += 1
        quantityLabel.text = "\(value)"
    }
    
    @IBAction func removeButton(_ sender: Any) {
        var value = Int.init(quantityLabel.text!)!
        if value >= 0{
           value -= 1 
        }
        quantityLabel.text = "\(value)"
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

