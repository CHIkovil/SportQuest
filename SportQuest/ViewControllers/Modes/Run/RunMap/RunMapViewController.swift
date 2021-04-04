//
//  RunMapViewController.swift.swift
//  SportQuest
//
//  Created by Никита Бычков on 03.04.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class RunMapViewController: UIViewController {
    
    private var customTransitioningDelegate = TransitionDelegate()
    var runCoordinates: [CLLocationCoordinate2D]?
    
    //MARK: runMapView
    lazy var runMapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 45
        view.overrideUserInterfaceStyle = .dark
        view.delegate = self
        return view
    }()
    //MARK: init
     override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
         super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
         configure()
     }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(runMapView)
        createConstraintsRunMapView()
    }
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        showRunDistance()
        
    }
    
    //MARK: createConstraintsRunMapView
    func createConstraintsRunMapView() {
        runMapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        runMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        runMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        runMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func showRunDistance() {
        guard let coordinates = runCoordinates else {
            self.dismiss(animated: true)
            return
        }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        runMapView.addOverlay(polyline)
        setRunRegion(coordinates: coordinates)
    }
    
    func setRunRegion(coordinates: [CLLocationCoordinate2D]){
        let runLatitude = coordinates.map {$0.latitude}
        let runLongitude = coordinates.map {$0.longitude}

        let minLatitude = runLatitude.min()!
        let minLongitude = runLongitude.min()!
        let maxLatitude = runLatitude.max()!
        let maxLongitude = runLongitude.max()!

        let c1 = CLLocation(latitude: minLatitude, longitude: minLongitude)

        let c2 = CLLocation(latitude: maxLatitude, longitude: maxLongitude)

        let zoom = c1.distance(from: c2)

        let location = CLLocationCoordinate2D(latitude: (maxLatitude+minLatitude)*0.5, longitude: (maxLongitude+minLongitude)*0.5)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: zoom + 100, longitudinalMeters: zoom + 100)

        runMapView.setRegion(region, animated: true)
    }
}

extension RunMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKPolyline) {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = UIColor.red
            polyline.lineWidth = 5
            return polyline
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

private extension RunMapViewController {
    func configure() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        transitioningDelegate = customTransitioningDelegate
    }
}
