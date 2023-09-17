//
//  Contruct.swift
//  AppleMapFramework
//
//  Created by Mahmoud Abdulwahab on 29/06/2023.
//

import UIKit
import CoreLocation

public protocol BMMapDelegate: AnyObject {
    
    /// This delegate func fires When user click on any marker
    /// - Parameter annotation: The selected annotation
    func didSelectAnnotation(_ annotation: BMAnnotation)
    
    
    /// This delegate func used when user move or drag map to any direction
    func didDrageOnMap()
    
    
    /// This delegate func when the user click on the callout view
    /// - Parameter annotation: this is the selected annotation which related to the selected callout view
    func didTapOnCalloutView(_ annotation: BMAnnotation)
}

public protocol BMMapInputType: AnyObject {
    ///  Property to receive general actions on map
    var delegate: BMMapDelegate? { set get }
    
    /// Use the 'Property' variable to get the current center coordinate of the map.
    var centerOfCameraPosition: CLLocationCoordinate2D? { get }
    
    /// Center Map to specific location
    /// - Parameters:
    ///   - annotations: Location to center the map to
    ///   - regionRadius: Zoom level
    func centerToAnnotation(_ annotations: BMAnnotation, regionRadius: Double?)
    
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
    func selectAnnotation(_ annotation: BMAnnotation, regionRadius: Double?)
    
    /// Remove annotation from make
    /// - Parameter annotations: List of annotations to be removed
    func removeAnnotations(_ annotations: [BMAnnotation])
    
    /// Fit list of annotations on the entire screen
    /// - Parameters:
    ///   - annotations: List of annotations to be fitted on the entire screen
    ///   - edgePadding: Setting Edge insets to dynamically set  canvas padding for the annotations it takes default
    func fitAnnotationsInTheScreen(_ annotations: [BMAnnotation], edgePadding: UIEdgeInsets)
    
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

public extension BMMapDelegate{
    func didDrageOnMap() {}
    func didTapOnCalloutView(_ annotation: BMAnnotation) {}
}

public extension BMMapInputType {
    func fitAnnotationsInTheScreen(_ annotations: [BMAnnotation], edgePadding: UIEdgeInsets = UIEdgeInsets(top: 50, left: 16, bottom: 50, right: 16)) {
       fitAnnotationsInTheScreen(annotations, edgePadding: edgePadding)
    }
    
    func scaleAnnotation(_ annotation: BMAnnotation, selectedScale: CGFloat = 1.5) {
        scaleAnnotation(annotation, selectedScale: selectedScale)
    }

    func animateToAnnotation(_ annotation: BMAnnotation, zoomLevel: Double? = nil, animated: Bool = true) {
        animateToAnnotation(annotation, zoomLevel: zoomLevel, animated: animated)
    }
}
