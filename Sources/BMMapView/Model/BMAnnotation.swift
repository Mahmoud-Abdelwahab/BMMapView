//
//  BMAnnotation.swift
//  
//
//  Created by Mahmoud Abdulwahab on 18/07/2023.
//

import MapKit

 protocol BMAnnotationType : NSObjectProtocol {
     var coordinate: CLLocationCoordinate2D { get }
     var title: String? { get }
     var subtitle: String? { get }
}

public class BMAnnotation: NSObject, BMAnnotationType {
    public var coordinate: CLLocationCoordinate2D
    public var title: String?
    public var subtitle: String?
    public init(coordinate: CLLocationCoordinate2D, title: String? = nil, subtitle: String? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}


extension BMAnnotation: MKAnnotation { }
