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
    var runRegionImage: Data? {
        get{return nil}
        set{
            guard let newValue = newValue else{
                self.dismiss(animated: true)
                return
            }
            saveRunData(regionImage: newValue)
        }
    }
    
    var runDataTransfer: ((Int, Int, String, String, Data) -> ())?
    
    //MARK: LOCATION MANAGER
    
    
    
    //MARK: runningLocationManager
    lazy var runLocationManager: CLLocationManager = {
        var locationManager = CLLocationManager()
        locationManager.distanceFilter = 5
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
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
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] tempTimer in
            guard let self = self else { return }
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
    

    
    //MARK: drawRunDistance
        func drawRunDistance(){
            let polyline = MKPolyline(coordinates: [runCoordinates[runCoordinates.count - 2], runCoordinates.last!], count: 2)
            self.runMapView.addOverlay(polyline)
        }
    
    //MARK: parseRunDistanceToLabel
    func parseRunDistanceToLabel() {
        if runCoordinates.count > 1 {
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
    
    //MARK: setRunRegion
    func setRunRegion() {
        self.runLocationManager.stopUpdatingLocation()
        let runLatitude = runCoordinates.map {$0.latitude}
        let runLongitude = runCoordinates.map {$0.longitude}

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
    
    //MARK: getSnapshotRegion
    func getSnapshotRegion() {
        let options = MKMapSnapshotter.Options()
        options.region = runMapView.region
        options.size = runMapView.frame.size
        options.scale = UIScreen.main.scale

        let snapshotter = MKMapSnapshotter(options: options)
        
        snapshotter.start {[weak self] snapshot, error in
            guard let snapshot = snapshot, let self = self else{return}
            let resizeSnapshot = snapshot.image.resize(newSize: CGSize(width: 30, height: 30))
            self.runRegionImage = resizeSnapshot.pngData()
        }
    }
    
    //MARK: saveRunData
    func saveRunData(regionImage: Data) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "RunData", in: context)
        let newRunData = NSManagedObject(entity: entity!, insertInto: context)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let currentDate = dateFormatter.string(from: Date())
        let coordinates: String = self.runCoordinates.map {String($0.latitude) + " " + String($0.longitude)}.joined(separator: ",")
        
        newRunData.setValue(coordinates, forKey: "coordinates")
        newRunData.setValue(self.runTime, forKey: "time")
        newRunData.setValue(self.runDistance, forKey: "distance")
        newRunData.setValue(currentDate, forKey: "date")
        newRunData.setValue(regionImage, forKey: "regionImage")
        
        do{
            try context.save()
            if let runDataTransfer = self.runDataTransfer{
                runDataTransfer(self.runTime, self.runDistance, coordinates, currentDate, regionImage)
            }
            self.dismiss(animated: true)
        }
        catch{
            self.dismiss(animated: true)
        }
    }
    
    //MARK: stopRun
    @objc func stopRun() {
        if runCoordinates.isEmpty || runCoordinates.count == 1{
            self.dismiss(animated: true)
            return
        }
        
        setRunRegion()
        getSnapshotRegion()
    }
    
}

//MARK: extension
extension RunProcessViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let identifier = "Annotation"
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView.image = UIImage(named: "batman.png")
        return annotationView
    }
    
    //MARK: showLocationOnMap
    func showLocationOnMap(to location: CLLocation, with title: String?) {
        runMapView.removeAnnotations(runMapView.annotations)
        let point = MKPointAnnotation()
        point.title = title
        point.coordinate = location.coordinate
        runMapView.addAnnotation(point)
        let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
        self.runMapView.setRegion(viewRegion, animated: true)
    }
    
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

extension RunProcessViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = runLocationManager.location else{
            self.dismiss(animated: true)
            return
        }
        runCoordinates.append(location.coordinate)
        showLocationOnMap(to: location, with: "Warrior")
        if runCoordinates.count > 1{
            drawRunDistance()
            parseRunDistanceToLabel()
        }
    }
    
}

extension UIImage {
    func resize(newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let image = renderer.image { [weak self] _ in
            guard let self = self else{return}
            self.draw(in: CGRect.init(origin: CGPoint.zero, size: newSize))
        }

        return image.withRenderingMode(self.renderingMode)
    }
}

private extension RunProcessViewController {
    func configure() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        transitioningDelegate = customTransitioningDelegate
    }
}

