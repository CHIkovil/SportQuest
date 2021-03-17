//
//  RunProcessViewController.swift
//  SportQuest
//
//  Created by Никита Бычков on 01.12.2020.
//  Copyright © 2020 Никита Бычков. All rights reserved.
//
import Foundation
import UIKit
import MapKit
import CoreLocation
import SwiftGifOrigin
import CoreData

class RunProcessViewController: UIViewController {
    
    private var customTransitioningDelegate = RunProcessTransitionDelegate()
    var runTime:Int = 0
    var runCoordinates: [CLLocationCoordinate2D] = []
    var runDistance: Int = 0
    
    var runDataTransfer: ((Int, Int, String, String) -> ())?
    
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
        view.layer.cornerRadius = 45
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
    
    //MARK: runDistanceLabel
    lazy var runDistanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: label.font.fontName, size: 15)
        label.text = "0m"
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
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(named:"prize.png"), for: .normal)
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
        createConstraintsRunImageView()
        createConstraintsRunMapView()
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
            if self.runTime == 86400 {
                self.dismiss(animated: true, completion: nil)
            }
            self.runTime += 1
            let (hours,minutes,seconds) = self.secondsToHoursMinutesSeconds(seconds: self.runTime)
            self.runTimerLabel.text = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        }
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    //MARK: CONSTRAINTS VIEW

    
    
    //MARK: createConstraintsRunImageView
     func createConstraintsRunImageView() {
         runBatmanImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
         runBatmanImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
         runBatmanImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        runBatmanImageView.topAnchor.constraint(equalTo: runMapView.bottomAnchor, constant: 10).isActive = true
     }
     
     //MARK: createConstraintsRunMapView
      func createConstraintsRunMapView() {
        runMapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
         runMapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        runMapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
          runMapView.heightAnchor.constraint(equalToConstant: 170).isActive = true
      }
    
    //MARK: CONSTRAINTS LABEL
    
    
    
    //MARK: createConstraintsRunTimerLabel
    func createConstraintsRunTimerLabel() {
        runTimerLabel.topAnchor.constraint(equalTo: runMapView.bottomAnchor, constant: 20).isActive = true
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

    //MARK: CONSTRAINTS BUTTON
    
    
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
            
            runDistance += Int(from.distance(from: to))
            
            if from.distance(from: to) / 1000 > 1.0 {
                return runDistanceLabel.text = String(runDistance / 1000) + "km" + " " + String(runDistance % 1000) + "m"
            }
            else{
                return runDistanceLabel.text = String(runDistance) + "m"
            }
   
        }
    }
    
    @objc func stopRun() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "RunData", in: context)
        let newRunData = NSManagedObject(entity: entity!, insertInto: context)
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let currentDate = dateFormatter.string(from: Date())
        let coordinates: String = runCoordinates.map {String($0.latitude) + " " + String($0.longitude)}.joined(separator: ",")
        
        newRunData.setValue(coordinates, forKey: "coordinates")
        newRunData.setValue(runTime, forKey: "time")
        newRunData.setValue(runDistance, forKey: "distance")
        newRunData.setValue(currentDate, forKey: "date")
        
        do{
            try context.save()
            if let runDataTransfer = runDataTransfer{
                runDataTransfer(runTime, runDistance, coordinates, currentDate)
            }
            self.dismiss(animated: true)
        }
        catch{
            self.dismiss(animated: true)
        }
        
    }
    
}

//MARK: extension
extension RunProcessViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "MyCustomAnnotation"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            if mapView.annotations.count == 1{
                annotationView!.image = UIImage(named: "batman.png")
            }else{
                annotationView!.image = UIImage(named: "queen.png")
            }
            return annotationView
        } else {
            if mapView.annotations.count == 1{
                annotationView!.image = UIImage(named: "batman.png")
            } else{
                annotationView!.image = UIImage(named: "queen.png")
            }
            annotationView!.annotation = annotation
            return annotationView
        }
      
    }


    func updateLocationOnMap(to location: CLLocation, with title: String?) {

        let point = MKPointAnnotation()
        point.title = title
        point.coordinate = location.coordinate
        if runMapView.annotations.count > 1 {
            self.runMapView.removeAnnotation(runMapView.annotations.last!)
            self.runMapView.addAnnotation(point)
        } else{
            self.runMapView.addAnnotation(point)
        }
        let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
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
        updateLocationOnMap(to: runLocationManager.location!, with: "Warrior")
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

