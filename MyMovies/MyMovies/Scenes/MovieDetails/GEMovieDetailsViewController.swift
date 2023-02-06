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
        viewModel.setupDataSync()
        let header = GEMoviePosterHeader(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width * 0.5))
        header.imageView.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/original/faXT8V80JRhnArTAeYXz0Eutpv9.jpg"))
        tableView.tableHeaderView = header
    }
}

extension GEMovieDetailsViewController: UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GEMovieInfoCell", for: indexPath) as? GEMovieInfoCell else {
            assertionFailure()
            return GEMovieInfoCell()
        }
        cell.backgroundColor = .random
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
