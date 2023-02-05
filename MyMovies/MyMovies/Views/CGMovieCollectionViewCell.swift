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
    
    let moviewImageView = UIImageView()
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        moviewImageView.contentMode = .scaleToFill
        
        stackView.addArrangedSubview(moviewImageView)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stackView.contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
