//
//  Place.swift
//  mobile
//
//  Created by mougenot valentin on 08/01/2024.
//

import Foundation
import MapKit

struct Place: Identifiable, Codable, Hashable {
    var id: Int
    var name: String
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
    }
}
