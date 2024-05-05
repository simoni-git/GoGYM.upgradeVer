//
//  ViewController.swift
//  GoGYM.upGrade
//
//  Created by 시모니 on 5/6/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       configure()
        
    }

    func configure() {
        subView.layer.cornerRadius = 10
        startBtn.layer.cornerRadius = 10
        
        let currentDate = Date()
        let dateFormter = DateFormatter()
        dateFormter.locale = Locale(identifier: "ko_KR")
        dateFormter.dateFormat = "MM월dd일 EEEE"
        let dateString = dateFormter.string(from: currentDate)
        dateLabel.text = dateString
    }

    
}

