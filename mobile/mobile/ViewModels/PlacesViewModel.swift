//
//  PlacesViewModel.swift
//  mobile
//
//  Created by mougenot valentin on 08/01/2024.
//

import Foundation

@MainActor
class PlacesViewModel: ObservableObject {
    
    enum State {
        case notaAvailable
        case loading
        case success(data: [Place])
        case failed(error: Error)
    }
    
    private let service: ApiService
    
    @Published var state: State = .notaAvailable
    
    init(service: ApiService) {
        self.service = service
    }
    
    func getAllPlaces() async {
        self.state = .loading
        do {
            let places = try await service.getAllPlaces()
            self.state = .success(data: places)
        } catch {
            self.state = .failed(error: error)
            print(error)
        }
    }
}
