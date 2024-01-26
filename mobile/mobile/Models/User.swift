//
//  User.swift
//  mobile
//
//  Created by mougenot valentin on 08/01/2024.
//

import Foundation

struct User: Codable, Hashable {
    var id: Int
    var firstName: String
    var lastName: String
    var companyName: String?
    var biography: String?
    var avatarUrl: String?
    var placeId: Int?
}
