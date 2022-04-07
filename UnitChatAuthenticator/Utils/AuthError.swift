//
//  AuthError.swift
//  UnitChatAuthenticator
//
//  Created by Andrew Elliott on 4/6/22.
//

import Foundation

enum AuthError: LocalizedError {
    
    // MARK: - Internal Errors
    
    case invalidURL
    case invalidRequest
    case invalidResponse
    case internalServerError
    case userNotLoggedIn
    case thrownError(Error)
    case noData
    case unableToDecode
    
    // MARK: - Auth Errors
    
    case invalidCredentials
    
    var errorDescription: String? {
        switch self {
            
        // MARK: - Internal Errors
            
        case .invalidURL, .internalServerError:
            return "Internal error. Please update Unit Chat Authenticator or contact support."
        case .invalidRequest:
            return "Request was invalid. Please update Unit Chat Authenticator or contact support."
        case .invalidResponse:
            return "The server responded with and unexpected response. Please update Unit Chat Authenticator or contact support."
        case .userNotLoggedIn:
            return "Attempted to fetch user with no token stored."
        case .thrownError(let error):
            return error.localizedDescription
        case .noData:
            return "The server responded with no data."
        case .unableToDecode:
            return "The server responded with bad data."
            
        // MARK: - Auth Errors
            
        case .invalidCredentials:
            return "Username or password is incorrect!"
        }
    }
}
