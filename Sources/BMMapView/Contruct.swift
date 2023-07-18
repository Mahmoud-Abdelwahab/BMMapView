//
//  Contruct.swift
//  AppleMapFramework
//
//  Created by Mahmoud Abdulwahab on 29/06/2023.
//

import MapKit


public protocol BMMapDelegate: AnyObject {
    
    func didSelectAnnotation(_ annotation: BMAnnotation)
    func didDrageOnMap()
    func didTapOnCalloutView(_ annotation: BMAnnotation)
}

public protocol BMMapInputType: AnyObject {
    /// Center Map to specific location
    /// - Parameters:
    ///   - annotations: Location to center the map to
    ///   - regionRadius: Zoom level
    func centerToAnnotation(_ annotations: BMAnnotation, regionRadius: Double)
    
    /// Change default marker icon
    /// - Parameter icon: marker icon
    func setDefaultPinIcon(with icon: UIImage)
    
    /// Add some annotation on the map
    /// - Parameter annotations: annotations to be added . if you want only one annotation send it also as array
    func addAnnotations(_ annotations: [BMAnnotation])
    
    /// Showing Callout view above the annotation
    /// - Parameter isShown: boolean  value
    func shouldShowCalloutView(_ isShown: Bool)
    
    /// Select specific marker on the map by  selecting specific annotation eg. from tableview cell or collectionview
    /// - Parameters:
    ///   - annotation: The selected annotation
    ///   - regionRadius: Zoom level
    func selectAnnotation(_ annotation: BMAnnotation, regionRadius: Double)
    
    /// Remove annotation from make
    /// - Parameter annotations: List of annotations to be removed
    func removeAnnotations(_ annotations: [BMAnnotation])
    
    /// Fit list of annotations on the entire screen
    /// - Parameters:
    ///   - annotations: List of annotations to be fitted on the entire screen
    ///   - edgePadding: Setting Edge insets to dynamically set  canvas padding for the annotations it takes default
    func fitAnnotationsInTheScreen(_ annotations: [BMAnnotation],_ edgePadding: UIEdgeInsets)
    
    /// Resetting scaled Annotations
    func resetAnnotationScaling()
    
    
    /// Scale Annotation icon
    /// - Parameter annotation: annotation to be scaled
    /// - Parameter selectedScale: The scaling factor for icon
    func scaleAnnotation(_ annotation: BMAnnotation, selectedScale: CGFloat)
    
    
    /// Move Camera position to specific annotation with zoom level
    /// - Parameters:
    ///   - annotation: target annotation
    ///   - zoomLevel: zoom level
    ///   - animated: move with animation
    func animateToAnnotation(_ annotation: BMAnnotation, zoomLevel: Double?, animated: Bool)
}

extension BMMapInputType {
    
}

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

extension BMMapDelegate {
    func didSelectAnnotation(_ annotation: MKAnnotation) {}
    func didDrageOnMap() {}
}



