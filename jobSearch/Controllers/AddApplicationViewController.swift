//
//  AddApplicationViewController.swift
//  jobSearch
//
//  Created by Kenneth Aguilar on 11/10/20.
//  Copyright © 2020 StudentDevs. All rights reserved.
//

import UIKit
import Firebase

class AddApplicationViewController: UIViewController {
    
    @IBOutlet weak var companyNameField: UITextField!
    @IBOutlet weak var positionNameField: UITextField!
    @IBOutlet weak var dateAppliedPicker: UIDatePicker!
    @IBOutlet weak var statusPicker: UIPickerView!
    @IBOutlet weak var detailsTextView: UITextView!
    
    var dateApplied: String = ""
    var status: String = ""
    var statuses: [String] = ["Applied", "Accepted", "Rejected", "Declined"]
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        statusPicker.dataSource = self
        statusPicker.delegate = self

    }
    
    func grabDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateApplied = formatter.string(from: dateAppliedPicker.date)
        self.view.endEditing(true)
    }
    @IBAction func addApplicationBtn(_ sender: Any) {
        grabDate()
        
        if let companyName = companyNameField.text, !companyNameField.text!.isEmpty, let positionName = positionNameField.text, !positionNameField.text!.isEmpty,  let details = detailsTextView.text, !detailsTextView.text!.isEmpty {
    
            db.collection("Users").document(User.sharedInstance.email).collection("Applications").document(companyName).setData([
                "companyName": companyName
            ]) { (error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: "There was an issue saving data to firestore", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

                    self.present(alert, animated: true)
                } else {
                    
                    DispatchQueue.main.async {
                        self.dismiss(animated: false, completion: nil)
                    }
                }
            }

            db.collection("Users").document(User.sharedInstance.email).collection("Applications").document(companyName).collection("Positions").document(positionName).setData( [
                "positionName": positionName,
                "dateApplied": dateApplied,
                "status": status,
                "details": details
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                } else {
                    print("Successfully saved data.")
                    
                    DispatchQueue.main.async {
                        self.dismiss(animated: false, completion: nil)
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Enter the necessary information", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

            self.present(alert, animated: true)

        }

    }
}

extension AddApplicationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statuses[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        status = statuses[row]
    }
}
