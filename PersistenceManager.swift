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
        product.quantity=1
        product.weight=0.0
        product.newPrice = -1
        product.department = "Reparto"
        product.imageUrl = "https://cdn.pixabay.com/photo/2015/10/31/12/00/question-1015308_1280.jpg"
        
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
    
    static func fetchDaily() -> [Product]{
        
        let context=getContext()
        var products=[Product]()
        let fetchRequest=NSFetchRequest<Product>(entityName: name)
        fetchRequest.predicate = NSPredicate(format: "isDaily==true")
        
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
        let fetchRequest = NSFetchRequest<Product>(entityName: name)
        fetchRequest.predicate = NSPredicate(format: "newPrice > 0")
        
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
    
    static func searchProduct (barcode: String) -> ([Product],Bool) {
        let context = getContext()
        var product : [Product]
        var result : Bool = false
        
        let fetchRequest = NSFetchRequest<Product>(entityName: name)
        fetchRequest.predicate = NSPredicate(format: "barCode == \(barcode)")
        
        do {
            try product = context.fetch(fetchRequest)
        } catch let error as NSError {
            fatalError("Error in fetching product by its barcode. \(error)")
        }
        
        if product.count != 0{
            result = true
        }
        
        return (product,result)
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
