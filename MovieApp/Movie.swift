//
//  Movie.swift
//  MovieApp
//
//  Created by Marko Satlan on 30/01/2019.
//  Copyright © 2019 Marko Satlan. All rights reserved.
//

import Foundation

struct Genre {
    var name: String
    
    init?(json: [String : Any]) {
        guard
            let name = json["name"] as? String
            else {
                return nil
        }
        self.name = name
    }
}

struct Movie {
    var id: Int
    var name: String
    var year: Int
    var thumbnailURL: String
    var director: String
    var mainStar : String
    var description : String
    var genres: [Genre]
    var favorite: Bool = false
    var timesFavorited: Int

    init?(json: [String : Any]) {
        guard
            let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let year = json["year"] as? Int
            else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.year = year
        
        self.thumbnailURL = json["thumbnailURL"] as? String ?? ""
        self.director = json["director"] as? String ?? ""
        self.mainStar = json["mainStar"] as? String ?? ""
        self.description = json["description"] as? String ?? ""
        
        var genresArray: [Genre] = []
        
        if let genresJson = json["gentres"] as? [[String : Any]] {
            for json in genresJson {
                if let genre = Genre(json: json) {
                    genresArray.append(genre)
                }
            }
        }
        
        self.genres = genresArray
        self.timesFavorited = 0
    }
}
