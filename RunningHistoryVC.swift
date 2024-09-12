//
//  RunningHistoryVC.swift
//  GoGYM.upGrade
//
//  Created by 시모니 on 9/12/24.
//

import UIKit
import CoreData

class RunningHistoryVC: UIViewController {
    
    var context: NSManagedObjectContext {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        return app.persistentContainer.viewContext
    }
    
    @IBOutlet weak var tableView: UITableView!
    // 코어데이터에서 가져온 런닝 기록을 저장할 배열
        var runningRecords: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchRunningData()
        
    }
    
    
    private func fetchRunningData() {
        // NSFetchRequest를 통해 코어데이터에서 `RunningModel` 엔티티의 데이터를 가져옴
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RunningModel")
        
        do {
            runningRecords = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print("데이터를 가져오는데 실패했습니다. 이유: \(error), \(error.userInfo)")
        }
    }
    
    
    
}

extension RunningHistoryVC: UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runningRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RunningHistoryCell", for: indexPath) as? RunningHistoryCell else {
                   return UITableViewCell()
               }
               
               let runningRecord = runningRecords[indexPath.row]
               
        if let date = runningRecord.value(forKey: "date") as? Date {
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "ko_KR")
                dateFormatter.dateFormat = "yyyy년 M월 d일 a h시 mm분"
                cell.dateLabel.text = dateFormatter.string(from: date)
            }
               
               return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //셀 클릭시 디테일뷰컨으로 이동 + 정보 나타내기
    }
    
    //셀 삭제기능도 구현한ㄹ것(코어데이터에서도 지워야함.)
    
    
}

class RunningHistoryCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
}
