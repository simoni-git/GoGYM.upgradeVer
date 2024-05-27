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
    @IBOutlet weak var saveBtn: UIButton!
    var totalTime: String = ""
    var totalVolume: Double = 0
    var today: String = "" {
        didSet {
            print("오늘 날짜가 뭐임?? \(today)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        
    }
    
    private func configure() {
        saveBtn.layer.cornerRadius = 10
        totalTimeLabel.text = "총 운동시간: \(totalTime)"
        totalVolumeLabel.text = "총 볼륨: \(totalVolume)"
        todayDate()
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
        
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: "ExerciseModel", into: context)
        newEntity.setValue(time, forKey: "time")
        newEntity.setValue(volume, forKey: "volume")
        newEntity.setValue(date, forKey: "date")
        
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
            self.dismiss(animated: true)
            
            //코어데이터에 저장하고 모든 네비게이션스택 초기화후 첫화면으로 이동하기,
            // 저장할 내용들>> 운동시간String , 토탈볼륨Int , 날짜 String
            
            
            
            //여기까지가 시간,볼륨,날짜 를 저장한거임
            // 그다음엔..
            
            
        }
        
        
    }
}
