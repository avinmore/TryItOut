//
//  MyMoviesUtils.swift
//  MyMovies
//
//  Created by Avin on 8/2/23.
//

import Foundation
import UIKit
import SystemConfiguration

class MyMoviesUtils {
    
    class func showToast(_ statusMessage: String, duration: TimeInterval) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 16)
        toastLabel.text = statusMessage
        toastLabel.alpha = 0.0
        toastLabel.numberOfLines = 0
        guard let keyWindow = UIApplication.shared.connectedScenes
          .filter({$0.activationState == .foregroundActive})
          .map({$0 as? UIWindowScene})
          .compactMap({$0})
          .first?.windows
          .filter({$0.isKeyWindow}).first else {
            return
        }
        
        keyWindow.addSubview(toastLabel)

        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.bottomAnchor.constraint(equalTo: keyWindow.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        toastLabel.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor, constant: 10).isActive = true
        toastLabel.trailingAnchor.constraint(equalTo: keyWindow.trailingAnchor, constant: -10).isActive = true
        toastLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: duration, delay: 2.0, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: nil)
        }
    }
}

struct ThemeManager {
    static let textColor = UIColor.red
    static let navTintColor = UIColor.red
    static let navTitleColor = UIColor.red
    static let tabBarSelectedTextColor = UIColor.red
    static let tabBarUnSelectedTextColor = UIColor.white
    static let backgroundColor = UIColor.black
    static let barTintColor = UIColor.black
    static let searchBarTintColor = UIColor.white
    static let movieCardBorderColor = UIColor.white
    
    static let titleTextColor = UIColor.white
    static let voteAvgLabelTextColor = UIColor.white
    static let genreTextColor = UIColor.white
    static let releaseTextColor = UIColor.white
    static let voteCountColor = UIColor.white
}

struct AssetManager {
    static let loadingMovie = "loading-movie"
    static let voteCount = "vote-count"
    static let movieRating = "movie-rating"
}


public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
}
