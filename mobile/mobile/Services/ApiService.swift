//
//  ApiService.swift
//  mobile
//
//  Created by riat felix on 08/01/2024.
//

import Foundation
import SwiftUI

enum ApiError: Error {
    case failed
    case failedToDecode
    case failedToEncode
    case invalidStatusCode
    case invalidUserId
    case invalidPlaceId
    case invalidURL
    case invalidImageData
}

struct ApiService {
    let baseURL = "http://api.devaligator.fr"
    
    func getUserById(id: Int) async throws -> User {
        let endpoint = baseURL + "/users/\(id)"
        
        guard let url = URL(string: endpoint) else {
            throw ApiError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw ApiError.invalidUserId
        }
        
        let decodedData = try JSONDecoder().decode(User.self, from: data)
        
        return decodedData
    }
    
    func getUsersByPlaceId(id: Int) async throws -> [User] {
        let endpoint = baseURL + "/places/\(id)/users"
        
        guard let url = URL(string: endpoint) else {
            throw ApiError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw ApiError.invalidPlaceId
        }
        
        let decodedData = try JSONDecoder().decode([User].self, from: data)
        
        return decodedData
    }
    
    func getAllPlaces() async throws -> [Place] {
        let endpoint = baseURL + "/places"
        
        guard let url = URL(string: endpoint) else {
            throw ApiError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw ApiError.invalidStatusCode
        }
        
        let decodedData = try JSONDecoder().decode([Place].self, from: data)
                
        return decodedData
    }
    
    func addNewUser(firstname: String, lastname: String, compagny: String, bio: String) async throws -> User {
        let endpoint = baseURL + "/users"
        let user = User(id: 0, firstName: firstname, lastName: lastname, companyName: compagny, biography: bio)
        guard let data = try? JSONEncoder().encode(user) else {
            throw ApiError.failedToEncode
        }
        
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.upload(for: request, from: data)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 201 else {
                throw ApiError.invalidUserId
            }
            
            let decodedData = try JSONDecoder().decode(User.self, from: data)
            
            return decodedData
            
        } catch {
            throw ApiError.invalidURL
        }
    }
    
    func editUser(id: Int, firstname: String, lastname: String, compagny: String, bio: String) async throws {
        let endpoint = baseURL + "/users/\(id)"
        let user = User(id: id, firstName: firstname, lastName: lastname, companyName: compagny, biography: bio)
        guard let data = try? JSONEncoder().encode(user) else {
            throw ApiError.failedToEncode
        }
        
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (_, response) = try await URLSession.shared.upload(for: request, from: data)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 204 else {
                throw ApiError.invalidUserId
            }
            
        } catch {
            throw ApiError.invalidURL
        }
    }
    
    func togglePlace(id: Int, placeId: Int) async throws {
        let endpoint = baseURL + "/users/\(id)/place"
        let placeToggle = PlaceToggle(placeId: placeId)
        guard let data = try? JSONEncoder().encode(placeToggle) else {
            throw ApiError.failedToEncode
        }
        
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (_, response) = try await URLSession.shared.upload(for: request, from: data)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 204 else {
                throw ApiError.invalidUserId
            }
            
        } catch {
            throw ApiError.invalidURL
        }
    }
    
    func uploadUserAvatar(id: Int, image: UIImage) async throws -> Avatar {
        let endpoint = baseURL + "/users/\(id)/avatar"

        guard let url = URL(string: endpoint) else {
            throw ApiError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            throw ApiError.invalidImageData
        }

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"avatar\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        let (data, response) = try await URLSession.shared.upload(for: request, from: body)

        do {
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw ApiError.invalidUserId
            }
            
            let decodedData = try JSONDecoder().decode(Avatar.self, from: data)
            return decodedData
        } catch {
            throw ApiError.invalidURL
        }
    }
}
