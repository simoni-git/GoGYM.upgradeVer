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
    
    var kalmanFilter = KalmanFilter() // 칼만 필터 인스턴스 추가
    
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
    var polylineOverlays: [MKPolyline] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        pauseBtn.layer.cornerRadius = 10
        startCountDown()
        mkMapViewDelegate = self
        mapView.delegate = self
        // NotificationCenter를 통해 모달이 닫힐 때 동작할 메서드를 등록
            NotificationCenter.default.addObserver(self, selector: #selector(resumeRunning), name: NSNotification.Name("ResumeRunning"), object: nil)
        
    }
    
    @objc func resumeRunning() {
        // 타이머와 위치 업데이트 재개
        startRunningTimer()
        locationManager.startUpdatingLocation()
    }

    deinit {
        // 뷰 컨트롤러가 해제될 때 옵저버 제거
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ResumeRunning"), object: nil)
    }
    
    @IBAction func tapPauseBtn(_ sender: UIButton) {
        guard let runningPauseVC = self.storyboard?.instantiateViewController(identifier: "RunningPauseVC") as? RunningPauseVC else { return }
      
    /*
     중지버튼 클릭시 모달형식으로 다음뷰로 이동,
     다음뷰로 가야할것: 지도상런닝경로(v) , 거리라벨() , 시간라벨() , 저장버튼() , 계속하기버튼()[계속하기버튼 클릭시 이전정보들 계속 가지고있어야겠지? 근데 모달형식이라 이전정보들이 없어지진 않을테니 ㄱㅊ을듯]
     
    버튼클릭시 구현되어야할것
     1. 타이머와 지도 잠시 멈춤
     2. 현재 시간과 거리정보 다음뷰로 넘기기
     
     */
        
        runningTimer?.invalidate()
        runningTimer = nil
        locationManager.stopUpdatingLocation()
        //⬆️ 1번 구현한것.
        
        runningPauseVC.runningTime = self.runningTime
        runningPauseVC.totalDistance = self.totalDistance
        
        
        
        runningPauseVC.polylineOverlays = self.polylineOverlays
        runningPauseVC.region = mapView.region
        runningPauseVC.modalPresentationStyle = .fullScreen
        present(runningPauseVC, animated: true)
        
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
        if runningTime == nil {
            print("타이머가 현재 nil 입니다")
            runningTime = 0
            timerLabel.text = formatTime(runningTime)
            runningTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateRunningTime), userInfo: nil, repeats: true)
        } else {
            print("타이머가 현재 nil 이 아닙니다")
            timerLabel.text = formatTime(runningTime)
            runningTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateRunningTime), userInfo: nil, repeats: true)
        }
//        runningTime = 0
//     timerLabel.text = formatTime(runningTime)
//        
//        runningTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateRunningTime), userInfo: nil, repeats: true)
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
        guard let location = locations.last else { return }
               
               // 필터 적용
               let filteredCoordinate = kalmanFilter.filter(coordinate: location.coordinate)
               let filteredLocation = CLLocation(latitude: filteredCoordinate.latitude, longitude: filteredCoordinate.longitude)

               // 지도 줌 레벨을 설정
               let center = filteredCoordinate
               let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
               mapView.setRegion(region, animated: true)
               
               if let previousCoordinate = self.previousCoordinate {
                   let currentLocation = filteredLocation
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
                   let point2 = filteredCoordinate
                   points.append(point1)
                   points.append(point2)
                   let lineDraw = MKPolyline(coordinates: points, count: points.count)
                   self.mapView.addOverlay(lineDraw)
                   
                   polylineOverlays.append(lineDraw) // 배열에 경로 추가
               }

               self.previousCoordinate = filteredCoordinate
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
