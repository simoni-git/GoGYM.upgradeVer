//
//  ExerciseRecordVC.swift
//  GoGYM.upGrade
//
//  Created by 시모니 on 5/6/24.
//

import UIKit

class ExerciseRecordVC: UIViewController {
   
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var startAndFinishBtn: UIButton!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var restTimeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        configure()
      
    }
    
    func configure() {
        subView.layer.cornerRadius = 10
        startAndFinishBtn.layer.cornerRadius = 10
    }
    
}

extension ExerciseRecordVC: UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? Cell else {
            return UITableViewCell()
        }
        return cell
    }
    
}

class Cell: UITableViewCell {
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    
    @IBOutlet weak var verticalStackView: UIStackView!
    
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var checkBtn: UIButton!
    
    
    @IBAction func tapCheckBtn(_ sender: UIButton) {
    }
    
    
    @IBAction func tapCellOptionBtn(_ sender: UIButton) {
    }
    
    
    @IBAction func tapDeleteSetBtn(_ sender: UIButton) {
    }
    
    
    @IBAction func tapAddSetBtn(_ sender: UIButton) {
    }
    
    
}

