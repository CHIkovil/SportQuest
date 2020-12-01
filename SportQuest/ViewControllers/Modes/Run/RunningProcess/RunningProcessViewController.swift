//
//  RunningProcessViewController.swift
//  SportQuest
//
//  Created by Никита Бычков on 01.12.2020.
//  Copyright © 2020 Никита Бычков. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftGifOrigin

class RunningProcessViewController: UIViewController {
    //MARK: LOCATION MANAGER
    
    
    
    //MARK: runningLocationManager
    lazy var runningLocationManager: CLLocationManager = {
        var locationManager = CLLocationManager()
        locationManager.distanceFilter = 10
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        return locationManager
    }()
    
    
    //MARK: VIEW
    
    
    
    //MARK: runnningBatmanImageView
     lazy var runnningBatmanImageView: UIImageView = {
         let imageView = UIImageView()
         imageView.translatesAutoresizingMaskIntoConstraints = false
         imageView.loadGif(name: "batman")
         return imageView
     }()
     
     //MARK: runningMapView
     lazy var runningMapView: MKMapView = {
         let view = MKMapView()
         view.translatesAutoresizingMaskIntoConstraints = false
         view.overrideUserInterfaceStyle = .dark
         view.delegate = self
         return view
     }()
    
     override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2314966023, green: 0.2339388728, blue: 0.2992851734, alpha: 1)
        createTheView()
        view.addSubview(runnningBatmanImageView)
        view.addSubview(runningMapView)
        createConstraintsRunnningBatmanImageView()
        createConstraintsRunningMapView()
    }
    
    //MARK: FUNC
    private func createTheView() {

        let xCoord = self.view.bounds.width / 2 - 50
        let yCoord = self.view.bounds.height / 2 - 50

        let centeredView = UIView(frame: CGRect(x: xCoord, y: yCoord, width: 150, height: 150))
        centeredView.backgroundColor = .blue
        self.view.addSubview(centeredView)
    }
    
    //MARK: CONSTRAINTS VIEW

    
    
    //MARK: createConstraintsRunnningBatmanImageView
     func createConstraintsRunnningBatmanImageView() {
         runnningBatmanImageView.topAnchor.constraint(equalTo: runningMapView.bottomAnchor, constant: 10).isActive = true
         runnningBatmanImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
         runnningBatmanImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
         runnningBatmanImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
     }
     
     //MARK: createConstraintsRunningMapView
      func createConstraintsRunningMapView() {
        runningMapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
         runningMapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
          runningMapView.heightAnchor.constraint(equalToConstant: 170).isActive = true
      }
}

extension RunningProcessViewController: MKMapViewDelegate {
    
}

extension RunningProcessViewController: CLLocationManagerDelegate {
    func checkLocationAuthorization(authorizationStatus: CLAuthorizationStatus? = nil) {
        switch (authorizationStatus ?? CLLocationManager.authorizationStatus()) {
        case .authorizedAlways, .authorizedWhenInUse:
            runningLocationManager.startUpdatingLocation()
            runningMapView.showsUserLocation = true
        case .restricted, .denied: break
        case .notDetermined:
            runningLocationManager.requestWhenInUseAuthorization()
        @unknown default:
            runningLocationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationAuthorization(authorizationStatus: status)
    }
    
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
          guard let location = locations.last else { return }

          let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
          let region = MKCoordinateRegion(center: location.coordinate, span: span)
          runningMapView.setRegion(region, animated: true)
      }
}
