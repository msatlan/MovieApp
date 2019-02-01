//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Marko Satlan on 01/02/2019.
//  Copyright © 2019 Marko Satlan. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    var selectedMovie: Movie?
    
    let nameLabel = UILabel()
    let imageView = UIImageView()
    let genresLabel = UILabel()
    let yearLabel = UILabel()
    let directorLabel = UILabel()
    let mainStarLabel = UILabel()
    let descriptionLabel = UILabel()
    let favoritedLabel = UILabel()

// MARK: - View life cycle
    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(false, animated: false)
    }
    
    func configureUI() {
        nameLabel.text = selectedMovie!.name
        view.addSubview(nameLabel)
        
        view.addSubview(imageView)
        
        yearLabel.text = String(selectedMovie!.year)
        view.addSubview(yearLabel)
        
        directorLabel.text = selectedMovie!.director
        view.addSubview(directorLabel)
        
        mainStarLabel.text = selectedMovie!.mainStar
        view.addSubview(mainStarLabel)
        
        descriptionLabel.text = selectedMovie!.description
        view.addSubview(descriptionLabel)
        
        favoritedLabel.text = String(selectedMovie!.timesFavorited)
        view.addSubview(favoritedLabel)
    }
}


