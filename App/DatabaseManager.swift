//
//  DatabaseManager.swift
//  App
//
//  Created by Ivan Colucci on 05/04/2017.
//  Copyright © 2017 Francesco Caposiena. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

class DatabaseManager {
    
    static func loadDatabase () {
        let ref = FIRDatabase.database().reference()
        let item = ref.child("Prodotti")
        
        
        //Carica dati
        item.observeSingleEvent(of: .value, with: {(snap) in
            let db = snap.value as! NSDictionary?
            if (db != nil) {
                let keys = db?.allKeys as! [String]
                
                for barcode in keys {
                    let result = PersistenceManager.searchProduct(barcode: barcode)
                    if !result.1 {
                        item.child(barcode).observeSingleEvent(of: .value, with: {(snap) in
                            let product_read = snap.value as! NSDictionary?
                        
                            //Inizializza prodotto
                            let prod = PersistenceManager.newEmptyProd()
                            prod.barCode = barcode
                            prod.name = product_read!.value(forKey: "name") as! String?
                            prod.department = product_read!.value(forKey: "department") as! String?
                            prod.descr = product_read!.value(forKey: "descr") as! String?
                            prod.price = product_read!.value(forKey: "price") as! Float
                            prod.imageUrl = product_read!.value(forKey: "url") as! String?
                            if(product_read!.allKeys.contains(where: { $0 as! String == "newprice"})){
                                prod.newPrice=product_read!.value(forKey: "newprice") as! Float
                            }
                            PersistenceManager.saveContext()
                        })
                    } else {
                        item.child(barcode).observeSingleEvent(of: .value, with: {(snap) in
                            let product_read = snap.value as! NSDictionary?
                            let prod = result.0
                            //Aggiorna prodotto se i campi sono cambiati
                            var temp = product_read!.value(forKey: "name") as! String?
                            if temp != prod.name {
                                prod.name = temp
                            }
                            temp = product_read!.value(forKey: "department") as! String?
                            if temp != prod.department{
                                prod.department = temp
                            }
                            temp = product_read!.value(forKey: "descr") as! String?
                            if temp != prod.descr {
                                prod.descr = temp
                            }
                            var temp2 = product_read!.value(forKey: "price") as! Float
                            if temp2 != prod.price {
                                prod.price = temp2
                            }
                            temp = product_read!.value(forKey: "url") as! String?
                            if temp != prod.imageUrl {
                                prod.imageUrl = temp
                            }
                            
                            PersistenceManager.saveContext()
                        })
                    }
                }
            }
        })
    }
}
