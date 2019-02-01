//
//  MovieTableViewCell.swift
//  MovieApp
//
//  Created by Marko Satlan on 01/02/2019.
//  Copyright © 2019 Marko Satlan. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    static let cellHeight = CGFloat(110)
    
    var downloadTask: URLSessionDownloadTask?
    var onDidTapButton: (()->())?
    
    let thumbnailImageView = UIImageView()
    let movieNameLabel = UILabel()
    let favoriteButton = UIButton()
    
    var isFavorite = false
    
// MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        downloadTask?.cancel()
        downloadTask = nil
        
        configureUI()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// MARK: - Methods
    func configureUI() {
        thumbnailImageView.backgroundColor = UIColor.lightGray
        contentView.addSubview(thumbnailImageView)
        
        movieNameLabel.textAlignment = .center
        movieNameLabel.numberOfLines = 0
        contentView.addSubview(movieNameLabel)
        
        favoriteButton.setImage(UIImage(named: "StarEmpty"), for: .normal)
        favoriteButton.imageEdgeInsets = UIEdgeInsets(top: 30,left: 10,bottom: 30,right: 10)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        contentView.addSubview(favoriteButton)
    }
    
    func addConstraints() {
        let thumbnailImageViewWidth = CGFloat(80)
        let thumbnailImageViewHeight = CGFloat(100)
        
        let movieNameLabelWidth = CGFloat(160)
        
        let margin = CGFloat(5)
        let spaceing = CGFloat(10)
        
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            thumbnailImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: margin),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: thumbnailImageViewHeight),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: thumbnailImageViewWidth)
            ])
        
        movieNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            movieNameLabel.leftAnchor.constraint(equalTo: thumbnailImageView.rightAnchor, constant: spaceing),
            movieNameLabel.heightAnchor.constraint(equalToConstant: thumbnailImageViewHeight),
            movieNameLabel.widthAnchor.constraint(equalToConstant: movieNameLabelWidth)
            ])
        
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            favoriteButton.leftAnchor.constraint(equalTo: movieNameLabel.rightAnchor, constant: spaceing),
            favoriteButton.heightAnchor.constraint(equalToConstant: thumbnailImageViewHeight),
            favoriteButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -margin)
            ])
    }
    
    func downloadImage(for movie: Movie) {
        if let image = URL(string: movie.thumbnailURL) {
            downloadTask = thumbnailImageView.loadImage(url: image)
        } else {
            thumbnailImageView.image = UIImage(named: "")
        }
    }
    
    @objc func favoriteButtonTapped() {
        onDidTapButton?()
    }

}
