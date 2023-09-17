//
//  BMMapView.swift
//  AppleMapFramework
//
//  Created by Mahmoud Abdulwahab on 22/06/2023.
//

import UIKit
import MapKit

public class BMAppleMapView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    public weak var delegate: BMMapDelegate?
    public var centerOfCameraPosition: CLLocationCoordinate2D?
    
    var defaultPinIcon: UIImage?
    var canShowCallout: Bool?
    var lastSelectedAnnotationView: MKAnnotationView?
    var lastScaledAnnotation: BMAnnotation?
    let reuseIdentifier = "BMMapViewCell"
    let REGION_RADIUS = 50_000.0
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
        mapView.showsUserLocation = true
    }
}

// MARK: - Configurations
extension BMAppleMapView {
    func setupUI() {
        loadViewFromNib()
        mapView.delegate = self
    }
}

// MARK: - Private Handlers
 extension BMAppleMapView {
    
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
