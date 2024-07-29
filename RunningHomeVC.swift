//
//  RunningHomeVC.swift
//  GoGYM.upGrade
//
//  Created by 시모니 on 7/29/24.
//

import UIKit
import CoreLocation
import MapKit

class RunningHomeVC: UIViewController {

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startRunningBtn: UIButton!
    @IBOutlet weak var historyBtn: UIButton!
    
    lazy var locationManager: CLLocationManager = {
           let manager = CLLocationManager()
           manager.desiredAccuracy = kCLLocationAccuracyBest
           manager.startUpdatingLocation()
           manager.delegate = self
           return manager
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)

    
    }
    
    private func configure() {
        startRunningBtn.layer.cornerRadius = 10
        historyBtn.layer.cornerRadius = 10
        getLocationUsagePermission()
    }
    
    func getLocationUsagePermission() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    @IBAction func tapStartBtn(_ sender: UIButton) {
        guard let runningVC = self.storyboard?.instantiateViewController(identifier: "RunningVC") as? RunningVC else { return }
        runningVC.modalPresentationStyle = .fullScreen
        present(runningVC, animated: true)
        
    }
    
    @IBAction func tapHistoryBtn(_ sender: UIButton) {
    }
    
    
    
}

extension RunningHomeVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
                switch status {
                case .authorizedAlways, .authorizedWhenInUse:
                    print("GPS 권한 설정됨")
                case .restricted, .notDetermined:
                    print("GPS 권한 설정되지 않음")
                    DispatchQueue.main.async {
                        self.getLocationUsagePermission()
                    }
                case .denied:
                    print("GPS 권한 요청 거부됨")
                    DispatchQueue.main.async {
                        self.getLocationUsagePermission()
                    }
                default:
                    print("GPS: Default")
                }
            }
    
    
}
