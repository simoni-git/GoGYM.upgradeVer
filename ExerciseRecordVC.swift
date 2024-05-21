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
        let indexPath = IndexPath(row: exerciseArray.count, section: 0)//🧪
        let exercise = ExerciseData(exerciseName: exerciseName, category: category, unit: unit)
        
        exerciseArray.append(exercise)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
    }
    
    @IBOutlet weak var addExerciseBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var startAndFinishBtn: UIButton!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var restTimeBtn: UIButton!
    
    var timer: Timer?
    var seconds: Int = 0
    var totalVolume: Int = 0
    
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
    
    @IBAction func tapStartFinishBtn(_ sender: UIButton) {
        
        if startAndFinishBtn.titleLabel?.text == "운동종료" {
            print(" 라벨이 운동종료 일 떄 눌렸다")
            timer?.invalidate()
            timer = nil
           
            let alert = UIAlertController(title: "운동을 종료하시겠습니까?", message: nil, preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "예", style: .default) { [weak self] _ in
                // 다른 VC 가 나오며 운동총볼륨 + 운동시간이 나오도록 구현할것
                if let timeLabelText = self?.totalTimeLabel.text {
                       print("멈춰진 시간은? \(timeLabelText)")
                    guard let finishVC = self?.storyboard?.instantiateViewController(identifier: "FinishVC") as? FinishVC else {
                        return
                    }
                    
                 /*
                  셀에 총볼륨값에 접근해야함..
                  */
                    
                    
                    finishVC.totalTime = timeLabelText
                    finishVC.modalPresentationStyle = .fullScreen
                    finishVC.modalTransitionStyle = .partialCurl
                    self?.present(finishVC, animated: true)
                   } else {
                       print("멈춰진 시간을 가져올 수 없습니다.")
                   }
                self?.seconds = 0 // 0으로 만들기 전에 해당 시간정보를 다음뷰에 넘긴 후 0으로 만들어야함.
               
            }
            let cancelBtn = UIAlertAction(title: "아니오", style: .cancel) { [weak self] _ in
                if let self = self {
                    self.startAndFinishBtn.setTitle("운동종료", for: .normal)
                    self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
                }
            }
            alert.addAction(okBtn)
            alert.addAction(cancelBtn)
            present(alert, animated: true)
            
        } else {
            print(" 라벨이 운동시작 일 떄 눌렸다")
            self.addExerciseBtn.isHidden = false
            self.startAndFinishBtn.setTitle("운동종료", for: .normal)
            timer?.invalidate() // 진행되는 타이머가 있다면 초기화
            seconds = 0
            updateLabel()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            
        }
        
    }
    
    @objc func updateTimer() {
           seconds += 1
           updateLabel()
       }
       
       func updateLabel() {
           let hours = seconds / 3600
           let minutes = (seconds % 3600) / 60
           let secs = seconds % 60
           DispatchQueue.main.async {
               self.totalTimeLabel.text = "\(hours)시간\(minutes)분\(secs)초"
           }
          
       }
    
    struct ExerciseData {
        var exerciseName: String
        var category: String
        var unit: String
    }
    
}

//MARK: - 테이블뷰관련
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
        cell.volumeLabel.text = "총 볼륨: 0\(data.unit)"
        cell.layer.cornerRadius = 10
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

//MARK: - Cell 클래스
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
  
    override func prepareForReuse() {
        
        // horizontalStackViews 배열을 초기화하여 스택뷰들을 제거합니다.
        horizontalStackViews.removeAll()
        
        // verticalStackView에 있는 모든 서브뷰를 제거합니다.
        for subview in verticalStackView.arrangedSubviews {
            verticalStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        // 스택뷰의 높이 제약을 초기화합니다.
        verticalStackViewHeightConst.constant = 0
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        // 텍스트 필드의 값이 변경되었으므로, 각 텍스트 필드의 값을 사용하여 총 볼륨을 계산하고 업데이트합니다.
        // 여기에 무게단위만 적용하면 될듯? 일단 KG 로 라벨에 써놓자
        let totalVolume = calculateTotal()
        DispatchQueue.main.async {
            self.volumeLabel.text = "총 볼륨: \(totalVolume) KG"
        }
        print("총 볼륨: \(totalVolume)")
    }
    
    func calculateTotal() -> Int {
        var total = 0
        for horizontalStackView in horizontalStackViews {
            guard let weightTextField = horizontalStackView.subviews.first(where: { $0 is UITextField && $0.tag % 2 == 0 }) as? UITextField,
                  let weightText = weightTextField.text,
                  let weight = Int(weightText),
                  let countTextField = horizontalStackView.subviews.first(where: { $0 is UITextField && $0.tag % 2 == 1 }) as? UITextField,
                  let countText = countTextField.text,
                  let count = Int(countText) else {
                continue
            }
            // 각 텍스트 필드의 값과 인덱스를 곱하여 총합을 계산합니다.
            total += weight * count
        }
        
        return total
    }
    
    private func updateTotalVolume() {
        let totalVolume = calculateTotal()
        DispatchQueue.main.async {
            self.volumeLabel.text = "총 볼륨: \(totalVolume) "
            //하나만 더 추가하고 싶은 기능은 해당 셀이 만들어 질 때 KG, lbs 둘중 하나를 택했을텐데
            //택했던 단위로 총볼륨뒤에 붙일것
        }
    }
    
    @IBAction func tapCheckBtn(_ sender: UIButton) {
        // 체크가 되면 휴식타이머가 돌아감
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
        updateTotalVolume()
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
        weightTextField.tag = horizontalStackViews.endIndex * 2
        
        let weightLabel = UILabel()
        weightLabel.text = "KG"
        
        let countTextField = UITextField()
        countTextField.placeholder = "0"
        countTextField.backgroundColor = .white
        countTextField.layer.cornerRadius = 5
        countTextField.tag = (horizontalStackViews.endIndex * 2) + 1
        
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
        
        weightTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        countTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
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
        exerciseArray.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)//🧪
        
        // 셀 삭제 후 남은 셀들의 라벨을 정리합니다.
        for i in index..<exerciseArray.count {
            // indexPath를 생성합니다.
            let indexPath = IndexPath(row: i, section: 0)
            
            // 해당 indexPath에 대한 셀을 가져옵니다.
            if let cell = tableView.cellForRow(at: indexPath) as? Cell {
                let data = exerciseArray[i]
                cell.nameLabel.text = "\(i + 1). \(data.category) -- \(data.exerciseName)"
                
            }
        }
    }
    
}


/*
 현재 상황  5월21일
 해야할일:
 1. 운동시간을 finishVC 에 넘기기 [v]
 2. 총볼륨값을 구해서 finishVC 에 넘기기 (알럿나오는 부분 가서 마저 구현할것)
 
 */
