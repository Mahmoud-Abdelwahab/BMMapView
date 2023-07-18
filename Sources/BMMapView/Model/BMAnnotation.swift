//
//  BMAnnotation.swift
//  
//
//  Created by Mahmoud Abdulwahab on 18/07/2023.
//

import MapKit

public class BMAnnotation: NSObject, MKAnnotation {
    public var coordinate: CLLocationCoordinate2D
    public var title: String?
    public var subtitle: String?
    public init(coordinate: CLLocationCoordinate2D, title: String? = nil, subtitle: String? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}

extension BMAnnotation {
    func mapToMKAnnotation() -> MKAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = self.coordinate
        annotation.title = self.title
        annotation.subtitle = self.subtitle
        return annotation
    }
}
