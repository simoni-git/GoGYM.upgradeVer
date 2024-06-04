//
//  RestTimerEditVC.swift
//  GoGYM.upGrade
//
//  Created by 시모니 on 6/3/24.
//

import UIKit

protocol RestTimeProtocol {
    func sendRestTime(restTime: Int)
}

class RestTimerEditVC: UIViewController {
    
    @IBOutlet weak var mentLabel: UILabel!
    @IBOutlet weak var restTimeLabel: UILabel!
    @IBOutlet weak var minusTimeBtn: UIButton!
    @IBOutlet weak var plusTimeBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    
    var remainingTime: Int = 0
    var delegate: RestTimeProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
    
    private func configure() {
        mentLabel.text = "현재 휴식시간은 \(remainingTime)초 입니다. 원하시는 휴식시간이 있나요?"
        restTimeLabel.text = "\(remainingTime)"
        minusTimeBtn.layer.cornerRadius = 10
        plusTimeBtn.layer.cornerRadius = 10
        okBtn.layer.cornerRadius = 10
    }
    
    @IBAction func tapMinusTimeBtn(_ sender: UIButton) {
        print("RestTimeEditVC - tapMinusTimeBtn called")
        var editTime = (self.remainingTime) - 10
        editTime = max(editTime, 0)
        self.remainingTime = editTime
        DispatchQueue.main.async {
            self.restTimeLabel.text = "\(self.remainingTime)"
        }
    }
    
    @IBAction func tapPlusTimeBtn(_ sender: UIButton) {
        print("RestTimeEditVC - tapPlusTimeBtn called")
        var editTime = (self.remainingTime) + 10
        editTime = min(editTime, 300)
        self.remainingTime = editTime
        DispatchQueue.main.async {
            self.restTimeLabel.text = "\(self.remainingTime)"
        }
    }
    
    @IBAction func tapOkBtn(_ sender: UIButton) {
        print("RestTimeEditVC - tapOkBtn called")
        delegate?.sendRestTime(restTime: self.remainingTime)
        dismiss(animated: true)
    }
    
}
