//
//  RestTimeModalVC.swift
//  GoGYM.upGrade
//
//  Created by 시모니 on 6/5/24.
//

import UIKit

protocol RestTimeModalDelegate {
    func updateRestTimeForModal(restTime: Int)
}

class RestTimeModalVC: UIViewController {
    
    
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var currentRestTimeLabel: UILabel!
    @IBOutlet weak var minus10Btn: UIButton!
    @IBOutlet weak var plus10Btn: UIButton!
    @IBOutlet weak var optionBtn: UIButton!
    @IBOutlet weak var clossBtn: UIButton!
    
    var restTime: Int?
    var timer: Timer?
    var delegate: RestTimeModalDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        startTimer()

        
    }
    
    private func configure() {
        modalView.layer.cornerRadius = 10
        minus10Btn.layer.cornerRadius = 10
        plus10Btn.layer.cornerRadius = 10
        optionBtn.layer.cornerRadius = 10
        clossBtn.layer.cornerRadius = 10
    }
    
    @IBAction func tapMinus10Btn(_ sender: UIButton) {
        //현재 쉬는시간에 - 10초를 적용
        if let currentRestTime = restTime {
            restTime = max(currentRestTime - 10, 0)
        }
    }
    
    @IBAction func tapPlus10Btn(_ sender: UIButton) {
        //현재 쉬는시간에 + 10초를 적용
        if let currentRestTime = restTime {
            restTime = min(currentRestTime + 10, 300)
        }
    }
    
    
    @IBAction func tapOptionBtn(_ sender: UIButton) {
        // RestTimerEditVC 로 이동
    }
    
    
    @IBAction func tapClossBtn(_ sender: UIButton) {
       
        guard let exerciseRecordVC = self.storyboard?.instantiateViewController(identifier: "ExerciseRecordVC") as? ExerciseRecordVC else { return }
        delegate?.updateRestTimeForModal(restTime: self.restTime!)
        
        dismiss(animated: true)
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateRestTimer), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateRestTimer() {
        // 남은 시간을 줄임
        restTime! -= 1
        
        DispatchQueue.main.async {
            self.currentRestTimeLabel.text = "\(self.restTime ?? 0)초"
        }
        
        // 남은 시간이 0초 이하이면 타이머를 무효화하고 완료 핸들러 호출
        if restTime! <= 0 {
            timer?.invalidate()
            timerDidFinish()
        }
    }
    
    @objc func timerDidFinish() {
        // 타이머 완료시 수행할 작업
        print("타이머가 완료되었습니다.")
        // 뷰컨트롤러에 있는 restTimeBtn 의
        DispatchQueue.main.async {
            self.currentRestTimeLabel.text = "휴식종료"
        }
    }

}
