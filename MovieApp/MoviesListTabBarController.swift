//
//  MoviesListViewController.swift
//  MovieApp
//
//  Created by Marko Satlan on 29/01/2019.
//  Copyright © 2019 Marko Satlan. All rights reserved.
//

import UIKit

class MoviesListTabBarController: UITabBarController {
    
// MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureNavigationBar()
        configureTabBarController()
    }

// MARK: - Methods
    func configureNavigationBar() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.navigationItem.title = "Welcome \(DataManager.shared.user?.username ?? "")"
        
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
    }
    
    func configureTabBarController() {
        let tabOne = MoviesViewController()
        let tabOneBarItem = UITabBarItem(title: "Movies", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: "selectedImage.png"))
        
        tabOne.tabBarItem = tabOneBarItem
        
        
        let tabTwo = FavoritesViewController()
        let tabTwoBarItem2 = UITabBarItem(title: "Favorites", image: UIImage(named: "defaultImage2.png"), selectedImage: UIImage(named: "selectedImage2.png"))
        
        tabTwo.tabBarItem = tabTwoBarItem2
        
        self.viewControllers = [tabOne, tabTwo]
    }
    
    // Button actions
    @objc func logout() {
        self.navigationController?.popViewController(animated: true);
    }
}

extension MoviesListTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(viewController.title!)")
    }
}
