//
//  MovieAPI.swift
//  MovieApp
//
//  Created by Marko Satlan on 30/01/2019.
//  Copyright © 2019 Marko Satlan. All rights reserved.
//

import Foundation

struct MovieAPIError: Error {
    var title: String
    var message: String
    
    init(title: String = "Error", message: String = "Something went wrong") {
        self.title = title
        self.message = message
    }
}

enum Success {
    case True
    case False
}

class GetUserRequest {
    
    func execute(username: String, completion: @escaping((User?, MovieAPIError?) -> Void)) {
        var urlRequest = URLRequest(url: URL(string: "http://46.101.218.241/api/users?username=\(username)")!)
        urlRequest.allHTTPHeaderFields = ["Content-Type": "application/json"]
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, MovieAPIError(message: error.localizedDescription))
                }
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch(response.statusCode) {
                    case 200:
                    if let data = data,
                      let jsonArray = self.parseArray(json: data) {
                        if let dict = jsonArray.first {
                            let user = User(json: dict)!
                            DispatchQueue.main.async {
                                completion(user, nil)
                            }
                        } else {
                            let user = User(json: [:])
                            DispatchQueue.main.async {
                                completion(user, nil)
                            }
                        }
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
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            
            return jsonArray
        } catch  {
            print("JSON error: \(error)")
            return nil
        }
    }
}

class CreateUserRequest {
    
    func execute(username: String, completion:@escaping ((User?, MovieAPIError?) -> Void)) {
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
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, MovieAPIError(message: error.localizedDescription))
                }
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
                switch(response.statusCode) {
                case 200:
                    if let data = data,
                        let json = self.parse(json: data) {
                        let user = User(json: json)
                        DispatchQueue.main.async {
                            completion(user, nil)
                        }
                    }
                case 422:
                    print("status 422")
                    DispatchQueue.main.async {
                        completion(nil, MovieAPIError())
                    }
                default:
                    DispatchQueue.main.async {
                        completion(nil, MovieAPIError())
                    }
                }
            }
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

class GetAllMoviesRequest {
    func execute(completion: @escaping (Success, MovieAPIError?) -> Void) {
        var urlRequest = URLRequest(url: URL(string: "http://46.101.218.241/api/movies")!)
        urlRequest.allHTTPHeaderFields = ["Content-Type": "application/json"]
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.False, MovieAPIError(message: error.localizedDescription))
                }
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch(response.statusCode) {
                case 200:
                    print("status 200")
                    if let data = data,
                        let jsonArray = self.parseArray(json: data) {
                        print(jsonArray)
                        var moviesArray: [Movie] = []
                        
                        for json in jsonArray {
                            let movie = Movie()
                            
                            if let id = json["id"] as? Int {
                                movie.id = id
                            }
                            
                            if let name = json["name"] as? String {
                                movie.name = name
                            }
                            
                            if let year = json["year"] as? Int {
                                movie.year = year
                            }
                            
                            if let thumbnailURL = json["thumbnailURL"] as? String {
                                movie.thumbnailURL = thumbnailURL
                            }
                            
                            if let director = json["director"] as? String {
                                movie.director = director
                            }
                            
                            if let mainStar = json["mainStar"] as? String {
                                movie.mainStar = mainStar
                            }
                            
                            if let description = json["description"] as? String {
                                movie.description = description
                            }
                            
                            if let genres = json["gentres"] as? [String : Any] {
                                print(genres)
                            }
                            
                            moviesArray.append(movie)
                        }
                        for movie in moviesArray {
                            //print(movie.id, movie.name, movie.year, movie.thumbnailURL, movie.director, movie.mainStar, movie.description)
                        }
                    }
                default:
                    DispatchQueue.main.async {
                        completion(.False, MovieAPIError())
                    }
                }
            }
        }.resume()
    }
 
    private func parseArray(json data: Data) -> [[String: Any]]? {
        do {
            let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            
            return jsonArray
        } catch  {
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

