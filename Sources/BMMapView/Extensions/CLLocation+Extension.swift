//
//  File.swift
//  
//
//  Created by Mahmoud Abdulwahab on 17/07/2023.
//

import MapKit
extension CLLocationCoordinate2D: Equatable {
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
