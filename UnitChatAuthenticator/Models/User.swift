//
//  User.swift
//  UnitChatAuthenticator
//
//  Created by Andrew Elliott on 4/6/22.
//

import Foundation

/*
 "user_id": 1,
 "first_name": "Andrew",
 "last_name": "Elliott",
 "email": "andrewelliott159@gmail.com",
 "username": "Andrew",
 "profile_pic": "https://avatars.dicebear.com/api/initials/Andrew.svg"
 */

struct User: Decodable {
    var id: Int
    var firstName: String
    var lastName: String
    var email: String
    var username: String
    var profilePic: String
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case username
        case profilePic = "profile_pic"
    }
}
