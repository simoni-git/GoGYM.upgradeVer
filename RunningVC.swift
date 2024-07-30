//
//  RunningVC.swift
//  GoGYM.upGrade
//
//  Created by 시모니 on 7/29/24.
//

import UIKit
import CoreLocation
import MapKit

class RunningVC: UIViewController {
    
    
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var pauseBtn: UIButton!
    
    
    var countDownTimer: Timer?
    var countDownValue: Int = 3
    
    var runningTimer: Timer?
    var runningTime: Int = 0
    var mkMapViewDelegate: MKMapViewDelegate?
    
    var totalDistance: Double = 0
    
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        manager.delegate = self
        manager.allowsBackgroundLocationUpdates = true // 백그라운드 위치 업데이트 허용
        manager.pausesLocationUpdatesAutomatically = false // 위치 업데이트 자동 일시 중지 비활성화
        return manager
    }()
    var previousCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pauseBtn.layer.cornerRadius = 10
        startCountDown()
        mkMapViewDelegate = self
        mapView.delegate = self
        

      
    }
    
    func startCountDown() {
        countDownLabel.isHidden = false
        countDownValue = 3
        DispatchQueue.main.async { [weak self] in
            self?.countDownLabel.text = "\(self?.countDownValue ?? 3)"
        }
        
        countDownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountDown), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountDown() {
        if countDownValue > 1 {
            countDownValue -= 1
            DispatchQueue.main.async { [weak self] in
                self?.countDownLabel.text = "\(self?.countDownValue ?? 0)"
            }
        } else {
            countDownTimer?.invalidate()
            countDownTimer = nil
            countDownLabel.isHidden = true
            DispatchQueue.main.async { [weak self] in
                self?.mapView.isHidden = false
                self?.mapView.showsUserLocation = true
                self?.mapView.setUserTrackingMode(.follow, animated: true)
                self?.distanceLabel.isHidden = false
                self?.timerLabel.isHidden = false
                self?.pauseBtn.isHidden = false
            }
            startRunningTimer()
            locationManager.startUpdatingLocation()
        }
    }
    
    func startRunningTimer() {
        runningTime = 0
     timerLabel.text = formatTime(runningTime)
        
        runningTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateRunningTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateRunningTime() {
        runningTime += 1
        DispatchQueue.main.async { [weak self] in
            self?.timerLabel.text = self?.formatTime(self!.runningTime)
        }
    }
    
    func formatTime(_ totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d시간 %02d분 %02d초", hours, minutes, seconds)
    }
    
    func updateDistanceLabel() {
            let distanceInKm = totalDistance / 1000
            distanceLabel.text = String(format: "%.2f KM", distanceInKm)
        }
    
    
}

extension RunningVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last
        else {return}
        let latitude = location.coordinate.latitude
        let longtitude = location.coordinate.longitude
        
        // 지도 줌 레벨을 설정
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        
        if let previousCoordinate = self.previousCoordinate {
            
            let currentLocation = CLLocation(latitude: latitude, longitude: longtitude)
            let previousLocation = CLLocation(latitude: previousCoordinate.latitude, longitude: previousCoordinate.longitude)
            
            // 거리 계산
            let distance = currentLocation.distance(from: previousLocation) // meters
            totalDistance += distance
            
            // 거리 업데이트
            DispatchQueue.main.async { [weak self] in
                self?.updateDistanceLabel()
            }
            
            
            var points: [CLLocationCoordinate2D] = []
            let point1 = CLLocationCoordinate2DMake(previousCoordinate.latitude, previousCoordinate.longitude)
            let point2: CLLocationCoordinate2D
            = CLLocationCoordinate2DMake(latitude, longtitude)
            points.append(point1)
            points.append(point2)
            let lineDraw = MKPolyline(coordinates: points, count:points.count)
            self.mapView.addOverlay(lineDraw)
        }
        
        self.previousCoordinate = location.coordinate
    }
}

extension RunningVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard let polyLine = overlay as? MKPolyline
            else {
                print("can't draw polyline")
                return MKOverlayRenderer()
            }
            let renderer = MKPolylineRenderer(polyline: polyLine)
                renderer.strokeColor = .orange
                renderer.lineWidth = 5.0
                renderer.alpha = 1.0

            return renderer
        }
}
