//
//  PlaceDetailView.swift
//  mobile
//
//  Created by mougenot valentin on 22/01/2024.
//

import SwiftUI

struct PlaceDetailView: View {
    @StateObject var viewModel = UsersViewModel(service: ApiService())
    @StateObject var placeToggleViewModel = PlaceToggleViewModel(service: ApiService())
    @AppStorage("myId") var myId = -1

    private let place: Place
    
    init(place: Place) {
        self.place = place
    }
    
    var body: some View {
        NavigationView {
            switch viewModel.state {
            case .success(let users):
                GeometryReader { geometry in
                    VStack {
                        List(users, id: \.id) { user in
                            NavigationLink(destination: UserDetailView(user: user)) {
                                UserRowView(user: user)
                            }
                        }
                        .frame(height: geometry.size.height - 60)

                        Spacer()

                        Button(action: {
                            Task {
                                await placeToggleViewModel.togglePlace(id: myId, placeId: place.id)
                                await viewModel.getUsersByPlaceId(id: place.id)
                            }
                        }) {
                            Text(isInThisPlace(users: users) ? "J'y suis plus" : "J'y suis")
                                .frame(maxWidth: .infinity)
                        }
                        .padding()
                        .background(isInThisPlace(users: users) ? Color.green : Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .padding()
                        .frame(height: 50)
                    }
                }
                .navigationBarTitle(place.name)
                
                Spacer()
            case .loading:
                ProgressView()
            default:
                EmptyView()
            }
        }
        .task {
            await viewModel.getUsersByPlaceId(id: place.id)
        }
    }
    
    func isInThisPlace(users: [User]) -> Bool {
        for user in users {
            if user.id == myId {
                return true
            }
        }
        return false
    }
}
