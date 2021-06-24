//
//  ProgressMapViewController.swift.swift
//  SportQuest
//
//  Created by Никита Бычков on 03.04.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ProgressMapViewController: UIViewController {
    
    private var customTransitioningDelegate = TransitionDelegate()
    
    var progressMapView:ProgressMapView!
    var progressMapPresenter:ProgressMapPresenter!
    
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
        progressMapPresenter.setViewDelegate(progressMapViewDelegate: self)
        view.frame.size = CGSize(width: 300, height: 300)
        progressMapView = ProgressMapView(frame: view.frame)
        view.addSubview(progressMapView)
    }
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        addTargetButton()
        setMapViewDelegate()
        progressMapPresenter.setRunDistance()
        progressMapPresenter.setIntervalAnnotation(countInterval: Int(self.progressMapView.runIntervalLabel.text!)!)
        progressMapPresenter.setProgressInfo()
    }
    
}

//MARK: extension
extension ProgressMapViewController:ProgressMapViewDelegate {
    //MARK: addTargetButton
    func addTargetButton() {
        progressMapView.exitButton.addTarget(self, action: #selector(exitMap), for: .touchUpInside)
        progressMapView.runIntervalButton.addTarget(self, action: #selector(addRunInterval), for: .touchUpInside)
        progressMapView.runDownIntervalButton.addTarget(self, action: #selector(deleteRunInterval), for: .touchUpInside)
    }
    
    //MARK: setMapViewDelegate
    func setMapViewDelegate() {
        progressMapView.runMapView.delegate = self
    }
    
    //MARK: displayRunDistance
    func displayRunDistance(distance:Distance?) {
        guard let distance = distance else {
            self.dismiss(animated: true)
            return
        }
        
        for (title, location) in [("Start", distance.startCoordinate), ("Finish", distance.endCoordinate )] {
            let point = MKPointAnnotation()
            point.title = title
            point.coordinate = location
            progressMapView.runMapView.addAnnotation(point)
        }
       
        progressMapView.runMapView.addOverlay(distance.polyline)
        progressMapView.runMapView.setRegion(distance.region, animated: true)
    }
    
    //MARK: displayIntervalAnnotation
    func displayIntervalAnnotation(points:[CLLocationCoordinate2D]) {
        for annotation in progressMapView.runMapView.annotations {
            if annotation.title != "Start" && annotation.title != "Finish"{
                progressMapView.runMapView.removeAnnotation(annotation)
            }
        }
        
        for (index,coordinate) in points.enumerated() {
            let point = MKPointAnnotation()
            point.title = String(index)
            point.coordinate = coordinate
            progressMapView.runMapView.addAnnotation(point)
        }
     }
    
    //MARK: displayIntervalAnnotation
    func displayProgressInfo(text: NSMutableAttributedString) {
        progressMapView.runDataLabel.attributedText = text
    }
}

extension ProgressMapViewController {
    //MARK: exitMap
    @objc func exitMap() {
        self.dismiss(animated: true)
    }
    
    //MARK: addRunInterval
    @objc func addRunInterval() {
        animateLabel(addValue: 1)
        if Int(progressMapView.runIntervalLabel.text!)! == 9 {
            progressMapView.runIntervalButton.isEnabled = false
        }else{
            progressMapView.runDownIntervalButton.isEnabled = true
        }
        progressMapPresenter.setIntervalAnnotation(countInterval: Int(progressMapView.runIntervalLabel.text!)!)
    }
    
    //MARK: deleteRunInterval
    @objc func deleteRunInterval(){
        animateLabel(addValue: -1)
        if Int(progressMapView.runIntervalLabel.text!)! == 2 {
            progressMapView.runDownIntervalButton.isEnabled = false
        }else{
            progressMapView.runIntervalButton.isEnabled = true
        }
        progressMapPresenter.setIntervalAnnotation(countInterval: Int(progressMapView.runIntervalLabel.text!)!)
    }
    
    //MARK: animateLabel
    func animateLabel(addValue: Int) {
        progressMapView.runIntervalLabel.alpha = 0
        UIView.animate(withDuration: 0.5){[weak self] in
            guard let self = self else{return}
            
            let animation = CABasicAnimation(keyPath: "position")
            animation.fromValue = NSValue(cgPoint: CGPoint(x: self.progressMapView.runIntervalLabel.center.x, y: self.progressMapView.runIntervalLabel.center.y + 20))
            animation.toValue = NSValue(cgPoint: CGPoint(x: self.progressMapView.runIntervalLabel.center.x, y: self.progressMapView.runIntervalLabel.center.y))

            self.progressMapView.runIntervalLabel.layer.add(animation, forKey: "position")
            self.progressMapView.runIntervalLabel.text = String(Int(self.progressMapView.runIntervalLabel.text!)! + addValue)
            self.progressMapView.runIntervalLabel.alpha = 1
        }
    }
}

extension ProgressMapViewController: MKMapViewDelegate {
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

private extension ProgressMapViewController {
    func configure() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        transitioningDelegate = customTransitioningDelegate
    }
}

