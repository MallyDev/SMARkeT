//
//  Product+CoreDataProperties.swift
//  
//
//  Created by Francesco Caposiena on 04/04/2017.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product");
    }

    //Proprietà del prodotto
    @NSManaged public var barCode: String? //codice univoco per prodotto
    @NSManaged public var name: String?
    @NSManaged public var department: String?
    @NSManaged public var descr: String?
    @NSManaged public var price: Float
    @NSManaged public var imageUrl: String?
    @NSManaged public var newPrice: Float
    @NSManaged public var weight: Float
    
    //Proprietà per la gestione
    @NSManaged public var isDaily: Bool
    @NSManaged public var inTheList: Bool
    @NSManaged public var bought: Bool
    @NSManaged public var favourite: Bool
    @NSManaged public var quantity: Int32
}
