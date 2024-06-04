//
//  SomedayRecordVC.swift
//  GoGYM.upGrade
//
//  Created by 시모니 on 6/4/24.
//

import UIKit

class SomedayRecordVC: UIViewController {
    
    @IBOutlet weak var somedayDateLabel: UILabel!
    @IBOutlet weak var somedayVolumeLabel: UILabel!
    @IBOutlet weak var somedayMemoLabel: UILabel!
    @IBOutlet weak var somedayTimeLabel: UILabel!
    
    var date: String = ""
    var volume: Double = 0
    var time: String = ""
    var memo: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
    
    private func configure() {
        somedayDateLabel.text = date
        somedayVolumeLabel.text = "\(volume)"
        somedayTimeLabel.text = time
        somedayMemoLabel.text = memo
    }
    
}
