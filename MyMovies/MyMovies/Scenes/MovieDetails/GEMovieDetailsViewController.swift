//
//  GEMovieDetailsViewController.swift
//  MyMovies
//
//  Created by Avin on 4/2/23.
//

import Foundation
import UIKit
class GEMovieDetailsViewController: GEMoviesBaseViewController {
    @IBOutlet weak var tableView: UITableView!
    let viewModel = GEMovieDetailsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.setupMovieDetailDataSync()
        let header = GEMoviePosterHeader(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width * 0.5))
        tableView.tableHeaderView = header
        tableView.backgroundColor = .black
    }
}

extension GEMovieDetailsViewController: UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemInMovieDetailsSections(section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GEMovieInfoCell", for: indexPath) as? GEMovieInfoCell else {
            assertionFailure()
            return GEMovieInfoCell()
        }
        let movieDetails = viewModel.movieDetailsForIndexPath(indexPath)
        if let header = tableView.tableHeaderView as? GEMoviePosterHeader {
            header.loadPosterImage(movieDetails?.posterPath)
            header.loadBackdropImage(movieDetails?.backdropPath)
        }
        cell.loadCelldata(movieDetails)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = tableView.tableHeaderView as? GEMoviePosterHeader else { return }
        header.scrollViewDidScroll(tableView)
    }
}
extension GEMovieDetailsViewController: GERefreshEventProtocol {
    func updateUI() {
        tableView.reloadData()
    }
}
