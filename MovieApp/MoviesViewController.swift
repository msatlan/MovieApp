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
        
        view.backgroundColor = UIColor.red
        
        GetAllMoviesRequest().execute { (success, error) in
            if let error = error {
                self.showErrorAlert(withError: error)
                return
            }
        }
        
        //print("DataManager.shared.user?.username \(DataManager.shared.user?.username)")
    }


}
