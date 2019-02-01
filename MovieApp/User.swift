//
//  User.swift
//  MovieApp
//
//  Created by Marko Satlan on 31/01/2019.
//  Copyright © 2019 Marko Satlan. All rights reserved.
//

import Foundation

class User {
    var id: Int
    var username: String
    
    init?(json: [String : Any]) {
        guard
            let id = json["id"] as? Int,
            let username = json["username"] as? String
            else {
                return nil
        }
        
        self.id = id
        self.username = username
    }
}
