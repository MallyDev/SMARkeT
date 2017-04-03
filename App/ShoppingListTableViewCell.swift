//
//  ShoppingListTableViewCell.swift
//  App
//
//  Created by Mario Cantalupo on 03/04/2017.
//  Copyright © 2017 Francesco Caposiena. All rights reserved.
//

import UIKit

class ShoppingListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    //TODO: reparto
    //TODO: peso/unità
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: NSLayoutConstraint!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var newPriceLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addButton(_ sender: Any) {
        var value = Int.init(quantityLabel.text!)!
        value += 1
        quantityLabel.text = "\(value)"
    }
    
    @IBAction func removeButton(_ sender: Any) {
        var value = Int.init(quantityLabel.text!)!
        if value >= 0 {
           value -= 1 
        }
        quantityLabel.text = "\(value)"
    }
    
}
