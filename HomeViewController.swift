//
//  ViewController.swift
//  GoGYM.upGrade
//
//  Created by 시모니 on 5/6/24.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    var context: NSManagedObjectContext {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        return app.persistentContainer.viewContext
    }
    
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       configure()
        checkTodayData()
        NotificationCenter.default.addObserver(self, selector: #selector(dismissAndGoToHome), name: NSNotification.Name("DismissAndGoToHome"), object: nil)
        
    }
    
    private func configure() {
        subView.layer.cornerRadius = 10
        startBtn.layer.cornerRadius = 10
        
        let currentDate = Date()
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ko_KR")
        dateFormater.dateFormat = "MM월dd일 EEEE"
        let dateString = dateFormater.string(from: currentDate)
        dateLabel.text = dateString
    }
    
    
    
    @objc func dismissAndGoToHome() {
           // 네비게이션 스택 초기화 후 첫 화면으로 이동
           if let navigationController = self.navigationController {
               checkTodayData()
               navigationController.popToRootViewController(animated: true)
           }
       }

       deinit {
           // 노티피케이션 해제
           NotificationCenter.default.removeObserver(self, name: NSNotification.Name("DismissAndGoToHome"), object: nil)
       }
    
    //MARK: - 코어데이터부분
    // 오늘 날짜의 데이터 확인 메서드
       private func checkTodayData() {
           let fetchRequest: NSFetchRequest<ExerciseModel> = ExerciseModel.fetchRequest()
           
           // 오늘 날짜 문자열 생성
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy년MM월dd일"
           let todayString = dateFormatter.string(from: Date())
           
           // 조건 추가: date 속성이 오늘 날짜와 일치하는 항목 검색
           fetchRequest.predicate = NSPredicate(format: "date == %@", todayString)
           
           do {
               let results = try context.fetch(fetchRequest)
               if results.count > 0 {
                   print("오늘날짜데이터가 있습니다")
                   startBtn.isEnabled = false // 버튼 비활성화
                   startBtn.setTitle("오늘운동 완료!", for: .normal)
               } else {
                   print("오늘날짜데이터가 없습니다")
                   startBtn.isEnabled = true // 버튼 활성화
               }
           } catch let error as NSError {
               print("데이터를 가져오는 데 실패했습니다. \(error), \(error.userInfo)")
           }
       }
    
    
}
    
    

    


