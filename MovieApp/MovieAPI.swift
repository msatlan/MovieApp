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
                            let user = User(json: dict)
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
                    if let data = data,
                        let json = self.parse(json: data),
                        let key = json.keys.first,
                        let message = (json[key] as? [String])?.first {
                        DispatchQueue.main.async {
                            completion(nil, MovieAPIError(message: "\(key) \(message)"))
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(nil, MovieAPIError())
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
}


// GetMoviesRequest with ID returns favorite movies, without ID returns all movies
class GetMoviesRequest {
    func execute(userID: Int? = nil, completion: @escaping ([Movie]?, MovieAPIError?) -> Void) {
        var urlRequest: URLRequest
        
        if let userID = userID {
            urlRequest = URLRequest(url: URL(string: "http://46.101.218.241/api/users/\(userID)/movies")!)
        } else {
            urlRequest = URLRequest(url: URL(string: "http://46.101.218.241/api/movies")!)
        }

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
                        var moviesArray: [Movie] = []
                        for json in jsonArray {
                            if var movie = Movie(json: json) {
                                if userID != nil {
                                    movie.favorite = true
                                }
                                moviesArray.append(movie)
                            }
                        }
                        for movie in moviesArray {
                            print(movie)
                        }
                        DispatchQueue.main.async {
                            completion(moviesArray, nil)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(nil, MovieAPIError())
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

// No error means success
class FavouriteMovieRequest {
    func execute(userID: Int, movieID: Int, favorite: Bool, completion: @escaping((MovieAPIError?)->Void)) {
        let verb = favorite ? "favorite" : "unfavorite"
        var urlRequest = URLRequest(url: URL(string: "http://46.101.218.241/api/users/\(userID)/movies/\(movieID)/\(verb)")!)
        urlRequest.allHTTPHeaderFields = ["Content-Type": "application/json"]
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(MovieAPIError(message: error.localizedDescription))
                }
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                DispatchQueue.main.async {
                    completion(nil)
                }
            } else {
                DispatchQueue.main.async {
                    completion(MovieAPIError())
                }
            }
        }.resume()
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

