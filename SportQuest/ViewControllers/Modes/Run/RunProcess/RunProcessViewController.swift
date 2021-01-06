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
import CoreData

class RunProcessViewController: UIViewController {
    
    private var customTransitioningDelegate = RunProcessTransitionDelegate()
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    var runCoordinates: [CLLocationCoordinate2D] = []
    var runDistance: Int = 0;
    
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
        view.layer.cornerRadius = 45
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
    
    //MARK: runDistanceLabel
    lazy var runDistanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: label.font.fontName, size: 20)
        label.textColor = .white
        return label
    }()
    
    //MARK: init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configure()
    }
    
    //MARK: BUTTON
    
    
    
    //MARK: stopRunButton
    lazy var stopRunButton: UIButton = {
        let button = UIButton(frame:CGRect(x: 0, y: 0, width: 60, height: 60))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.red.cgColor
        button.setTitle("Finish", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(stopRun), for: .touchUpInside)
        return button
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    //MARK: viewDidLoad
     override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.cornerRadius = 45
        view.backgroundColor = #colorLiteral(red: 0.2314966023, green: 0.2339388728, blue: 0.2992851734, alpha: 1)
        view.addSubview(runBatmanImageView)
        view.addSubview(runMapView)
        view.addSubview(runTimerLabel)
        view.addSubview(runDistanceLabel)
        view.addSubview(stopRunButton)
        createConstraintsRunnningBatmanImageView()
        createConstraintsRunningMapView()
        createConstraintsRunTimerLabel()
        createConstraintsRunDistanceLabel()
        createConstraintsStopRunButton()

    }
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
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
         runBatmanImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
         runBatmanImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
         runBatmanImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        runBatmanImageView.topAnchor.constraint(equalTo: runMapView.bottomAnchor, constant: 10).isActive = true
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
        runTimerLabel.leadingAnchor.constraint(equalTo:  runBatmanImageView.trailingAnchor).isActive = true
        runTimerLabel.widthAnchor.constraint(equalToConstant: 115).isActive = true
        runTimerLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    //MARK: createConstraintsRunDistanceLabel
    func createConstraintsRunDistanceLabel() {
        runDistanceLabel.topAnchor.constraint(equalTo: runTimerLabel.bottomAnchor).isActive = true
       runDistanceLabel.centerXAnchor.constraint(equalTo:  runTimerLabel.centerXAnchor).isActive = true
        runDistanceLabel.widthAnchor.constraint(equalToConstant: 115).isActive = true
       runDistanceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    //MARK: CONSTRAINTS LABEL
    
    
    //MARK: createConstraintsStopRunButton
    func createConstraintsStopRunButton() {
        stopRunButton.leadingAnchor.constraint(equalTo: runTimerLabel.trailingAnchor, constant:  5).isActive = true
        stopRunButton.centerYAnchor.constraint(equalTo: runBatmanImageView.centerYAnchor).isActive = true
        stopRunButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        stopRunButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    //MARK: FUNC
    func drawRunDistance(){
        runCoordinates.append(runLocationManager.location!.coordinate)
        let geodesic = MKGeodesicPolyline(coordinates: runCoordinates, count: runCoordinates.count)
        self.runMapView.addOverlay(geodesic)
    }
    
    func showRunDistanceToLabel(){
        if runCoordinates.count != 1 {
            let to = CLLocation(latitude: runLocationManager.location!.coordinate.latitude, longitude: runLocationManager.location!.coordinate.longitude)
            let from = CLLocation(latitude: runCoordinates[runCoordinates.count - 2].latitude, longitude: runCoordinates[runCoordinates.count - 2].longitude)
            
            if from.distance(from: to) / 1000 > 1.0 {
                return runDistanceLabel.text = String(Int(from.distance(from: to) / 1000)) + "km" + " " + String(Int(from.distance(from: to))) + "m"
            }
            else{
                return runDistanceLabel.text = String(Int(from.distance(from: to))) + "m"
            }
   
        }
    }
    
    @objc func stopRun() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "RunData", in: context)
        let newRunData = NSManagedObject(entity: entity!, insertInto: context)
        
        do {
            let data = runCoordinates.map { String($0.latitude) + " " +  String($0.longitude)}
            let currentDate = Date().timeIntervalSinceReferenceDate
            newRunData.setValue(data, forKey: "coordinates")
            newRunData.setValue(runDistanceLabel.text, forKey: "distance")
            newRunData.setValue(runTimerLabel.text, forKey: "runtime")
            newRunData.setValue(currentDate, forKey: "date")
            try context.save()
            self.dismiss(animated: true)
          } catch {
            self.dismiss(animated: true)
        }
    }
    
}

//MARK: extension
extension RunProcessViewController: MKMapViewDelegate {
    
    func updateLocationOnMap(to location: CLLocation, with title: String?) {
        let point = MKPointAnnotation()
        point.title = title
        point.coordinate = location.coordinate
        self.runMapView.removeAnnotations(self.runMapView.annotations)
        self.runMapView.addAnnotation(point)
        let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10, longitudinalMeters: 10)
        self.runMapView.setRegion(viewRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKPolyline.self){
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
                polylineRenderer.fillColor = UIColor.red
                polylineRenderer.strokeColor = UIColor.red
                polylineRenderer.lineWidth = 2
            
            return polylineRenderer
     }
        return MKOverlayRenderer(overlay: overlay)
    }
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
        drawRunDistance()
        showRunDistanceToLabel()
    }
    
}

private extension RunProcessViewController {
    func configure() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        transitioningDelegate = customTransitioningDelegate
    }
}

