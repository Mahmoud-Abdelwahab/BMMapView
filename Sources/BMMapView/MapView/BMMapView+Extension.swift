//
//  File.swift
//  
//
//  Created by Mahmoud Abdulwahab on 01/08/2023.
//

import MapKit

extension BMAppleMapView: MKMapViewDelegate {
    
    // MARK: - MKMapViewDelegate
    
    public func mapView(_ mapView: MKMapView,
                        didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        let bmAnnotation = BMAnnotation(
            coordinate: annotation.coordinate,
            title: annotation.title ?? nil,
            subtitle: annotation.subtitle ?? nil)
        delegate?.didSelectAnnotation(bmAnnotation)
    }
    
    public func mapView(_ mapView: MKMapView,
                        regionWillChangeAnimated animated: Bool) {
        if animated {
            centerOfCameraPosition = mapView.centerCoordinate
            delegate?.didDrageOnMap()
        }
    }
    
    public func mapView(_ mapView: MKMapView,
                        viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            /// Return nil to use the default blue dot for the user's location.
            return nil
        } else {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView.isUserInteractionEnabled = true
            if let canShowCallout = canShowCallout {
                annotationView.canShowCallout = canShowCallout
            }
            
            if let defaultPinIcon = defaultPinIcon {
                annotationView.image = defaultPinIcon
            } else {
                annotationView.image = UIImage(systemName: "mappin.and.ellipse")?.withTintColor(.red, renderingMode: .alwaysTemplate)
            }
            let button = AnnotationButton(type: .detailDisclosure)
            button.addTarget(self, action: #selector(pinAction(_:)), for: .touchUpInside)
            if let pointAnnotation = annotation as? MKPointAnnotation {
                button.annotation = pointAnnotation
            }
            annotationView.rightCalloutAccessoryView = button
            return annotationView
        }
    }
    
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if autoScaling , let lastScaledAnnotation = lastScaledAnnotation {
            scaleAnnotation(lastScaledAnnotation)
            autoScaling = false
        }
    }
    
    
    @objc private func pinAction(_ pinButton: AnnotationButton) {
        guard let annotationPointModel = pinButton.annotation else { return }
        let annotation = BMAnnotation(coordinate: annotationPointModel.coordinate, title: annotationPointModel.title, subtitle: annotationPointModel.subtitle)
        delegate?.didTapOnCalloutView(annotation)
    }
    
    
}

