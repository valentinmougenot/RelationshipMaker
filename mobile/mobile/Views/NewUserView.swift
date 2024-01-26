//
//  NewUserView.swift
//  mobile
//
//  Created by riat felix on 11/12/2023.
//

import SwiftUI

struct NewUserView: View {
    @AppStorage("isFirstConnection") var isNotFirstConnection = false
    @AppStorage("myId") var myId = -1
    @AppStorage("myAvatarUrl") var myAvatarUrl = ""
    @State var isPressed: Bool = false
    
    @StateObject var viewModel = UsersViewModel(service: ApiService())
    @StateObject var avatarViewModel = AvatarViewModel(service: ApiService())
    @State var nom: String = ""
    @State var prenom: String = ""
    @State var entreprise: String = ""
    @State var bio: String = ""
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                
                if let inputImage = inputImage {
                    Image(uiImage: inputImage)
                        .resizable()
                        .frame(width: 250, height: 250)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width:250, height:250)
                        .foregroundColor(Color(.gray))
                        .padding()
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
                    isPressed = true
                    isNotFirstConnection = true
                    Task {
                        await viewModel.addNewUser(firstname: prenom, lastname: nom, compagny: entreprise, bio: bio)
                        
                        switch viewModel.state {
                        case .success(let users):
                            myId = users[0].id
                            myAvatarUrl = users[0].avatarUrl ?? ""
                        default:
                            return
                        }
                        
                        if (inputImage != nil) {
                            await avatarViewModel.uploadUserAvatar(id: myId, image: inputImage!)
                            switch avatarViewModel.state {
                            case .success(let avatar):
                                myAvatarUrl = avatar.avatarUrl
                            default:
                                return
                            }
                        }
                    }
                }) {
                    Text("Suivant")
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .padding()
                .frame(height: 50)
                
                NavigationLink(destination: MapView().navigationBarHidden(true), isActive: $isPressed) {
                    EmptyView()
                }
            }
        }
    }
}

struct NewUserView_Previews: PreviewProvider {
    static var previews: some View {
        NewUserView()
    }
}

