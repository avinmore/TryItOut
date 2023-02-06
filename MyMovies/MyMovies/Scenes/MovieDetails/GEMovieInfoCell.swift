//
//  GEMovieInfoCell.swift
//  MyMovies
//
//  Created by Avin on 6/2/23.
//

import Foundation
import UIKit
import Kingfisher

class GEMovieInfoCell: UITableViewCell {
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var title: UILabel!
    
    func loadCelldata(_ movie: GEMovieDetailModel?) {
        guard let movie = movie else { return }
        title.text = movie.title
        genre.text = movie.genres?.map { $0.name }.joined(separator: " * ")
    }
}
