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
    var autoScaling = false
    var defaultPinIcon: UIImage?
    var canShowCallout: Bool?
    var isUserDraggingMap = false
    var lastSelectedAnnotationView: MKAnnotationView?
    var lastScaledAnnotation: BMAnnotation?
    let reuseIdentifier = "BMMapViewCell"
    let REGION_RADIUS = 50_000.0
  
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
extension BMAppleMapView {
    func setupUI() {
        loadViewFromNib()
        setupPanGesture()
        mapView.delegate = self
    }
    
    func setupPanGesture() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleMapDrag(_:)))
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    // Handle user-initiated map dragging.
    @IBAction func handleMapDrag(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            isUserDraggingMap = true
        }
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
