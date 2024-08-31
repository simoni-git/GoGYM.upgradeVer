//
//  KalmanFilter.swift
//  GoGYM.upGrade
//
//  Created by 시모니 on 8/31/24.
//

import UIKit
import CoreLocation

class KalmanFilter {
    private var lastEstimatedPosition: CLLocationCoordinate2D?
    private var estimatedError: Double = 1.0
    private var measurementError: Double = 5.0 // 측정 오류
    private var processError: Double = 0.01 // 프로세스 오류

    func filter(coordinate: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        guard let lastPosition = lastEstimatedPosition else {
            lastEstimatedPosition = coordinate
            return coordinate
        }

        let kalmanGain = estimatedError / (estimatedError + measurementError)
        
        let filteredLatitude = lastPosition.latitude + kalmanGain * (coordinate.latitude - lastPosition.latitude)
        let filteredLongitude = lastPosition.longitude + kalmanGain * (coordinate.longitude - lastPosition.longitude)
        
        estimatedError = (1.0 - kalmanGain) * estimatedError + abs(lastPosition.latitude - filteredLatitude) * processError
        
        let filteredCoordinate = CLLocationCoordinate2D(latitude: filteredLatitude, longitude: filteredLongitude)
        lastEstimatedPosition = filteredCoordinate
        return filteredCoordinate
    }
}
