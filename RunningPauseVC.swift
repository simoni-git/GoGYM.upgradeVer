//
//  RunningPauseVC.swift
//  GoGYM.upGrade
//
//  Created by 시모니 on 8/1/24.
//

import UIKit
import MapKit
import CoreData


class RunningPauseVC: UIViewController {
    
    var context: NSManagedObjectContext {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        return app.persistentContainer.viewContext
    }
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    
    
    // 전달받을 경로 데이터
    var polylineOverlays: [MKPolyline] = []
    var region: MKCoordinateRegion?
    var runningTime: Int = 0      // 시간을 초 단위로 저장
    var totalDistance: Double = 0 // 거리를 미터 단위로 저장
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()

        
    }
    
    private func configure() {
        self.saveBtn.layer.cornerRadius = 10
        self.backBtn.layer.cornerRadius = 10
        mapView.delegate = self
        if let region = region {
            mapView.setRegion(region, animated: false) // 지도 영역 설정
        }
        mapView.addOverlays(polylineOverlays) // 전달받은 경로 추가
        timeLabel.text = "시간: \(formatTime(runningTime))"
        distanceLabel.text = "거리: \(formatDistance(totalDistance))"
    }
    
    private func formatTime(_ totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d시간 %02d분 %02d초", hours, minutes, seconds)
        
    }
    
    private func formatDistance(_ distance: Double) -> String {
        let distanceInKm = distance / 1000
        return String(format: "%.2f KM", distanceInKm)
    }
    
    
    @IBAction func tapSaveBtn(_ sender: UIButton) {
        /*
         1. 코어데이터에 저장하기[v]
         2. 홈뷰컨으로 이동하기 [ ]
         */
        
        // `RunningRecord` 엔티티에 새로운 객체 생성
            let newRecord = NSEntityDescription.insertNewObject(forEntityName: "RunningModel", into: context)
        // 시간, 거리, 날짜 저장
           newRecord.setValue(Int64(runningTime), forKey: "time")
           newRecord.setValue(totalDistance, forKey: "distance")
           newRecord.setValue(Date(), forKey: "date")
           
        // 경로(폴리라인)를 바이너리 데이터로 변환하여 저장
           let polylineData = try? NSKeyedArchiver.archivedData(withRootObject: polylineOverlays, requiringSecureCoding: false)
           newRecord.setValue(polylineData, forKey: "route")
        
        do {
               try context.save()
               print("코어데이터에 런닝데이터 저장 성공")
           } catch {
               print("런닝데이터 저장실패.. 이유는 >> : \(error)")
           }

        // 모달 2개 한번에 지우기
        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
        
    }
    
    
    @IBAction func tapBackBtn(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("ResumeRunning"), object: nil)
        dismiss(animated: true)
        
    }
    
    

}

extension RunningPauseVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard let polyline = overlay as? MKPolyline else {
                return MKOverlayRenderer()
            }
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .orange
            renderer.lineWidth = 5.0
            return renderer
        }
}
