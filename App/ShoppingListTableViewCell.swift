//
//  ShoppingListTableViewCell.swift
//  App
//
//  Created by Mario Cantalupo on 03/04/2017.
//  Copyright © 2017 Francesco Caposiena. All rights reserved.
//

import UIKit

class ShoppingListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var name: UILabel!
    //TODO: reparto
    //TODO: peso/unità
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var quantity: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
