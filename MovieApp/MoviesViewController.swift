//
//  MoviesViewController.swift
//  MovieApp
//
//  Created by Marko Satlan on 29/01/2019.
//  Copyright © 2019 Marko Satlan. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {
    let tableView = UITableView()
    
// MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GetMoviesRequest().execute { (movies, error) in
            if let error = error {
                self.showErrorAlert(withError: error)
                return
            }
            
            DataManager.shared.movies = movies

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

extension MoviesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DataManager.shared.movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
    
        let movie = DataManager.shared.movies![indexPath.row]
    
        cell.onDidTapButton = {
            print(movie.id)
            FavouriteMovieRequest().execute(userID: DataManager.shared.user!.id, movieID: movie.id, favorite: true, completion: { (error) in
                if let error = error {
                    self.showErrorAlert(withError: error)
                    return
                }
                
                DataManager.shared.favoriteMovies?.append(movie)
            })
        }
        
        cell.movieNameLabel.text = movie.name
        
        cell.downloadImage(for: movie)
        
        return cell
    }
}

extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = DataManager.shared.movies![indexPath.row]
        let movieDetailsViewController = MovieDetailsViewController()
        movieDetailsViewController.selectedMovie = selectedMovie
        navigationController?.pushViewController(movieDetailsViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return MovieTableViewCell.cellHeight
    }
}
