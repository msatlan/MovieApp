//
//  LoginViewController.swift
//  MovieApp
//
//  Created by Marko Satlan on 29/01/2019.
//  Copyright © 2019 Marko Satlan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

// MARK: - Properties
    private let userNameTextField = UITextField()
    private let loginButton = UIButton()
    
// MARK - View life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.view.backgroundColor = UIColor.blue
        
        configureUI()
        activateConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

// MARK - Methods
    // UI & Constraints
    func configureUI() {
        userNameTextField.backgroundColor = UIColor.lightGray
        userNameTextField.placeholder = "Username"
        view.addSubview(userNameTextField)
        
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        loginButton.setTitle("Go!", for: .normal)
        loginButton.backgroundColor = UIColor.gray
        view.addSubview(loginButton)
    }
    
    func activateConstraints() {
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            userNameTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            userNameTextField.widthAnchor.constraint(equalToConstant: 200),
            userNameTextField.heightAnchor.constraint(equalToConstant: 40)
            ])
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 30),
            loginButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 60),
            loginButton.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
    
    // Button action
    @objc func login() {
        print("login")
        
        GetUserRequest().execute(username: "Marko2221") { (username, error) in
            if let error = error {
                self.showAlert(withError: error)
                return
            }

            if let username = username {
                // login
            } else {
                CreateUserRequest().execute(username: "Marko2221", completion: { (user, error) in
                    print(user)
                    print(error)
                })
            }
        }
        
        //let moviesListViecontroller = MoviesListTabBarController()
        //self.navigationController?.pushViewController(moviesListViecontroller, animated: true)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
}

extension UIViewController {
    
    func showAlert(withError error: MovieAPIError) {
        let alertController = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
