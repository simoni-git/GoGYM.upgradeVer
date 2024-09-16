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
        var isEditingMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        navigationItemSetting()
        fetchRunningData()
     
    }
    
    private func navigationItemSetting() {
        let rightBtn = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(tapEditBtn))
        self.navigationItem.rightBarButtonItem = rightBtn
       
    }
    
    @objc func tapEditBtn() {
        if isEditingMode == false {
            print("현재 isEditingMode 가 false 입니다. true 로 전환합니다")
            self.tableView.setEditing(true, animated: true)
            self.navigationItem.rightBarButtonItem?.title = "완료"
            isEditingMode = true
        } else {
            print("현재 isEditingMode 가 true 입니다. false 로 전환합니다")
            self.tableView.setEditing(false, animated: true)
            self.navigationItem.rightBarButtonItem?.title = "편집"
            isEditingMode = false
        }
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
    
    private func deleteRunningData(at indexpath: IndexPath) {
        let runningRecordToDelete = runningRecords[indexpath.row]
        context.delete(runningRecordToDelete)
        do {
            try context.save()
            runningRecords.remove(at: indexpath.row)
            tableView.deleteRows(at: [indexpath], with: .automatic)
        } catch {
            print("오류발생: \(error)")
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
        //셀 클릭시 디테일뷰컨으로 이동 + 정보 나타내기[ ]
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           deleteRunningData(at: indexPath)
        }
    }
    
    
    
}

class RunningHistoryCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
}
