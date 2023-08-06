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
        delegate?.didDrageOnMap()
    }
    
    public func mapView(_ mapView: MKMapView,
                        viewFor annotation: MKAnnotation) -> MKAnnotationView? {
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
    
    
    @objc private func pinAction(_ pinButton: AnnotationButton) {
        guard let annotationPointModel = pinButton.annotation else { return }
        let annotation = BMAnnotation(coordinate: annotationPointModel.coordinate, title: annotationPointModel.title, subtitle: annotationPointModel.subtitle)
        delegate?.didTapOnCalloutView(annotation)
    }
}

