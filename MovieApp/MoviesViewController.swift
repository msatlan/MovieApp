//
//  MoviesViewController.swift
//  MovieApp
//
//  Created by Marko Satlan on 29/01/2019.
//  Copyright © 2019 Marko Satlan. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(frame: CGRect(x: 50, y: 200, width: 100, height: 70))
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.backgroundColor = UIColor.blue
        self.view.addSubview(button)
        
        view.backgroundColor = UIColor.red
        
        GetMoviesRequest().execute(userID: DataManager.shared.user?.id) { (movies, error) in
            if let error = error {
                self.showErrorAlert(withError: error)
                return
            }
            
            DataManager.shared.movies = movies
        }
    }

    @objc func buttonAction() {
        FavouriteMovieRequest().execute(userID: 19, movieID: 2, favorite: true) { (error) in
            if let error = error {
                self.showErrorAlert(withError: error)
                return
            }
        }
        
        FavouriteMovieRequest().execute(userID: 19, movieID: 5, favorite: true) { (error) in
            if let error = error {
                self.showErrorAlert(withError: error)
                return
            }
        }
        
        FavouriteMovieRequest().execute(userID: 19, movieID: 8, favorite: true) { (error) in
            if let error = error {
                self.showErrorAlert(withError: error)
                return
            }
        }
    }

}
