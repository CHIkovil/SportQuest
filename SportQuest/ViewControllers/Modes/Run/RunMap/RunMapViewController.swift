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
    var runData: NSMutableAttributedString?
    
    //MARK: VIEW
    
    
    
    //MARK: runMapView
    lazy var runMapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 45
        view.overrideUserInterfaceStyle = .dark
        view.delegate = self
        return view
    }()
    
    //MARK: LABEL
    
    
    
    
    //MARK: runDataLabel
    lazy var runDataLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderColor = UIColor.clear.cgColor
        label.backgroundColor = UIColor.clear
        return label
    }()
    //MARK: BUTTON
    
    
    
    
    //MARK: exitButton
    lazy var exitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.clear.cgColor
        button.backgroundColor = UIColor.clear
        button.frame = CGRect(x: 0, y: 0 , width: 45, height: 45)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(named:"iconfinder.png"), for: .normal)
        button.addTarget(self, action: #selector(exitMap), for: .touchUpInside)
        return button
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
        view.addSubview(runDataLabel)
        view.addSubview(exitButton)
        
        createConstraintsRunMapView()
        createConstraintsRunDataLabel()
        createConstraintsExitButton()
    }
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        showRunDistance()
        guard let text = runData else {return}
        runDataLabel.attributedText = text
        
    }
    
    //MARK:  FUNC
    
    
    
    
    //MARK: createConstraintsRunMapView
    func createConstraintsRunMapView() {
        runMapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        runMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        runMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        runMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    //MARK: createConstraintsRunDataLabel
    func createConstraintsRunDataLabel() {
        runDataLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        runDataLabel.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        runDataLabel.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 150).isActive = true
        runDataLabel.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    //MARK: createConstraintsExitButton
    func createConstraintsExitButton() {
        exitButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        exitButton.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        exitButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 45).isActive = true
        exitButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    //MARK: showRunDistance
    func showRunDistance() {
        guard let coordinates = runCoordinates else {
            self.dismiss(animated: true)
            return
        }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        runMapView.addOverlay(polyline)
        addDistanceAnnotation(startLocation: coordinates[0], finishLocation: coordinates[coordinates.endIndex - 1] )
        setRunRegion(coordinates: coordinates)
    }
    
    
    //MARK: setRunRegion
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
    
    func addDistanceAnnotation(startLocation: CLLocationCoordinate2D, finishLocation:CLLocationCoordinate2D) {
        for (title, location) in [("start", startLocation), ("finish", finishLocation)] {
            let point = MKPointAnnotation()
            point.title = title
            point.coordinate = location
            runMapView.addAnnotation(point)
        }
    }
    
    //MARK: OBJC
    
    
    
    //MARK: exitMap
    @objc func exitMap() {
        self.dismiss(animated: true)
    }
}

extension RunMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let title = annotation.title else {
            return nil
        }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: title)
        switch annotation.title {
        case "start":
            annotationView.image = UIImage(named: "start.png")
            return annotationView
        case "finish":
            annotationView.image = UIImage(named: "finish.png")
            return annotationView
        default:
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKPolyline) {
            let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = UIColor.yellow
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

