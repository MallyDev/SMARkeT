//
//  Offers.swift
//  App
//
//  Created by Francesco Caposiena on 02/04/2017.
//  Copyright © 2017 Francesco Caposiena. All rights reserved.
//

import Foundation

class Offers {
    
    var percentage: Int
    
    init(percentage: Int){
        self.percentage=percentage
    }
    
    func calculateNewPrice(oldPrice: Float) -> Float{
        
        var temp: Float
        temp = (Float(percentage)/100.0) * oldPrice
        return oldPrice-temp
        
    }
    
    
}