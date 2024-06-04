//
//  CalendarVC.swift
//  GoGYM.upGrade
//
//  Created by 시모니 on 5/6/24.
//

import UIKit
import CoreData

class CalendarVC: UIViewController {
    
    @IBOutlet weak var titleView: UIView!
    var calendarView: UICalendarView!
    var highlightedDates = [Date]()
    var today: String = ""
    var volume: Double = 0
    var time: String = ""
    var memo: String = ""
    var context: NSManagedObjectContext {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        return app.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CalendarVC - ViewDidLoad~~")
        creatCalendar()
        fetchDataAndHighlightDates()
        calendarView.delegate = self
        let selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selectionBehavior
        NotificationCenter.default.addObserver(self, selector: #selector(updateRecord), name: NSNotification.Name("updateRecord"), object: nil)
    }
    
    @objc func updateRecord() {
        fetchDataAndHighlightDates()
    }
    
    deinit {
        // 노티피케이션 해제
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("updateRecord"), object: nil)
    }
    
    private func creatCalendar() {
        calendarView = UICalendarView()
        // 캘린더 뷰의 프레임을 설정 (자동 레이아웃을 사용하거나 원하는 프레임으로 설정할 수 있음)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarView)
        // 자동 레이아웃 제약 조건 설정
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 90),
            calendarView.heightAnchor.constraint(equalToConstant: 450) // 원하는 높이로 설정
        ])
        // 필요에 따라 캘린더의 스타일, 데이터 소스 및 델리게이트 설정
        calendarView.calendar = Calendar.current
        calendarView.locale = Locale(identifier: "ko_KR")
    }
    
    private func fetchDataAndHighlightDates() {
        let fetchRequest: NSFetchRequest<ExerciseModel> = ExerciseModel.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            for exercise in results {
                if let dateString = exercise.date {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YYYY년MM월dd일"
                    if let date = dateFormatter.date(from: dateString) {
                        highlightedDates.append(date)
                    }
                }
            }
            // 캘린더에 데이터 표시
            calendarView.reloadDecorations(forDateComponents: highlightedDates.map {
                Calendar.current.dateComponents([.year, .month, .day], from: $0)
            }, animated: true)
        } catch let error as NSError {
            print("데이터를 가져오는 데 실패했습니다. \(error), \(error.userInfo)")
        }
    }
    
}

extension CalendarVC: UICalendarViewDelegate , UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        // 선택된 날짜 처리
        if let dateComponents = dateComponents {
            let calendar = Calendar.current
            if let date = calendar.date(from: dateComponents) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY년MM월dd일"
                dateFormatter.timeZone = TimeZone.current // 현재 타임존 설정
                let dateString = dateFormatter.string(from: date)
                print("Selected date: \(dateString)")
                
                fetchSomedayData(date: dateString)
            }
        }
    }
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        // 날짜가 highlightedDates에 포함되어 있으면 이모티콘 추가
        let calendar = Calendar.current
        if let date = calendar.date(from: dateComponents), highlightedDates.contains(date) {
            return .customView {
                let label = UILabel()
                label.text = "🏋️‍♂️" // 원하는 이모티콘
                label.font = .systemFont(ofSize: 12)
                return label
            }
        }
        return nil
    }
    
    func fetchSomedayData(date: String) {
        let fetchRequest: NSFetchRequest<ExerciseModel> = ExerciseModel.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            for data in results {
                if data.date == date {
                    self.today = data.date ?? ""
                    self.volume = data.volume
                    self.time = data.time ?? ""
                    self.memo = data.memo ?? ""
                    print("해당날짜는 \(date) - Volume: \(self.volume), Time: \(self.time), Memo: \(self.memo)")
                    
                    guard let somedayRecordVC = self.storyboard?.instantiateViewController(identifier: "SomedayRecordVC") as? SomedayRecordVC else { return }
                    somedayRecordVC.date = self.today
                    somedayRecordVC.volume = self.volume
                    somedayRecordVC.time = self.time
                    somedayRecordVC.memo = self.memo
                    present(somedayRecordVC, animated: true)
                    
                }
            }
        } catch {
            print("데이터 찾을 수 없음 >> \(error)")
        }
    }
    
}


