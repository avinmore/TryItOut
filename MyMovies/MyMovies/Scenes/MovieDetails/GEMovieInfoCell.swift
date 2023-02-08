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
    
    var delegate: GEMakeMoviefavorite?
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var avgVote: UILabel!
    @IBOutlet weak var voteCount: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var languagesSpoken: UILabel!
    let toastLabel = UILabel()
    var movie: GEMovieDetailModel?
    
    func loadCelldata(_ movie: GEMovieDetailModel?) {
        guard let movie = movie else { return }
        self.movie = movie
        title.text = (movie.title ?? "") + " " + (movie.tagline ?? "")
        genre.text = movie.genres?.map { $0.name }.joined(separator: " * ")
        avgVote.text = "\(movie.voteAverage ?? 0)"
        voteCount.text = "\(movie.voteCount ?? 0)"
        status.text = movie.status ?? ""
        releaseDate.text = formatDate(movie.releaseDate ?? "")
        favoriteButton.setBackgroundImage(UIImage(named: "fvorites"), for: .normal)
        overview.text = movie.overview
        languagesSpoken.text = movie.spokenLanguages?.map({ language in
            language.name ?? ""
        }).joined(separator: ", ")
        languagesSpoken.text = "Language(s) : " + (languagesSpoken.text ?? "None")
        overview.text = "Overview:\n" + (overview.text ?? "None")
    }
    @IBAction func favoriteClicked(_ sender: UIButton) {
        let status = delegate?.updateFavoriteStatus(self.movie?.id)
        var statusMessage = ""
        switch status {
        case .favorite:
            statusMessage = "\(self.movie?.title ?? "") added to your favorite list"
        case .yetToFavorite:
            statusMessage = "\(self.movie?.title ?? "") is removed from your favorite list"
        case .na:
            statusMessage = "Please try again to make it favorite"
        case .none:
            statusMessage = "Please try again to make it favorite"
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                sender.transform = CGAffineTransform.identity
            }
        }
        
        MyMoviesUtils.showToast(statusMessage, duration: 2)
    }

    func formatDate(_ stringDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: stringDate)
        dateFormatter.dateFormat = "dd/MMM/yyyy"
        guard let date = date else { return "" }
        return dateFormatter.string(from: date)
    }
}
