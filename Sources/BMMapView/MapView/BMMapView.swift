//
//  BMMapView.swift
//  AppleMapFramework
//
//  Created by Mahmoud Abdulwahab on 22/06/2023.
//

import UIKit
import MapKit

public class BMMapView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak private var mapView: MKMapView!
    
    // MARK: - Properties
    public weak var delegate: BMMapDelegate?
    private var defaultPinIcon: UIImage?
    private var canShowCallout: Bool?
    private var lastSelectedAnnotationView: MKAnnotationView?
    private var lastScaledAnnotation: BMAnnotation?
    private let reuseIdentifier = "BMMapViewCell"
    private let REGION_RADIUS = 50_000.0
    public var zoomLevel: Double? {
        getZoomLevel()
    }
    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    private func commonInit() {
        setupUI()
    }
}

// MARK: - Configurations
extension BMMapView {
    
    func setupUI() {
        loadViewFromNib()
        mapView.delegate = self
    }
}


extension BMMapView: MKMapViewDelegate {
    
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


extension BMMapView: BMMapInputType {
    
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
        annotations.forEach(addAnnotation)
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
        mapView.removeAnnotations(mapView.annotations)
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
        mapView.setCamera(camera, animated: animated)
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
            debugPrint("💥 -  Can't find annotation")
        }
    }
    
    public func fitAnnotationsInTheScreen(_ annotations: [BMAnnotation],
                                          edgePadding: UIEdgeInsets = UIEdgeInsets(top: 50,
                                                                                   left: 16,
                                                                                   bottom: 50, right: 16)) {
        addAnnotations(annotations)
        var zoomRect = MKMapRect.null
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

// MARK: - Private Handlers
private extension BMMapView {
    
    func addAnnotation(_ annotation: BMAnnotation) {
        let annotations = MKPointAnnotation()
        mapView.clearsContextBeforeDrawing = true
        annotations.title = annotation.title
        annotations.coordinate = annotation.coordinate
        mapView.addAnnotation(annotations)
    }
    
    func getZoomLevel() -> Double {
        let camera = mapView.camera
        let altitude = camera.altitude
        let zoomLevel = log2(360 * ((Double(mapView.bounds.size.width) / 256) / altitude))
        return zoomLevel
    }
}

final class AnnotationButton: UIButton {
    var annotation: MKPointAnnotation?
}
