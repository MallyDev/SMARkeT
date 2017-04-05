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
    @IBOutlet weak var descript: UITextView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
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
        self.title=item?.name
        self.quantityLabel.text = "\(item!.quantity)"
        self.descript.text = item!.descr
        self.departmentLabel.text = item!.department!
        self.priceLabel.text = "\(item!.price) €"
        if (item?.inTheList)! {
            addButton.setTitle("Remove from List", for: .normal)
            addButton.backgroundColor = UIColor.init(red: 255/255, green: 192/255, blue: 19/255, alpha: 1.0)
        } else {
            addButton.setTitle( "Add to List", for: .normal)
            addButton.backgroundColor = UIColor.init(red: 92/255, green: 162/255, blue: 41/255, alpha: 1.0)
        }
        stepper.value = Double((item?.quantity)!)
        
        //prova immagine
        imgView.image = #imageLiteral(resourceName: "plus-button.png")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        descript.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func addFavourite () {
        item?.favourite = !(item?.favourite)!
        if (item?.favourite)! {
            favouriteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "star"), style: .plain, target: self, action: #selector (addFavourite))
        } else {
            favouriteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "star-2.png"), style: .plain, target: self, action: #selector (addFavourite))
        }
        self.navigationItem.rightBarButtonItem = favouriteButton
        PersistenceManager.saveContext()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func insertIntoList(_ sender: UIButton) {
        item?.inTheList = !(item?.inTheList)!
        if (item?.inTheList)! {
            sender.setTitle("Remove from List", for: .normal)
            sender.backgroundColor = UIColor.init(red: 255/255, green: 192/255, blue: 19/255, alpha: 1.0)
        } else {
            sender.setTitle( "Add to List", for: .normal)
            sender.backgroundColor = UIColor.init(red: 92/255, green: 162/255, blue: 41/255, alpha: 1.0)
        }
        PersistenceManager.saveContext()
    }
    
    @IBAction func modifyQuantity(_ sender: UIStepper) {
        item?.quantity = Int32(sender.value)
        quantityLabel.text = "\(Int32(sender.value))"
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
