//
//  MovieDetail+CoreDataProperties.swift
//  
//
//  Created by Avin on 6/2/23.
//
//

import Foundation
import CoreData


extension MovieDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieDetail> {
        return NSFetchRequest<MovieDetail>(entityName: "MovieDetail")
    }

    @NSManaged public var adult: Bool
    @NSManaged public var backdrop_path: String?
    @NSManaged public var budget: Int64
    @NSManaged public var genres: Data?
    @NSManaged public var homepage: String?
    @NSManaged public var id: Int64
    @NSManaged public var imdb_id: String?
    @NSManaged public var original_language: String?
    @NSManaged public var original_title: String?
    @NSManaged public var overview: String?
    @NSManaged public var popularity: Float
    @NSManaged public var poster_path: String?
    @NSManaged public var release_date: String?
    @NSManaged public var revenue: Int64
    @NSManaged public var runtime: Int64
    @NSManaged public var spoken_languages: Data?
    @NSManaged public var status: String?
    @NSManaged public var tagline: String?
    @NSManaged public var title: String?
    @NSManaged public var video: Bool
    @NSManaged public var vote_average: Float
    @NSManaged public var vote_count: Int64
    @NSManaged public var genre_list: String?

}
