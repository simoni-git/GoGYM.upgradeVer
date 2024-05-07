//
//  AddExerciseVC.swift
//  GoGYM.upGrade
//
//  Created by 시모니 on 5/7/24.
//

import UIKit

protocol ExerciseDataProtocol {
    func sendData(exerciseName: String , category: String , unit: String)
}

class AddExerciseVC: UIViewController {
    
    
    @IBOutlet weak var exerciseNameTextField: UITextField!
    
    @IBOutlet weak var chestBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var legBtn: UIButton!
    @IBOutlet weak var shoulderBtn: UIButton!
    @IBOutlet weak var armBtn: UIButton!
    @IBOutlet weak var someBtn: UIButton!
    
    @IBOutlet weak var kgBtn: UIButton!
    @IBOutlet weak var lbsBtn: UIButton!
    
    @IBOutlet weak var addBtn: UIButton!
    
    var delegate: ExerciseDataProtocol?
    var exerciseName: String = ""
    var category: String = ""
    var unit: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseNameTextField.addTarget(self, action: #selector(textfieldDidChange(_ :)), for: .editingChanged)
        configure()
        
    }
    
    @objc func textfieldDidChange(_ sender: Any?) {
        updateAddBtnStates()
        print("난 바뀔때 마다 호출되련다")
    }

  //MARK: - 카테고리버튼들
    
    @IBAction func tapChestBtn(_ sender: UIButton) {
        resetCategoryBtnStates()
        chestBtn.isSelected = true
        chestBtn.backgroundColor = .yellow
        updateAddBtnStates()
        category = "가슴"
    }
    
    @IBAction func tapBackBtn(_ sender: UIButton) {
        resetCategoryBtnStates()
        backBtn.isSelected = true
        backBtn.backgroundColor = .yellow
        updateAddBtnStates()
        category = "등"
    }
    
    @IBAction func tapLegBtn(_ sender: UIButton) {
        resetCategoryBtnStates()
        legBtn.isSelected = true
        legBtn.backgroundColor = .yellow
        updateAddBtnStates()
        category = "하체"
    }
    
    @IBAction func tapShoulderBtn(_ sender: UIButton) {
        resetCategoryBtnStates()
        shoulderBtn.isSelected = true
        shoulderBtn.backgroundColor = .yellow
        updateAddBtnStates()
        category = "어깨"
    }
    
    @IBAction func tapArmBtn(_ sender: UIButton) {
        resetCategoryBtnStates()
        armBtn.isSelected = true
        armBtn.backgroundColor = .yellow
        updateAddBtnStates()
        category = "팔"
    }
    
    @IBAction func tapSomeBtn(_ sender: UIButton) {
        resetCategoryBtnStates()
        someBtn.isSelected = true
        someBtn.backgroundColor = .yellow
        updateAddBtnStates()
        category = "기타"
    }

    //MARK: - 단위버튼들
    
    @IBAction func tapKGBtn(_ sender: UIButton) {
        resetUnitBtnsStates()
        kgBtn.isSelected = true
        kgBtn.backgroundColor = .yellow
        updateAddBtnStates()
        unit = "KG"
    }
    
    @IBAction func tapLbsBtn(_ sender: UIButton) {
        resetUnitBtnsStates()
        lbsBtn.isSelected = true
        lbsBtn.backgroundColor = .yellow
        updateAddBtnStates()
        unit = "lbs"
    }
    
    //MARK: - 운동추가하기버튼
    
    @IBAction func tapAddBtn(_ sender: UIButton) {
        print("AddExerciseVC - tapAddBtn()")
        exerciseName = exerciseNameTextField.text!
        let category = category
        let unit = unit
        
        delegate?.sendData(exerciseName: exerciseName, category: category, unit: unit)

        dismiss(animated: true)
    }
    
    //MARK: - privateFunc()
    
    private func configure() {
        chestBtn.layer.cornerRadius = 10
        backBtn.layer.cornerRadius = 10
        legBtn.layer.cornerRadius = 10
        shoulderBtn.layer.cornerRadius = 10
        armBtn.layer.cornerRadius = 10
        someBtn.layer.cornerRadius = 10
        kgBtn.layer.cornerRadius = 10
        lbsBtn.layer.cornerRadius = 10
        addBtn.layer.cornerRadius = 10
    }
    
    private func resetCategoryBtnStates() {
        let categoryBtns = [chestBtn , backBtn , legBtn , shoulderBtn , armBtn , someBtn]
        
        for button in categoryBtns {
            button?.isSelected = false
            button?.backgroundColor = .white
        }
       
    }
    
    private func resetUnitBtnsStates() {
        let unitBtns = [kgBtn , lbsBtn]
        for button in unitBtns {
            button?.isSelected = false
            button?.backgroundColor = .white
        }
        
    }
    
    private func updateAddBtnStates() {
        print("AddExerciseVC - updateAddBtnStates() ")
        guard let nameTextField = exerciseNameTextField.text, !nameTextField.isEmpty else {
            addBtn.isEnabled = false
            addBtn.tintColor = .darkGray
            addBtn.backgroundColor = .systemGray3
            return
        }
        
        let categoryBtns = [chestBtn , backBtn , legBtn , shoulderBtn , armBtn , someBtn]
        let unitBtns = [kgBtn , lbsBtn]
        
        let text = !nameTextField.isEmpty
        let categoryBtnSelected = categoryBtns.contains { $0?.isSelected == true }
        let unitBtnSelected = unitBtns.contains { $0?.isSelected == true }
        
        addBtn.isEnabled = categoryBtnSelected && unitBtnSelected && text
        addBtn.tintColor = .white
        
        if categoryBtnSelected && unitBtnSelected && text {
            addBtn.tintColor = .white
            addBtn.backgroundColor = .blue
        } else {
            addBtn.tintColor = .darkGray
            addBtn.backgroundColor = .systemGray3
        }
    }
    
}

