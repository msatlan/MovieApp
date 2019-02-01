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
        
        configureUI()
        addConstraints()
    }

    func configureUI() {
        nameLabel.text = "Name: \(selectedMovie!.name)"
        view.addSubview(nameLabel)
        
        view.addSubview(imageView)
        
        var genresArray: [String] = []
        for genre in selectedMovie!.genres {
            genresArray.append(genre.name)
        }
        
        genresLabel.text = "Genres: \(genresArray.joined(separator: ", "))"
        view.addSubview(genresLabel)
        
        yearLabel.text = "Year: \(String(selectedMovie!.year))"
        view.addSubview(yearLabel)
        
        directorLabel.text = "Director: \(selectedMovie!.director)"
        view.addSubview(directorLabel)
        
        mainStarLabel.text = "Main star: \(selectedMovie!.mainStar)"
        view.addSubview(mainStarLabel)
        
        descriptionLabel.text = "Description: \(selectedMovie!.description)"
        descriptionLabel.textAlignment = .left
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
        view.addSubview(descriptionLabel)
        
        favoritedLabel.text = "Times favorited: 5"
        view.addSubview(favoritedLabel)
    }
    
    func addConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            nameLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            nameLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 40)
            ])
        
        genresLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genresLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            genresLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            genresLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            genresLabel.heightAnchor.constraint(equalToConstant: 40)
            ])
        
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            yearLabel.topAnchor.constraint(equalTo: genresLabel.bottomAnchor, constant: 5),
            yearLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            yearLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            yearLabel.heightAnchor.constraint(equalToConstant: 40)
            ])
        
        directorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            directorLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 5),
            directorLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            directorLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            directorLabel.heightAnchor.constraint(equalToConstant: 40)
            ])
        
        mainStarLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStarLabel.topAnchor.constraint(equalTo: directorLabel.bottomAnchor, constant: 5),
            mainStarLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            mainStarLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            mainStarLabel.heightAnchor.constraint(equalToConstant: 40)
            ])
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: mainStarLabel.bottomAnchor, constant: 5),
            descriptionLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            descriptionLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
            ])
        
        favoritedLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favoritedLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            favoritedLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            favoritedLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
            ])
    }
}


