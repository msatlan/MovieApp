//
//  MovieAPI.swift
//  MovieApp
//
//  Created by Marko Satlan on 30/01/2019.
//  Copyright © 2019 Marko Satlan. All rights reserved.
//

import Foundation

struct User {
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

struct MovieAPIError: Error {
    var title: String
    var message: String
    
    init(title: String = "Error", message: String = "Something went wrong") {
        self.title = title
        self.message = message
    }
}

class GetUserRequest {
    
    func execute(username: String, completion: @escaping((String?, MovieAPIError?) -> Void)) {
        var urlRequest = URLRequest(url: URL(string: "http://46.101.218.241/api/users?username=\(username)")!)
        urlRequest.allHTTPHeaderFields = ["Content-Type": "application/json"]
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    print("error")
                    completion(nil, MovieAPIError(message: error.localizedDescription))
                }
                return
            }
            
            if let response = response as? HTTPURLResponse {
                //print("response \(response)")
                //print(data?.prettyPrinted)
                switch(response.statusCode) {
                    case 200:
                    if let data = data,
                        let json = self.parseArray(json: data){
                        print("data \(data)")
                        print("json \(json)")
                        // parse array of dictionaries
                    } else {
                        DispatchQueue.main.async {
                            completion(nil, MovieAPIError(message: "No data or cannot parse JSON"))
                        }
                    }
                    default:
                        DispatchQueue.main.async {
                            completion(nil, MovieAPIError())
                        }
                }
            }
        
            //print(data?.prettyPrinted)

        }.resume()
    }
    
    private func parse(json data: Data) -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print("JSON error: \(error)")
            return nil
        }
    }

    private func parseArray(json data: Data) -> [[String: Any]]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]

        } catch  {
            print("JSON error: \(error)")
            return nil
        }
        return []
    }
}

class CreateUserRequest {
    
    func execute(username: String, completion:@escaping ((User?, Error?) -> Void)) {
        print("execute CreateUserRequest")
        var urlRequest = URLRequest(url: URL(string: "http://46.101.218.241/api/users.json")!)
        urlRequest.allHTTPHeaderFields = ["Content-Type": "application/json"]
        urlRequest.httpMethod = "POST"
        
        let params = [
            "user": [
                "username": username
            ]
        ]
        urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let json = self.parse(json: data!) {
                print("json create user \(json)")
                
                let user = User(json: json)
                completion(user, nil)
            }
            
            //print(data?.prettyPrinted)
            
            //print(data)
            //print(response)
            //print(error)
            }.resume()
    }
    
    private func parse(json data: Data) -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print("JSON error: \(error)")
            return nil
        }
    }
}

extension Data {
    
    var prettyPrinted: String {
        get {
            let json = try! JSONSerialization.jsonObject(with: self, options: .allowFragments)
            let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)!
        }
    }
}

// let urlWithParams = scriptUrl + "?userName=\(userNameValue!)"

// http://46.101.218.241/api/users?username=test1

