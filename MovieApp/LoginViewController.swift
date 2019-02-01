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
    private var usernameInputString = ""
    private var activeTextField: UITextField!
    private let loginButton = UIButton()
    
// MARK - View life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.view.backgroundColor = UIColor.blue
        
        userNameTextField.returnKeyType = UIReturnKeyType.done
        userNameTextField.delegate = self;
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
        GetUserRequest().execute(username: usernameInputString) { (user, error) in
            if let error = error {
                self.showErrorAlert(withError: error)
                return
            }

            if let user = user {
                // login
                DataManager.shared.user = user
                let moviesListViecontroller = MoviesListTabBarController()
                self.navigationController?.pushViewController(moviesListViecontroller, animated: true)
            } else {
                self.showCreateUserAlert(username: self.usernameInputString)
            }
        }
        activeTextField.resignFirstResponder()
    }
    
    func showCreateUserAlert(username: String) {
        let alertController = UIAlertController(title: "", message: "Do you want to create a new user with username: \(username)?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler:nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (alert: UIAlertAction) in
            CreateUserRequest().execute(username: username, completion: { (user, error) in
                if let error = error {
                    self.showErrorAlert(withError: error)
                    print(error.localizedDescription)
                    
                    return
                }
                
                if let user = user {
                    DataManager.shared.user = user
                    self.navigationController?.pushViewController(MoviesListTabBarController(), animated: true)
                }
                
            })
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        usernameInputString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        activeTextField = textField
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UIViewController {
    
    func showErrorAlert(withError error: MovieAPIError) {
        let alertController = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

