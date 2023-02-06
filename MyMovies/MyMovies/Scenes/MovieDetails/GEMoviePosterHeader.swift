//
//  GEMoviePosterHeader.swift
//  MyMovies
//
//  Created by Avin on 6/2/23.
//

import UIKit
import Kingfisher
class GEMoviePosterHeader: UIView {
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    lazy var imageView: UIImageView = {
        let iView = UIImageView()
        iView.contentMode = .scaleAspectFill
        iView.clipsToBounds = true
        return iView
    }()
    
    lazy var posterImageView: UIImageView = {
        let iView = UIImageView(frame: CGRect(x: 16, y: frame.size.height - 75, width: 110, height: 150))
        iView.contentMode = .scaleToFill
        iView.layer.borderColor = UIColor.white.cgColor
        iView.layer.borderWidth = 2.0
        return iView
    }()
    
    private var imageViewHeight = NSLayoutConstraint()
    private var imageViewBottom = NSLayoutConstraint()
    private var containerView = UIView()
    private var containerViewHeight = NSLayoutConstraint()
    
    func loadPosterImage(_ posterName: String?) {
        guard let posterName = posterName else {
            return
        }
        let url = URL(string: "https://image.tmdb.org/t/p/original/" + posterName)
        posterImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "loading-movie"),
            options: [
                .processor(DownsamplingImageProcessor(size: frame.size)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
    }
    
    func loadBackdropImage(_ posterName: String?) {
        guard let posterName = posterName else {
            return
        }
        let url = URL(string: "https://image.tmdb.org/t/p/original/" + posterName)
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "loading-movie"),
            options: [
                .processor(DownsamplingImageProcessor(size: frame.size)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
    }
    
    func createViews() {
        addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(posterImageView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: containerView.widthAnchor),
            centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        containerViewHeight = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerViewHeight.isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewBottom = imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        imageViewBottom.isActive = true
        imageViewHeight = imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        imageViewHeight.isActive = true
        
        //posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        //posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 70).isActive = true
        //posterImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        //imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        containerViewHeight.constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        imageViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
        
    }
    
}
