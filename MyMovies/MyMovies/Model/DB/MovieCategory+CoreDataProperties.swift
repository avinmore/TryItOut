//
//  MovieCategory+CoreDataProperties.swift
//  
//
//  Created by Avin on 6/2/23.
//
//

import Foundation
import CoreData


extension MovieCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieCategory> {
        return NSFetchRequest<MovieCategory>(entityName: "MovieCategory")
    }

    @NSManaged public var type: String?
    @NSManaged public var id: Int64

}
