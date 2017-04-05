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
    var favouriteButton : UIBarButtonItem?
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var descript: UITextView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var newPriceLabel: UILabel!
    
    
    
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
        if item!.newPrice <= 0{
            self.priceLabel.text = "\(item!.price) €"
        }else{
            self.priceLabel.text = "\(item!.price) €"
            self.priceLabel.textColor = UIColor.red
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string:  self.priceLabel.text!)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
            attributeString.addAttribute(NSStrikethroughColorAttributeName, value: UIColor.red, range: NSMakeRange(0, attributeString.length))
             self.priceLabel.attributedText = attributeString
            
            self.newPriceLabel.text = "\(item!.newPrice) €"
            
        }
        
        if (item?.inTheList)! {
            
            addButton.setTitle(NSLocalizedString("Remove from List",comment:""), for: .normal)
            addButton.backgroundColor = UIColor.init(red: 255/255, green: 192/255, blue: 19/255, alpha: 1.0)
        } else {
            addButton.setTitle( NSLocalizedString("Add to List",comment:""), for: .normal)
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
            sender.setTitle(NSLocalizedString("Remove from List",comment:""), for: .normal)
            item?.quantity = 1
            sender.backgroundColor = UIColor.init(red: 255/255, green: 192/255, blue: 19/255, alpha: 1.0)
        } else {
            sender.setTitle(NSLocalizedString("Add to List",comment:""), for: .normal)
            item?.quantity = 0
            sender.backgroundColor = UIColor.init(red: 92/255, green: 162/255, blue: 41/255, alpha: 1.0)
        }
        quantityLabel.text = "\(item!.quantity)"
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
