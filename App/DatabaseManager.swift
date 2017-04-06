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
        
        //svuota coreData
        for product in PersistenceManager.fetchAll(){
         PersistenceManager.deleteProduct(product: product)
         }
         PersistenceManager.saveContext()
        
        //Carica dati
        item.observeSingleEvent(of: .value, with: {(snap) in
            let db = snap.value as! NSDictionary?
            if (db != nil) {
                let keys = db?.allKeys as! [String]
                
                for barcode in keys {
                    let prod = PersistenceManager.newEmptyProd()
                    item.child(barcode).observeSingleEvent(of: .value, with: {(snap) in
                        let product_read = snap.value as! NSDictionary?
                        
                        //Inizializza prodotto
                        prod.barCode = barcode
                        prod.name = product_read!.value(forKey: "name") as! String?
                        prod.department = product_read!.value(forKey: "department") as! String?
                        prod.descr = product_read!.value(forKey: "descr") as! String?
                        prod.price = product_read!.value(forKey: "price") as! Float
                        prod.imageUrl = product_read!.value(forKey: "url") as! String?
                    })
                    PersistenceManager.saveContext()
                }
            }
        })
    }
}
