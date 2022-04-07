//
//  Constants.swift
//  UnitChatAuthenticator
//
//  Created by Andrew Elliott on 4/6/22.
//

import Foundation

class UnitChatStrings {
    
    // MARK: - URLs
    
    static let baseURL = "https://unit-chat.herokuapp.com"
    static let localBaseURL = "http://localhost:4000"
    
    // MARK: - Endpoints
    
    static let loginEndpoint = "login"
    static let registerEndpoint = "register"
    static let userEndpoint = "user"
    
    // MARK: - Functions
    
    static func getAuthHeader(for token: String) -> String {
        return "Bearer \(token)";
    }
}
