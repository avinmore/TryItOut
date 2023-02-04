//
//  Genre+CoreDataProperties.swift
//  
//
//  Created by Avin on 4/2/23.
//
//

import Foundation
import CoreData


extension Genre {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Genre> {
        return NSFetchRequest<Genre>(entityName: "Genre")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?

}
