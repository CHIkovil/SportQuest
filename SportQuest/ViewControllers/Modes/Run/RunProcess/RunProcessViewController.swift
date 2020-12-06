//
//  RunProcessViewController.swift
//  SportQuest
//
//  Created by Никита Бычков on 01.12.2020.
//  Copyright © 2020 Никита Бычков. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftGifOrigin

class RunProcessViewController: UIViewController {
    
    private var customTransitioningDelegate = RunProcessTransitionDelegate()
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    
    //MARK: LOCATION MANAGER
    
    
    
    //MARK: runningLocationManager
    lazy var runLocationManager: CLLocationManager = {
        var locationManager = CLLocationManager()
        locationManager.distanceFilter = 5
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        return locationManager
    }()
    
    
    //MARK: VIEW
    
    
    
    //MARK: runnningBatmanImageView
     lazy var runBatmanImageView: UIImageView = {
         let imageView = UIImageView()
         imageView.translatesAutoresizingMaskIntoConstraints = false
         imageView.loadGif(name: "batman")
         return imageView
     }()
     
     //MARK: runningMapView
     lazy var runMapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.overrideUserInterfaceStyle = .dark
        view.delegate = self
        return view
     }()
    
    //MARK: LABEL
    
    
    
    //MARK: runTimerLabel
    lazy var runTimerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00:00"
        label.font = UIFont(name: label.font.fontName, size: 30)
        label.textColor = .white
        return label
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
        view.backgroundColor = #colorLiteral(red: 0.2314966023, green: 0.2339388728, blue: 0.2992851734, alpha: 1)
        view.addSubview(runBatmanImageView)
        view.addSubview(runMapView)
        view.addSubview(runTimerLabel)
        createConstraintsRunnningBatmanImageView()
        createConstraintsRunningMapView()
        createConstraintsRunTimerLabel()
        runLocationManager.startUpdatingLocation()
        startTimer()
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {tempTimer in
            if self.hours == 24 {
                self.dismiss(animated: true, completion: nil)
            }
            
            if self.seconds == 59 {
                self.seconds = 0
                if self.minutes == 59 {
                    self.minutes = 0
                    self.hours += 1
                }
                else{
                    self.minutes += 1
                }
            }
            else{
                self.seconds += 1
            }
            self.runTimerLabel.text = String(format:"%02i:%02i:%02i", self.hours, self.minutes, self.seconds)
        }
        
    }
    //MARK: CONSTRAINTS VIEW

    
    
    //MARK: createConstraintsRunnningBatmanImageView
     func createConstraintsRunnningBatmanImageView() {
         
        runBatmanImageView.centerYAnchor.constraint(equalTo: runTimerLabel.centerYAnchor).isActive = true
         runBatmanImageView.trailingAnchor.constraint(equalTo: runTimerLabel.leadingAnchor).isActive = true
         runBatmanImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
         runBatmanImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
     }
     
     //MARK: createConstraintsRunningMapView
      func createConstraintsRunningMapView() {
        runMapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
         runMapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        runMapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
          runMapView.heightAnchor.constraint(equalToConstant: 170).isActive = true
      }
    
    //MARK: CONSTRAINTS LABEL
    
    
    
    //MARK: createConstraintsRunTimerLabel
    func createConstraintsRunTimerLabel() {
        runTimerLabel.topAnchor.constraint(equalTo: runMapView.bottomAnchor, constant: 10).isActive = true
        runTimerLabel.centerXAnchor.constraint(equalTo:  view.centerXAnchor).isActive = true
       runTimerLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        runTimerLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
}

//MARK: extension
extension RunProcessViewController: MKMapViewDelegate {

}

extension RunProcessViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            runLocationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         updateLocationOnMap(to: runLocationManager.location!, with: nil)
    }
    
    func updateLocationOnMap(to location: CLLocation, with title: String?) {
        let point = MKPointAnnotation()
        point.title = title
        point.coordinate = location.coordinate
        self.runMapView.removeAnnotations(self.runMapView.annotations)
        self.runMapView.addAnnotation(point)
        let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        self.runMapView.setRegion(viewRegion, animated: true)
    }
}

private extension RunProcessViewController {
    func configure() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        transitioningDelegate = customTransitioningDelegate
    }
}
