//
//  NewUserView.swift
//  mobile
//
//  Created by riat felix on 11/12/2023.
//

import SwiftUI

struct EditUserView: View {
    @AppStorage("myId") var myId = -1
    @AppStorage("myAvatarUrl") var myAvatarUrl = ""
    
    @StateObject var viewModel = UsersViewModel(service: ApiService())
    @StateObject var avatarViewModel = AvatarViewModel(service: ApiService())

    @State var nom: String = ""
    @State var prenom: String = ""
    @State var entreprise: String = ""
    @State var bio: String = ""
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
           if let inputImage = inputImage {
               Image(uiImage: inputImage)
                   .resizable()
                   .frame(width: 250, height: 250)
                   .clipShape(Circle())
           } else {
               if (myAvatarUrl != "") {
                    AsyncImage(url: URL(string: "http://api.devaligator.fr\(myAvatarUrl)")) { image in
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
           }
            
            Button("Choisir une photo") {
                showingImagePicker = true
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePickerView(image: $inputImage)
            }
           
            
            Spacer()
            
            TextField("Entrez votre nom", text: $nom)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.leading, .trailing], 15)
            
            TextField("Entrez votre prenom", text: $prenom)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.leading, .trailing], 15)
            
            TextField("Entrez votre entreprise", text: $entreprise)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.leading, .trailing], 15)
            
            TextField("Entrez votre bio", text: $bio)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.leading, .trailing], 15)
            
            Spacer()
            
            Button(action: {
                Task {
                    await viewModel.editUser(id: myId, firstname: prenom, lastname: nom, compagny: entreprise, bio: bio)
                    if (inputImage != nil) {
                        await avatarViewModel.uploadUserAvatar(id: myId, image: inputImage!)
                        switch avatarViewModel.state {
                        case .success(let avatar):
                            myAvatarUrl = avatar.avatarUrl
                        default:
                            return
                        }
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Modifier")
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(Color.white)
            .cornerRadius(10)
            .padding()
            .frame(height: 50)
        }
        .onAppear {
            Task {
                await viewModel.getUserById(id: myId)
                switch viewModel.state {
                case .success(let user):
                    
                    nom = user[0].lastName
                    prenom = user[0].firstName
                    entreprise = user[0].companyName ?? ""
                    bio = user[0].biography ?? ""
                    myAvatarUrl = user[0].avatarUrl ?? ""
                    
                default:
                    return
                }
            }
        }
    }
}

struct EditUserView_Previews: PreviewProvider {
    static var previews: some View {
        EditUserView()
    }
}

