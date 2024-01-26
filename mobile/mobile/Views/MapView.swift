//
//  MapView.swift
//  mobile
//
//  Created by mougenot valentin on 08/01/2024.
//

import SwiftUI
import MapKit


struct MapView: View {
    @AppStorage("myAvatarUrl") var myAvatarUrl = ""
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 43.739570708472, longitude: 7.425796259790472),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @StateObject var viewModel = PlacesViewModel(service: ApiService())
    @State private var selectedPlace: Place?
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    switch viewModel.state {
                    case .success(let places):
                        Map(coordinateRegion: $region, annotationItems: places) { place in
                            MapAnnotation(coordinate: place.coordinate) {
                                Button(action: {
                                    self.selectedPlace = place
                                }) {
                                    Image(systemName: "mappin.circle.fill")
                                        .foregroundColor(.red)
                                        .font(.system(size: 30))
                                }
                            }
                        }
                        .ignoresSafeArea()
                        .sheet(item: $selectedPlace) { place in
                            PlaceDetailView(place: place)
                        }
                    case .loading:
                        ProgressView()
                    default:
                        EmptyView()
                    }
                }
                .task {
                    await viewModel.getAllPlaces()
                }
                HStack {
                    Spacer()
                    VStack {
                        NavigationLink(destination: EditUserView()) {
                        ZStack {
                            
                                Circle()
                                    .foregroundColor(.purple)
                                    .frame(width: 55)
                                
                                if (myAvatarUrl != "") {
                                    AsyncImage(url: URL(string: "http://api.devaligator.fr\(myAvatarUrl)")) { image in
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
                                        .background(.white)
                                        .clipShape(Circle())
                                        
                                }
                            }
                            
                        }
                        .padding(.trailing, 40)
                        Spacer()
                    }
                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
