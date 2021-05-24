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
    
    //MARK: runIntervalLabel
    lazy var runIntervalLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2"
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = .systemFont(ofSize: 25, weight: UIFont.Weight.bold)
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
        button.setImage(UIImage(named:"exit.png"), for: .normal)
        button.addTarget(self, action: #selector(exitMap), for: .touchUpInside)
        return button
    }()
    
    //MARK: runIntervalButton
    lazy var runIntervalButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.frame = CGRect(x: 0, y: 0 , width: 30, height: 30)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(named:"add.png"), for: .normal)
        button.addTarget(self, action: #selector(addRunInterval), for: .touchUpInside)
        return button
    }()
    
    //MARK: runDownIntervalButton
    lazy var runDownIntervalButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.frame = CGRect(x: 0, y: 0 , width: 30, height: 30)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.isEnabled = false
        button.setImage(UIImage(named:"minus.png"), for: .normal)
        button.addTarget(self, action: #selector(downRunInterval), for: .touchUpInside)
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
        view.addSubview(runIntervalLabel)
        view.addSubview(runIntervalButton)
        view.addSubview(runDownIntervalButton)
        
        createConstraintsRunMapView()
        createConstraintsRunDataLabel()
        createConstraintsExitButton()
        createConstraintsRunIntervalLabel()
        createConstraintsRunIntervalButton()
        createConstraintsRunDownIntervalButton()
    }
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        showRunDistance()
        guard let text = runData else {return}
        runDataLabel.attributedText = text
        addAnnotationInterval()
    }
    
    // MARK: CONSTRAINTS VIEW
    
    
    
    
    //MARK: createConstraintsRunMapView
    func createConstraintsRunMapView() {
        runMapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        runMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        runMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        runMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    // MARK: CONSTRAINTS LABEL
    
    
    
    
    
    //MARK: createConstraintsRunDataLabel
    func createConstraintsRunDataLabel() {
        runDataLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        runDataLabel.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        runDataLabel.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 150).isActive = true
        runDataLabel.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    //MARK: createConstraintsRunIntervalLabel
      func createConstraintsRunIntervalLabel() {
          runIntervalLabel.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: runIntervalButton.leadingAnchor).isActive = true
        runIntervalLabel.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: runIntervalButton.centerYAnchor).isActive = true
          runIntervalLabel.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 20).isActive = true
          runIntervalLabel.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 20).isActive = true
      }
    
    // MARK: CONSTRAINTS BUTTON
    
    
    
    
    
    //MARK: createConstraintsExitButton
    func createConstraintsExitButton() {
        exitButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        exitButton.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        exitButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 45).isActive = true
        exitButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    //MARK: createConstraintsRunIntervalButton
    func createConstraintsRunIntervalButton() {
        runIntervalButton.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: runDownIntervalButton.leadingAnchor,constant: -5).isActive = true
        runIntervalButton.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: runDownIntervalButton.centerYAnchor).isActive = true
        runIntervalButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 30).isActive = true
        runIntervalButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    //MARK: createConstraintsRunDownIntervalButton
    func createConstraintsRunDownIntervalButton() {
        runDownIntervalButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: exitButton.bottomAnchor,constant: 30).isActive = true
        runDownIntervalButton.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: exitButton.centerXAnchor).isActive = true
        runDownIntervalButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 30).isActive = true
        runDownIntervalButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    
     //MARK:  FUNC
    
    
    
    //MARK: addAnnotationInterval
    func addAnnotationInterval() {
        guard let runCoordinates = runCoordinates else{return}
        removeAllAnnotationInterval()
        var coordinateStages = runCoordinates.chunked(into: runCoordinates.count / Int(runIntervalLabel.text!)!)
        if coordinateStages.count != Int(runIntervalLabel.text!)!{
            let endStage = coordinateStages[coordinateStages.count - 1]
            coordinateStages.remove(at: coordinateStages.count - 1)
            coordinateStages[coordinateStages.count - 1].append(contentsOf: endStage)
        }
        let coordinatePoints: [CLLocationCoordinate2D] = coordinateStages.map {stage in
            return  stage[stage.count - 1]
        }
        
        for (index,coordinate) in coordinatePoints.enumerated() {
            let point = MKPointAnnotation()
            point.title = String(index)
            point.coordinate = coordinate
            if index < coordinatePoints.count - 1{
                runMapView.addAnnotation(point)
            }
        }
    }
    
    //MARK: removeAllAnnotationInterval
    func removeAllAnnotationInterval() {
        for annotation in runMapView.annotations {
            if annotation.title != "Start" && annotation.title != "Finish"{
                runMapView.removeAnnotation(annotation)
            }
        }
    }
    
    //MARK: showRunDistance
    func showRunDistance() {
        guard let coordinates = runCoordinates else {
            self.dismiss(animated: true)
            return
        }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        runMapView.addOverlay(polyline)
        addDistanceAnnotation(startLocation: coordinates[0], finishLocation: coordinates[coordinates.count - 1] )
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
        for (title, location) in [("Start", startLocation), ("Finish", finishLocation)] {
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
    
    @objc func addRunInterval() {
        runIntervalLabel.alpha = 0
        UIView.animate(withDuration: 0.5){[weak self] in
            guard let self = self else{return}
            let animation = CABasicAnimation(keyPath: "position")
            animation.fromValue = NSValue(cgPoint: CGPoint(x: self.runIntervalLabel.center.x, y: self.runIntervalLabel.center.y + 20))
            animation.toValue = NSValue(cgPoint: CGPoint(x: self.runIntervalLabel.center.x, y: self.runIntervalLabel.center.y))
            self.runIntervalLabel.layer.add(animation, forKey: "position")
            self.runIntervalLabel.text = String(Int(self.runIntervalLabel.text!)! + 1)
            self.runIntervalLabel.alpha = 1
        }
        if Int(self.runIntervalLabel.text!)! == 9 {
            runIntervalButton.isEnabled = false
        }else{
            runDownIntervalButton.isEnabled = true
        }
        addAnnotationInterval()
    }
    
    @objc func downRunInterval(){
        runIntervalLabel.alpha = 0
        UIView.animate(withDuration: 0.5){[weak self] in
            guard let self = self else{return}
            let animation = CABasicAnimation(keyPath: "position")
            animation.fromValue = NSValue(cgPoint: CGPoint(x: self.runIntervalLabel.center.x, y: self.runIntervalLabel.center.y + 20))
            animation.toValue = NSValue(cgPoint: CGPoint(x: self.runIntervalLabel.center.x, y: self.runIntervalLabel.center.y))
            self.runIntervalLabel.layer.add(animation, forKey: "position")
            self.runIntervalLabel.text = String(Int(self.runIntervalLabel.text!)! - 1)
            self.runIntervalLabel.alpha = 1
        }
        if Int(self.runIntervalLabel.text!)! == 2 {
            runDownIntervalButton.isEnabled = false
        }else{
            runIntervalButton.isEnabled = true
        }
        removeAllAnnotationInterval()
        addAnnotationInterval()
    }
}

extension RunMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let title = annotation.title else {
            return nil
        }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: title)
        switch annotation.title {
        case "Start":
            annotationView.image = UIImage(named: "start.png")
            return annotationView
        case "Finish":
            annotationView.image = UIImage(named: "finish.png")
            return annotationView
        default:
            annotationView.image = UIImage(named: "point.png")
            return annotationView
    
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

