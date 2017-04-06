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

    @NSManaged public var barCode: String?
    @NSManaged public var department: String?
    @NSManaged public var descr: String?
    @NSManaged public var favourite: Bool
    @NSManaged public var inTheList: Bool
    @NSManaged public var name: String?
    @NSManaged public var newPrice: Float
    @NSManaged public var price: Float
    @NSManaged public var quantity: Int32
    @NSManaged public var weight: Float
    @NSManaged public var imageUrl: String?
    @NSManaged public var bought: Bool
}
