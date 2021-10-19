//
//  InputViewController.swift
//  taskapp
//
//  Created by 高橋　義一 on 2021/10/18.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var dataPicker: UIDatePicker!
    
    let realm = try! Realm()
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        dataPicker.date = task.date
        categoryField.text = task.category
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.dataPicker.date
            self.task.category = self.categoryField.text!
            self.realm.add(self.task, update: .modified)
        }
        setNotification(task: task)
        super.viewWillDisappear(animated)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        if task.title == "" {
            content.title = "(タイトルなし)"
        }else {
            content.title = task.title
        }
        
        if task.contents == "" {
            content.body = "(内容なし)"
        }else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

                let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)

                let center = UNUserNotificationCenter.current()
                center.add(request) { (error) in
                    print(error ?? "ローカル通知登録 OK")
                }
        
                center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
                    for request in requests {
                        print("/---------------")
                        print(request)
                        print("---------------/")
                    }
                }
    }

}
