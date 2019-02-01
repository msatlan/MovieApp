//
//  FavoritesViewController.swift
//  MovieApp
//
//  Created by Marko Satlan on 29/01/2019.
//  Copyright © 2019 Marko Satlan. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    let tableView = UITableView()
    
    // MARK: - View life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GetMoviesRequest().execute(userID: DataManager.shared.user?.id) { (movies, error) in
            if let error = error {
                self.showErrorAlert(withError: error)
                return
            }
            
            DataManager.shared.favoriteMovies = movies
            
            self.tableView.reloadData()
        }
        
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 49)
        
        self.view.addSubview(tableView)
        
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DataManager.shared.favoriteMovies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        
        let movie = DataManager.shared.favoriteMovies?[indexPath.row]
        
        cell.onDidTapButton = {
            FavouriteMovieRequest().execute(userID: DataManager.shared.user!.id, movieID: movie!.id, favorite: false, completion: { (error) in
                if let error = error {
                    self.showErrorAlert(withError: error)
                    return
                }
                
                DataManager.shared.favoriteMovies!.removeAll {$0.id == movie?.id}
                
                self.tableView.reloadData()
            })
        }
        
        if let movie = movie {
            cell.movieNameLabel.text = movie.name
        }
        
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MovieTableViewCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = DataManager.shared.favoriteMovies![indexPath.row]
        let movieDetailsViewController = MovieDetailsViewController()
        movieDetailsViewController.selectedMovie = selectedMovie
        navigationController?.pushViewController(movieDetailsViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
