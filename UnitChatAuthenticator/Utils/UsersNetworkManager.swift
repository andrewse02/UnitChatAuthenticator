//
//  UsersNetworkManager.swift
//  UnitChatAuthenticator
//
//  Created by Andrew Elliott on 4/6/22.
//

import Foundation

class UsersNetworkManager {
    
    static func loginRequest(username: String, password: String, completion: @escaping (Result<String, AuthError>) -> Void) {
        guard let baseURL = URL(string: UnitChatStrings.localBaseURL) else { return completion(.failure(.invalidURL)) }
        let finalURL = baseURL.appendingPathComponent(UnitChatStrings.loginEndpoint)
        
        let jsonBody = ["username": username, "password": password]
        let body = try? JSONSerialization.data(withJSONObject: jsonBody)
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = "POST"
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
            
            guard let response = response as? HTTPURLResponse else { return completion(.failure(.invalidResponse)) }
            
            // Server responds with 401 if username and password do not match a user
            if response.statusCode == 401 { return completion(.failure(.invalidCredentials)) }
        
            // Server responds with 500 if there was an internal error
            if response.statusCode == 500 { return completion(.failure(.internalServerError)) }
            
            // Server responds with 200 if everything went great and I am a good developer (rare)
            if response.statusCode == 200 {
                guard let data = data,
                      let result = String(data: data, encoding: String.Encoding.utf8) else { return completion(.failure(.noData)) }
                
                return completion(.success(result))
            } else { return completion(.failure(.invalidResponse)) }
        }.resume()
    }
    
    static func fetchUser(completion: @escaping (Result<User, AuthError>) -> Void) {
        guard let baseURL = URL(string: UnitChatStrings.localBaseURL) else { return completion(.failure(.invalidURL)) }
        let finalURL = baseURL.appendingPathComponent(UnitChatStrings.userEndpoint)
        
        guard let token = TokenController.shared.token else { return completion(.failure(.userNotLoggedIn)) }
        
        var request = URLRequest(url: finalURL)
        request.addValue(UnitChatStrings.getAuthHeader(for: token.value ?? ""), forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
            
            guard let response = response as? HTTPURLResponse else { return completion(.failure(.invalidResponse)) }
            
            // Server responds with 401 if no token was provided
            if response.statusCode == 401 { return completion(.failure(.userNotLoggedIn)) }
            
            // Server responds with 403 if the token is invalid
            if response.statusCode == 403 { return completion(.failure(.invalidCredentials)) }
            
            // Server responds with 200 if everything went great and I am a good developer (rare)
            if response.statusCode == 200 {
                guard let data = data else { return completion(.failure(.noData)) }
                
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    return completion(.success(user))
                } catch {
                    print(error.localizedDescription)
                    return completion(.failure(.unableToDecode))
                }
            }
        }.resume()
    }
}
