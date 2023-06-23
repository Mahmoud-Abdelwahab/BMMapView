//
//  Contruct.swift
//  AppleMapFramework
//
//  Created by Mahmoud Abdulwahab on 22/06/2023.
//

import MapKit


public protocol BMMapDelegate: AnyObject {
    func didSelectAnnotation(_ annotation: BMAnnotation)
    func didDrageOnMap()
    func didTapOnCalloutView(_ annotation: BMAnnotation)
}

public protocol BMMapInputType: AnyObject {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance)
    func addAnnotation(_ annotation: BMAnnotation)
    func addAnnotations(_ annotatios: [BMAnnotation])
    func setDefaultPinIcon(with icon: UIImage)
    func canShowCalloutView(_ isShown: Bool)
    
    func removeAnnotations(_ annotatios: [MKAnnotation])
    func removeAnnotation(_ annotation: MKAnnotation)
    func selectMarker(_ marker: BMAnnotation)
    func animateToCoordinate(_ coordinate: CLLocationCoordinate2D, withZoomLevel zoomLevel: Double)
    func drawAnnotations(_ annotations: [MKAnnotation])
    func fitAnnotationsOnScreen()
}

public struct BMAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
}

extension BMMapDelegate {
    func didSelectAnnotation(_ annotation: MKAnnotation) {}
    func didDrageOnMap() {}
}



