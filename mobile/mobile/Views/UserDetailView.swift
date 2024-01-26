//
//  UserDetailView.swift
//  mobile
//
//  Created by mougenot valentin on 22/01/2024.
//

import SwiftUI

struct UserDetailView: View {
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        VStack {
            if (user.avatarUrl != nil) {
                AsyncImage(url: URL(string: "http://api.devaligator.fr\(user.avatarUrl!)")) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: 250, height: 250)
                .clipShape(Circle())
            }
            else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 250, height: 250)
                    .foregroundColor(Color(.gray))
                    .clipShape(Circle())
            }
            
            Text("\(user.firstName) \(user.lastName)")
                .font(.title2)
                .bold()
                .padding(.top, 20)
            Text("Entreprise : \(user.companyName ?? "Aucune entreprise")")
                .bold()
            if (user.biography != nil) {
                Text(user.biography!)
                    .padding(.top, 20)
            }
        }
    }
}
