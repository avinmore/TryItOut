//
//  CGMovieCollectionViewCell.swift
//  MyMovies
//
//  Created by Avin on 5/2/23.
//

import Foundation
import UIKit
import Kingfisher
// https://image.tmdb.org/t/p/original/ysJte1iqN8pFQ470tumnViB1wHP.jpg
class CGMovieCollectionViewCell: UICollectionViewCell {
    //poster, title, genre, release date (dd/mmm/yyyy), vote average and vote count
    let moviewImageView = UIImageView()
    let stackView = UIStackView()
    let topStack = UIStackView()
    let bottomStack = UIStackView()
    let title = UILabel()
    let genre = UILabel()
    let release = UILabel()
    let voteAverage = UILabel()
    let voteCount = UILabel()
    
    let voteAvgStack = UIStackView()
    let voteAvgIcon = UIImageView()
    let voteAvgLabel = UILabel()
    let voteCountStackView = UIStackView()
    let voteCountIcon = UIImageView()
    let voteCountLabel = UILabel()
    
    let dateFormatter = DateFormatter()
    
    let titleView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        moviewImageView.contentMode = .scaleToFill
        
        stackView.addArrangedSubview(moviewImageView)
        stackView.axis = .vertical
        stackView.distribution = .fill
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stackView.contentMode = .scaleAspectFill
        
        //Bottom title view
        titleView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleView.backgroundColor = .white
        stackView.addArrangedSubview(titleView)
        
        
        
        //Top label config
        voteAvgStack.axis = .horizontal
        voteAvgStack.alignment = .center
        voteAvgStack.distribution = .fill
        voteAvgStack.spacing = 0
        
        voteAvgIcon.contentMode = .scaleAspectFit
        
        voteAvgLabel.font = UIFont.systemFont(ofSize: 13)
        voteAvgLabel.numberOfLines = 0
        voteAvgLabel.textColor = .white
        voteAvgLabel.adjustsFontSizeToFitWidth = true
        
        voteAvgIcon.image = UIImage(named: "movie-rating")
        voteAvgStack.addArrangedSubview(voteAvgIcon)
        voteAvgStack.addArrangedSubview(voteAvgLabel)
        
        voteCountStackView.axis = .horizontal
        voteCountStackView.alignment = .center
        voteCountStackView.distribution = .fill
        voteCountStackView.spacing = 0
        voteCountIcon.contentMode = .scaleAspectFit
        
        voteCountLabel.font = UIFont.systemFont(ofSize: 13)
        voteCountLabel.numberOfLines = 0
        voteCountLabel.adjustsFontSizeToFitWidth = true
        voteCountLabel.textColor = .white
        voteCountIcon.image = UIImage(named: "vote-count")
        voteCountStackView.addArrangedSubview(voteCountIcon)
        voteCountStackView.addArrangedSubview(voteCountLabel)
        
        //bottom label config
        genre.font = UIFont.boldSystemFont(ofSize: 10)
        genre.numberOfLines = 0
        genre.textColor = .white
        genre.adjustsFontSizeToFitWidth = true
        
        release.font = UIFont.systemFont(ofSize: 8)
        release.numberOfLines = 0
        release.textColor = .white
        release.minimumScaleFactor = 0.6
        release.textAlignment = .right

        
        /// Top and Bottom lables
        topStack.axis = .horizontal
        topStack.alignment = .leading
        topStack.distribution = .equalSpacing
        topStack.spacing = 8
        
        bottomStack.axis = .horizontal
        bottomStack.alignment = .leading
        bottomStack.distribution = .fillProportionally
        bottomStack.spacing = 8
        
        topStack.addArrangedSubview(voteAvgStack)
        topStack.addArrangedSubview(voteCountStackView)
        addSubview(topStack)
        topStack.translatesAutoresizingMaskIntoConstraints = false
        topStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        topStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        topStack.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        topStack.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        bottomStack.addArrangedSubview(genre)
        bottomStack.addArrangedSubview(release)
        addSubview(bottomStack)
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        bottomStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        bottomStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
        bottomStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -35).isActive = true
        bottomStack.heightAnchor.constraint(equalToConstant: 20).isActive = true
        //add gradients
        addtopBottomBackgroundGradiant( .black.withAlphaComponent(0.5), color2: .clear )
        addBottomTopBackgroundGradiant(.clear, color2: .black.withAlphaComponent(0.5))
    }
    lazy var topStackBackgroundView: UIView = {
        topStackBackgroundView = UIView(frame: bounds)
        return topStackBackgroundView
    }()
    
    lazy var bottomViewStackBackgroundView: UIView = {
        bottomViewStackBackgroundView = UIView(frame: bounds)
        return bottomViewStackBackgroundView
    }()
    
    lazy var topCAGradientLayer: CAGradientLayer = {
        topCAGradientLayer = CAGradientLayer()
        return topCAGradientLayer
    }()
    
    lazy var bottomCAGradientLayer: CAGradientLayer = {
            bottomCAGradientLayer = CAGradientLayer()
        return topCAGradientLayer
    }()
    
    
    func addtopBottomBackgroundGradiant(_ color1: UIColor, color2: UIColor, cornerRadius: CGFloat = 10) {
        topStackBackgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        topCAGradientLayer.frame = CGRect(x: 0, y: -8, width: frame.width, height: 50)
        topCAGradientLayer.colors = [color1.cgColor, color1.cgColor, color2.cgColor, color2.cgColor]
        topStackBackgroundView.layer.insertSublayer(topCAGradientLayer, at: 0)
        topStackBackgroundView.layer.cornerRadius = cornerRadius
        topStack.insertSubview(topStackBackgroundView, at: 0)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        topCAGradientLayer.removeFromSuperlayer()
        bottomCAGradientLayer.removeFromSuperlayer()
        topStackBackgroundView.removeFromSuperview()
        bottomViewStackBackgroundView.removeFromSuperview()
        
    }
    func addBottomTopBackgroundGradiant(_ color1: UIColor, color2: UIColor, cornerRadius: CGFloat = 10) {
        topStackBackgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        topCAGradientLayer.frame = CGRect(x: -8, y: -30, width: frame.width + 16, height: 56)
        topCAGradientLayer.colors = [color1.cgColor, color1.cgColor, color2.cgColor, color2.cgColor]
        topStackBackgroundView.layer.insertSublayer(topCAGradientLayer, at: 0)
        topStackBackgroundView.layer.cornerRadius = cornerRadius
        bottomStack.insertSubview(topStackBackgroundView, at: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadCellData(_ movie: GEMovie?) {
        guard let movie = movie else {
            return
        }
        addtopBottomBackgroundGradiant( .black.withAlphaComponent(0.5), color2: .clear )
        addBottomTopBackgroundGradiant(.clear, color2: .black.withAlphaComponent(0.5))
        loadImage(movie.posterPath)
        voteAvgLabel.text = "\(movie.voteAverage)"
        voteCountLabel.text = "\(movie.voteCount)"
        release.text = formatDate(movie.releaseDate)
        let genres = movie.genreIDS.map({ GEDatabaseManager.shared.fetchGenreFor($0) }).joined(separator: " • ")
        genre.text = genres
    }
    
    func formatDate(_ stringDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: stringDate)
        dateFormatter.dateFormat = "dd/MMM/yyyy"
        guard let date = date else { return "" }
        return dateFormatter.string(from: date)
    }
    
    func loadImage(_ posterName: String?) {
        guard let posterName = posterName else {
            // add default poster
            return
        }
        let url = URL(string: "https://image.tmdb.org/t/p/original/" + posterName)
        moviewImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "loading-movie"),
            options: [
                .processor(DownsamplingImageProcessor(size: frame.size)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
    }
    
    
}
