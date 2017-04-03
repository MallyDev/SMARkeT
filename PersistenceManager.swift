//
//  PersistenceManager.swift
//  App
//
//  Created by Francesco Caposiena on 01/04/2017.
//  Copyright © 2017 Francesco Caposiena. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PersistenceManager{
    static let name="Product"
    
    static func getContext() -> NSManagedObjectContext{
        let appDelegate=UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    static func newEmptyProd() ->Product{
        let context=getContext()
        
        let product = NSEntityDescription.insertNewObject(forEntityName: name, into: context) as! Product
        product.name="Pippo"
        product.barCode=""
        product.descr=""
        product.price=0.0
        product.favourite=false
        product.inTheList=false
        product.quantity=0
        product.weight=0.0
        product.newPrice=0.0
        product.department=""
        
        return product
    }
    
    static func fetchAll()->[Product]{
        let context = getContext()
        var products=[Product]()
        let fetchRequest = NSFetchRequest<Product>(entityName: name)
        //fetchRequest.predicate = NSPredicate(format: "favourite==true")
        
        do{
            try products=context.fetch(fetchRequest)
        } catch let error as NSError{
            fatalError("Error in fetching the favourites. \(error)")
        }
        return products
    }
    
    static func fetchFavourites() -> [Product]{
        let context = getContext()
        var products=[Product]()
        let fetchRequest = NSFetchRequest<Product>(entityName: name)
        fetchRequest.predicate = NSPredicate(format: "favourite==true")
        
        do{
            try products=context.fetch(fetchRequest)
        } catch let error as NSError{
            fatalError("Error in fetching the favourites. \(error)")
        }
        return products
    }
    
    static func fetchList() -> [Product]{
        
        let context=getContext()
        var products=[Product]()
        let fetchRequest=NSFetchRequest<Product>(entityName: name)
        fetchRequest.predicate = NSPredicate(format: "inTheList==true")
        
        do{
            try products=context.fetch(fetchRequest)
        }catch let error as NSError{
            fatalError("Error in fetching the list. \(error)")
        }
        return products
    }
    
    static func fetchOffers () -> [Product]{
        
        let context = getContext()
        var products = [Product]()
        let fetchRequest=NSFetchRequest<Product>(entityName: name)
        fetchRequest.predicate = NSPredicate(format: "newPrice != 0")
        
        do {
            try products=context.fetch(fetchRequest)
        } catch let error as NSError {
            fatalError("Error in fetching products if offer. \(error)")
        }
        return products
    }
    
    static func deleteProduct (product: Product){
        let context = getContext()
        context.delete(product)
    }
    
    static func saveContext(){
        let context = getContext()
        
        do {
            try context.save()
        } catch let error as NSError {
            fatalError("Unresolved error in saving context. \(error)")
        }
    }
    
}
