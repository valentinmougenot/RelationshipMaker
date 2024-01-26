//
//  UserRowView.swift
//  mobile
//
//  Created by mougenot valentin on 22/01/2024.
//

import SwiftUI

struct UserRowView: View {
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        HStack {
            if (user.avatarUrl != nil) {
                AsyncImage(url: URL(string: "http://api.devaligator.fr\(user.avatarUrl!)")) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            }
            else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color(.gray))
                    .clipShape(Circle())
            }
                    
            VStack(alignment: .leading) {
                Text("\(user.firstName) \(user.lastName)")
                Text(user.companyName ?? "Pas d'entreprise")
            }
            .padding(.leading, 20)
            
            Spacer()
        }
    }
}
