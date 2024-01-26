//
//  AvatarViewModel.swift
//  mobile
//
//  Created by mougenot valentin on 25/01/2024.
//

import Foundation
import SwiftUI

@MainActor
class AvatarViewModel: ObservableObject {
    
    enum State {
        case notaAvailable
        case loading
        case success(data: Avatar)
        case failed(error: Error)
    }
    
    private let service: ApiService
    
    @Published var state: State = .notaAvailable
    
    init(service: ApiService) {
        self.service = service
    }
    
    func uploadUserAvatar(id: Int, image: UIImage) async {
        self.state = .loading
        do {
            let avatar = try await service.uploadUserAvatar(id: id, image: image)
            self.state = .success(data: avatar)
        } catch {
            self.state = .failed(error: error)
            print(error)
        }
    }
}
