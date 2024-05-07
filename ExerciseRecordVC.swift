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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? Cell else {
            return UITableViewCell()
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension // 셀높이는 오토로 유동적으로!
    }
    
}

class Cell: UITableViewCell {
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    
    @IBOutlet weak var verticalStackView: UIStackView!
    @IBOutlet weak var horizontalStackView: UIStackView!
    var horizontalStackViews: [UIStackView] = [] // 수평 스택 뷰를 저장할 배열
    
    
    @IBOutlet weak var verticalStackViewHeightConst: NSLayoutConstraint!
    
    
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var kgLabel: UILabel!
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    
    @IBAction func tapCheckBtn(_ sender: UIButton) {
        
    }
    
    
    @IBAction func tapCellOptionBtn(_ sender: UIButton) {
    }
    
    
    @IBAction func tapDeleteSetBtn(_ sender: UIButton) {
        deleteLatestHorizontalStackView()
        reloadCell()
    }
    
    
    @IBAction func tapAddSetBtn(_ sender: UIButton) {
        addNewHorizentalStackView()
        reloadCell()
    }
    
    
    private func addNewHorizentalStackView() {
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .fill
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.spacing = 0
        horizontalStackView.backgroundColor = .systemPink
        
        let setLabel = UILabel()
        setLabel.text = "\(horizontalStackViews.endIndex + 1) 세트"
        
        let weightTextField = UITextField()
        weightTextField.placeholder = "0"
        weightTextField.backgroundColor = .white
        weightTextField.layer.cornerRadius = 5
        
        let weightLabel = UILabel()
        weightLabel.text = "KG"
        
        let countTextField = UITextField()
        countTextField.placeholder = "0"
        countTextField.backgroundColor = .white
        countTextField.layer.cornerRadius = 5
        
        let countLabel = UILabel()
        countLabel.text = "회"
        
        let checkBtn = UIButton(type: .custom)
        checkBtn.setImage( .checkmark , for: .normal)
        checkBtn.backgroundColor = .systemGray
        
        horizontalStackView.addArrangedSubview(setLabel)
        horizontalStackView.addArrangedSubview(weightTextField)
        horizontalStackView.addArrangedSubview(weightLabel)
        horizontalStackView.addArrangedSubview(countTextField)
        horizontalStackView.addArrangedSubview(countLabel)
        horizontalStackView.addArrangedSubview(checkBtn)
        
       
        verticalStackViewHeightConst.constant += 20
        verticalStackView.addArrangedSubview(horizontalStackView)
        horizontalStackViews.append(horizontalStackView) // 배열에 추가
        
    }
    
    private func deleteLatestHorizontalStackView() {
           guard let lastView = horizontalStackViews.popLast() else { return }
           
        verticalStackViewHeightConst.constant -= 20
           verticalStackView.removeArrangedSubview(lastView)
           lastView.removeFromSuperview()
     
       }
    
    private func reloadCell() {
           guard let tableView = superview as? UITableView else { return }
           tableView.beginUpdates()
           tableView.endUpdates()
       }
    
   
    
}

