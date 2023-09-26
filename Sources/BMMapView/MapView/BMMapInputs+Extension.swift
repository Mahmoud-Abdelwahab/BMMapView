//
//  BMMapInputs+Extension.swift
//  
//
//  Created by Mahmoud Abdulwahab on 01/08/2023.
//

import MapKit

extension BMAppleMapView: BMMapInputType {
    
    public var zoomLevel: Double? {
        getZoomLevel()
    }
    
    public func showsUserLocation(isShown: Bool) {
        mapView.showsUserLocation = isShown
    }
    
    public func selectAnnotation(_ annotation: BMAnnotation,
                                 regionRadius: Double?) {
        var radius = REGION_RADIUS
        removeAnnotations([annotation])
        addAnnotations([annotation])
        if let regionRadius = regionRadius {
            radius = regionRadius
        }
        centerToAnnotation(annotation,
                           regionRadius: radius)
    }
    
    public func addAnnotations(_ annotations: [BMAnnotation]) {
        mapView.clearsContextBeforeDrawing = true
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }
    
    public func centerToAnnotation(_ annotation: BMAnnotation,
                                   regionRadius: Double?) {
        var radius = REGION_RADIUS
        if let regionRadius = regionRadius {
            radius = regionRadius
        }
        let coordinateRegion = MKCoordinateRegion(
            center: annotation.coordinate,
            latitudinalMeters: radius,
            longitudinalMeters: radius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    public func removeAnnotations(_ annotations: [BMAnnotation]) {
        mapView.removeAnnotations(annotations)
    }
    
    public func animateToAnnotation(_ annotation: BMAnnotation,
                                    zoomLevel: Double? = nil,
                                    animated: Bool = true) {
        let camera: MKMapCamera
        if let zoomLevel = zoomLevel {
            let currentZoom = getZoomLevel()
            let altitude = pow(2, currentZoom - zoomLevel) * (Double(mapView.bounds.size.width) / 2)
            camera = MKMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: altitude, pitch: 0, heading: 0)
        } else {
            camera = MKMapCamera(lookingAtCenter: annotation.coordinate,
                                 fromDistance: mapView.camera.altitude, pitch: 0, heading: 0)
        }
        mapView.delegate = nil
        mapView.setCamera(camera, animated: animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.mapView.delegate = self
        }
    }
    
    public func resetAnnotationScaling() {
        if let lastAnnotationView = lastSelectedAnnotationView {
            if #available(iOS 14.0, *) {
                lastAnnotationView.zPriority = .min
            }
            UIView.animate(withDuration: 0.1) {
                lastAnnotationView.transform = CGAffineTransform.identity
            }
        }
    }
    
    public func scaleAnnotation(_ annotation: BMAnnotation,
                                selectedScale: CGFloat = 1.5) {
        let selectedAnnotation =  mapView.annotations.last(where: { $0.coordinate == annotation.coordinate })
                
        if let selectedAnnotation = selectedAnnotation, let selectedAnnotationView = mapView.view(for: selectedAnnotation) , selectedAnnotationView !=  lastSelectedAnnotationView {
            resetAnnotationScaling()
            let transform = CGAffineTransform(scaleX: selectedScale, y: selectedScale)
            UIView.animate(withDuration: 0.2) {
                selectedAnnotationView.transform = transform
            }
            if #available(iOS 14.0, *) {
                selectedAnnotationView.zPriority = .max
            }
            lastSelectedAnnotationView = selectedAnnotationView
        } else {
            if selectedAnnotation != nil {
                /// annotation is exists in apple map but the user is far away from the location so mapView.view(for: selectedAnnotation) this func can't find selectAnnotation view because it's not in the visible bounds.
                lastScaledAnnotation = annotation
                autoScaling = true
            } else {
                debugPrint("💥 -  Can't find annotation")
            }
        }
    }
    
    public func fitAnnotationsInTheScreen(_ annotations: [BMAnnotation],
                                          edgePadding: UIEdgeInsets = UIEdgeInsets(top: 50,
                                                                                   left: 16,
                                                                                   bottom: 50,
                                                                                   right: 16)) {
        addAnnotations(annotations)
        var zoomRect = MKMapRect.null
        centerOfCameraPosition = mapView.centerCoordinate
        for branch in annotations {
            let annotationPoint = MKMapPoint(branch.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.1, height: 0.1)
            zoomRect = zoomRect.union(pointRect)
        }
        mapView.setVisibleMapRect(zoomRect, edgePadding: edgePadding, animated: true)
    }
    
    public func setDefaultPinIcon(with icon: UIImage) {
        defaultPinIcon = icon
    }
    
    public func shouldShowCalloutView(_ isShown: Bool) {
        canShowCallout = isShown
    }
}
