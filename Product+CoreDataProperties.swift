//
//  Product+CoreDataProperties.swift
//  App
//
//  Created by Francesco Caposiena on 01/04/2017.
//  Copyright © 2017 Francesco Caposiena. All rights reserved.
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product");
    }

    @NSManaged public var name: String?
    @NSManaged public var descr: String?
    @NSManaged public var weight: Float
    @NSManaged public var quantity: Int16
    @NSManaged public var price: Float
    @NSManaged public var inTheList: Bool
    @NSManaged public var favourite: Bool
    @NSManaged public var barCode: String?

}
