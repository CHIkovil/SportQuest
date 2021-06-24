//
//  ProgressMapPresenter.swift
//  SportQuest
//
//  Created by Никита Бычков on 22.06.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import MapKit

class ProgressMapPresenter {
    private let progressMapService:ProgressMapService
    weak private var progressMapViewDelegate : ProgressMapViewDelegate?
    
    init(progressMapService:ProgressMapService){
        self.progressMapService = progressMapService
    }
    
    func setViewDelegate(progressMapViewDelegate:ProgressMapViewDelegate?){
        self.progressMapViewDelegate = progressMapViewDelegate
    }
    
    //MARK: setRunDistance
    func setRunDistance() {
        progressMapService.getRunProgress {[weak self] progress in
            guard let self = self else{return}
            guard let progress = progress else{
                self.progressMapViewDelegate!.displayRunDistance(distance: nil)
                return
            }
            
            let polyline = MKPolyline(coordinates: progress.coordinates, count: progress.coordinates.count)
            
            let startCoordinate = progress.coordinates[0]
            let endCoordinate = progress.coordinates[progress.coordinates.count - 1]
            
            let runLatitude = progress.coordinates.map {$0.latitude}
            let runLongitude = progress.coordinates.map {$0.longitude}
            let minLatitude = runLatitude.min()!
            let minLongitude = runLongitude.min()!
            let maxLatitude = runLatitude.max()!
            let maxLongitude = runLongitude.max()!
            let c1 = CLLocation(latitude: minLatitude, longitude: minLongitude)
            let c2 = CLLocation(latitude: maxLatitude, longitude: maxLongitude)
            let zoom = c1.distance(from: c2)
            let location = CLLocationCoordinate2D(latitude: (maxLatitude+minLatitude)*0.5, longitude: (maxLongitude+minLongitude)*0.5)
            let region = MKCoordinateRegion(center: location, latitudinalMeters: zoom + 100, longitudinalMeters: zoom + 100)
              
            self.progressMapViewDelegate!.displayRunDistance(distance: Distance(polyline: polyline, region: region, startCoordinate: startCoordinate, endCoordinate: endCoordinate))
        }
    }
    
    //MARK: setIntervalAnnotation
    func setIntervalAnnotation(countInterval:Int) {
        progressMapService.getRunProgress {[weak self] progress in
            guard let self = self,let progress = progress else{return}
            let stages = progress.coordinates.chunked(into: progress.coordinates.count / countInterval)[0..<countInterval - 1]
            
            let points: [CLLocationCoordinate2D] = stages.map {stage in
                return  stage[stage.count - 1]
                }
            self.progressMapViewDelegate!.displayIntervalAnnotation(points: points)
 
        }
    }
    
    func setProgressInfo(){
        progressMapService.getRunProgress {[weak self] progress in
            guard let self = self,let progress = progress else{return}
            self.progressMapViewDelegate!.displayProgressInfo(text: progress.info)
            
        }
    }
}
