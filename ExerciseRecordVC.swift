//
//  ExerciseRecordVC.swift
//  GoGYM.upGrade
//
//  Created by 시모니 on 5/6/24.
//

import UIKit

class ExerciseRecordVC: UIViewController, ExerciseDataProtocol {
    func sendData(exerciseName: String, category: String, unit: String) {
        print("넘어온 값들은 \(exerciseName) , \(category) , \(unit) 입니다.")
        let exercise = ExerciseData(exerciseName: exerciseName, category: category, unit: unit)
        exerciseArray.append(exercise)
        tableView.reloadData()
        /*
         1. 넘어온 데이터를 토대로 셀에 적용하여 테이블뷰 리로드를 한다. [V]
         추가적으로 해야할일:
         1. 옵션버튼 눌렀을 때 해당 데이터를 삭제하고,테이블뷰를 리로드시킨다. [V]
         2. 세트추가가 되었을 때 고유ID 를 만들어서 해당 텍스트필드가 어떤 텍스트필드인지 인식한 후 총볼륨에 나타낸다(텍스트필드의 값이 수정될 때 마다 해당되겠지.)
         3. 2번이 충족되어 총볼륨이 전부 나타낼 수 있다면 나중에 운동종료버튼을 눌렀을 때 총볼륨을 더한 값을 다음 뷰에 띄워주고 마무리.
         */
    }
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var startAndFinishBtn: UIButton!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var restTimeBtn: UIButton!
    
    var exerciseArray = [ExerciseData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        configure()
      print("ExerciseRecordVC ViewDidLoad")
      
    }
    
    func configure() {
        subView.layer.cornerRadius = 10
        startAndFinishBtn.layer.cornerRadius = 10
    }
    
    @IBAction func tapAddExerciseBtn(_ sender: UIBarButtonItem) {
        print("ExerciseRecordVC - tapAddExerciseBtn()")
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "AddExerciseVC") as? AddExerciseVC else { return }
        vc.delegate = self
        present(vc, animated: true)
        
       
    }
    
    struct ExerciseData {
        var exerciseName: String
        var category: String
        var unit: String
    }
    
}

extension ExerciseRecordVC: UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? Cell else {
            return UITableViewCell()
        }
         let data = exerciseArray[indexPath.row]
        cell.nameLabel.text = "\(indexPath.row + 1). \(data.category) -- \(data.exerciseName)"
        cell.volumeLabel.text = "총볼륨 ?\(data.unit)"
        cell.layer.cornerRadius = 10
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

protocol CellDelegate {
    func removeCell(at index: Int)
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
    
    var delegate: CellDelegate?
    
    @IBAction func tapCheckBtn(_ sender: UIButton) {
        
    }
    
    
    @IBAction func tapCellRemoveBtn(_ sender: UIButton) {
        print("ExerciseRecordVC - tapCellRemoveBtn()")
        guard let tableView = superview as? UITableView,
                  let indexPath = tableView.indexPath(for: self) else {
                return
            }
        delegate?.removeCell(at: indexPath.row)
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

extension ExerciseRecordVC: CellDelegate {
    func removeCell(at index: Int) {
        // 해당 인덱스에 해당하는 데이터를 exerciseArray에서 삭제합니다.
        exerciseArray.remove(at: index)
        // 테이블 뷰를 리로드합니다.
        tableView.reloadData()
    }
    
}


