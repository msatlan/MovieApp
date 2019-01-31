//
//  DataManager.swift
//  MovieApp
//
//  Created by Marko Satlan on 31/01/2019.
//  Copyright © 2019 Marko Satlan. All rights reserved.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    var id = 0
    var username = ""
    
    private init() {
        
    }
}
