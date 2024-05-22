//
//  FinishVC.swift
//  GoGYM.upGrade
//
//  Created by 시모니 on 5/21/24.
//

import UIKit

class FinishVC: UIViewController {
    
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var totalVolumeLabel: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    var totalTime: String = ""
    var totalVolume: Int = 0
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
    
    private func configure() {
        saveBtn.layer.cornerRadius = 10
        totalTimeLabel.text = "총 운동시간: \(totalTime)"
        totalVolumeLabel.text = "총 볼륨: \(totalVolume)"
    }
    
    @IBAction func tapSaveBtn(_ sender: UIButton) {
        //코어데이터에 저장하고 모든 네비게이션스택 초기화후 첫화면으로 이동하기
    }
    
   
}
