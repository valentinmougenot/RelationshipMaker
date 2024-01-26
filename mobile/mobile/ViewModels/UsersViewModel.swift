//
//  UsersViewModel.swift
//  mobile
//
//  Created by mougenot valentin on 22/01/2024.
//

import Foundation

@MainActor
class UsersViewModel: ObservableObject {
    
    enum State {
        case notaAvailable
        case loading
        case success(data: [User])
        case failed(error: Error)
    }
    
    private let service: ApiService
    
    @Published var state: State = .notaAvailable
    
    init(service: ApiService) {
        self.service = service
    }
    
    func getUsersByPlaceId(id: Int) async {
        self.state = .loading
        do {
            let users = try await service.getUsersByPlaceId(id: id)
            self.state = .success(data: users)
        } catch {
            self.state = .failed(error: error)
            print(error)
        }
    }
    
    func getUserById(id: Int) async {
        self.state = .loading
        do {
            let user = try await service.getUserById(id: id)
            self.state = .success(data: [user])
        } catch {
            self.state = .failed(error: error)
            print(error)
        }
    }

    
    func addNewUser(firstname: String, lastname: String, compagny: String, bio: String) async {
        do {
            let users = try await service.addNewUser(firstname: firstname, lastname: lastname, compagny: compagny, bio: bio)
            self.state = .success(data: [users])
        } catch {
            self.state = .failed(error: error)
            print(error)
        }
    }
    
    func editUser(id: Int, firstname: String, lastname: String, compagny: String, bio: String) async {
        do {
            try await service.editUser(id: id, firstname: firstname, lastname: lastname, compagny: compagny, bio: bio)
            self.state = .success(data: [])
        } catch {
            self.state = .failed(error: error)
            print(error)
        }
    }
}
