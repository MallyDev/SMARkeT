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
    @IBOutlet weak var newPriceLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var quantityLabel: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
