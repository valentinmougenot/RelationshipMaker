//
//  PlaceToggleViewModel.swift
//  mobile
//
//  Created by mougenot valentin on 22/01/2024.
//

import Foundation

@MainActor
class PlaceToggleViewModel: ObservableObject {
    
    enum State {
        case notaAvailable
        case loading
        case success
        case failed(error: Error)
    }
    
    private let service: ApiService
    
    @Published var state: State = .notaAvailable
    
    init(service: ApiService) {
        self.service = service
    }
    
    func togglePlace(id: Int, placeId: Int) async {
        self.state = .loading
        do {
            try await service.togglePlace(id: id, placeId: placeId)
            self.state = .success
        } catch {
            self.state = .failed(error: error)
            print(error)
        }
    }
}
