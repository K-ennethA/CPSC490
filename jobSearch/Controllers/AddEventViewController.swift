//
//  addEventViewController.swift
//  jobSearch
//
//  Created by Kenneth Aguilar on 11/6/20.
//  Copyright © 2020 StudentDevs. All rights reserved.
//

import UIKit
import Firebase

class AddEventViewController: UIViewController {
    
    let db = Firestore.firestore()
    var startDate: String = ""

    @IBOutlet weak var eventNameField: UITextField!
    @IBOutlet weak var eventDescriptionLabel: UITextField!
    @IBOutlet weak var eventDate: UIDatePicker!
    
        var components = DateComponents()
        
        override func viewDidLoad() {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge])
            {
                (granted, error) in
            }
            super.viewDidLoad()
            // Do any additional setup after loading the view.
        }
        
        func grabDate() {
            components = eventDate.calendar.dateComponents([.year, .month, .day, .hour, .minute], from: eventDate.date)
            setTime()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            startDate = formatter.string(from: eventDate.date)
            self.view.endEditing(true)
        }
        
        func setTime() {
            guard var time = components.minute else { return }
            if time >= 30{
                time -= 30
                components.minute = time
            } else {
                components.minute = 60 - (30 - time)
                if components.hour == 0 {
                    components.hour = 23
                } else {
                    components.hour = components.hour! - 1
                }
            }
        }
        
        @IBAction func addEventBtn(_ sender: Any) {

            grabDate()
            
            if let eventName = eventNameField.text, !eventNameField.text!.isEmpty, let eventDescription = eventDescriptionLabel.text, !eventDescriptionLabel.text!.isEmpty{
                print("Event name is \(eventName)")
                db.collection("Users").document(User.sharedInstance.email).collection("calEvent").addDocument(data: [
                    "name": eventName,
                    "details": eventDescription,
                    "start": startDate
                ])
                { (error) in
                    if let e = error {
                        let alert = UIAlertController(title: "Error", message: "There was an issue saving data to firestore", preferredStyle: .alert)

                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

                        self.present(alert, animated: true)
                        print("There was an issue saving data to firestore, \(e)")
                    } else {
                        print("Successfully saved data.")
                        
                        DispatchQueue.main.async {
                            self.dismiss(animated: false, completion: nil)
                        }
                    }
                }
                notif()
            }
            else {
                let alert = UIAlertController(title: "Error", message: "Enter the necessary information", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

                self.present(alert, animated: true)

            }
        }
        
        func notif(){
            let content = UNMutableNotificationContent()
            content.title = "You have an event today!"
            content.body = eventNameField.text!
            //set notification for 8:00am day it is due
            content.badge = 1
            let t = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let r = UNNotificationRequest(identifier: "any", content: content, trigger: t)
            UNUserNotificationCenter.current().add(r, withCompletionHandler: nil)
        }
        
}
