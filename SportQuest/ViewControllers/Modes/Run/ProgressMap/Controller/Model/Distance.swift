//
//  Distance.swift
//  SportQuest
//
//  Created by Никита Бычков on 22.06.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import MapKit

struct Distance {
    let polyline:MKPolyline
    let region:MKCoordinateRegion
    let startCoordinate: CLLocationCoordinate2D
    let endCoordinate: CLLocationCoordinate2D
}
