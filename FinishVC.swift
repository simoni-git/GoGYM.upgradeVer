//
//  FinishVC.swift
//  GoGYM.upGrade
//
//  Created by 시모니 on 5/21/24.
//

import UIKit
import CoreData

class FinishVC: UIViewController {
    
    var context: NSManagedObjectContext {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        return app.persistentContainer.viewContext
    }
    
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var totalVolumeLabel: UILabel!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var saveBtn: UIButton!
    
    var totalTime: String = ""
    var totalVolume: Double = 0
    var today: String = ""
    var memo: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupTapGestureToDismissKeyboard()
        
    }
    
    private func configure() {
        saveBtn.layer.cornerRadius = 10
        totalTimeLabel.text = "총 운동시간: \(totalTime)"
        totalVolumeLabel.text = "총 볼륨: \(totalVolume)"
        todayDate()
        memoTextView.delegate = self
        memoTextView.text = "오늘 운동에 대해 메모할 수 있어요!"
        memoTextView.textColor = UIColor.lightGray
        memoTextView.layer.borderWidth = 1.0
        memoTextView.layer.borderColor = UIColor.black.cgColor
        memoTextView.layer.cornerRadius = 10
    }
    
    private func todayDate() {
        let currentDate = Date()
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ko_KR")
        dateFormater.dateFormat = "YYYY년MM월dd일"
        let dateString = dateFormater.string(from: currentDate)
        self.today = dateString
    }
    
    @IBAction func tapSaveBtn(_ sender: UIButton) {
        print("일단 저장버튼 눌리긴 했다")
        
        let time = self.totalTime
        let volume = self.totalVolume
        let date = today
        if memoTextView.text == "오늘 운동에 대해 메모할 수 있어요!" || memoTextView.text == nil {
            self.memo = "입력한 메모가 없습니다."
        } else {
            self.memo = memoTextView.text
        }
        let memo = self.memo
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: "ExerciseModel", into: context)
        newEntity.setValue(time, forKey: "time")
        newEntity.setValue(volume, forKey: "volume")
        newEntity.setValue(date, forKey: "date")
        newEntity.setValue(memo, forKey: "memo")
        
        if context.hasChanges {
            do {
                try context.save()
                print("데이터가 성공적으로 저장되었습니다.")
                
                // 저장 후 데이터 확인
                let fetchRequest: NSFetchRequest<ExerciseModel> = ExerciseModel.fetchRequest()
                do {
                    let results = try context.fetch(fetchRequest)
                    for exercise in results {
                        print("날짜: \(exercise.date ?? "nil"), 시간: \(exercise.time ?? "nil"), 볼륨: \(exercise.volume)")
                    }
                } catch let error as NSError {
                    print("저장 후 데이터를 가져올 수 없습니다. \(error), \(error.userInfo)")
                }
            } catch let error as NSError {
                print("데이터를 저장하는 데 실패했습니다. \(error), \(error.userInfo)")
            }
            
            NotificationCenter.default.post(name: NSNotification.Name("DismissAndGoToHome"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("updateRecord"), object: nil)
            self.dismiss(animated: true)
        }
    }
    
    //MARK: - 키보드관련
    private func setupTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension FinishVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if memoTextView.text.isEmpty {
            memoTextView.text = "오늘 운동에 대해 메모할 수 있어요!"
            memoTextView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if memoTextView.textColor == UIColor.lightGray {
            memoTextView.text = nil
            memoTextView.textColor = UIColor.black
        }
    }
    
}
