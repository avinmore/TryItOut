//
//  FavoriteMovies+CoreDataProperties.swift
//  
//
//  Created by Avin on 6/2/23.
//
//

import Foundation
import CoreData


extension FavoriteMovies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMovies> {
        return NSFetchRequest<FavoriteMovies>(entityName: "FavoriteMovies")
    }

    @NSManaged public var id: Int64

}
