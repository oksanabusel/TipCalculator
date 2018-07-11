//
//  RootViewController.swift
//  TipCalculator
//
//  Created by Cat on 5/14/18.
//  Copyright © 2018 Cat. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var sumTextField: UITextField!
    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var totalTipSumLabel: UILabel!
    @IBOutlet weak var totalSumLabel: UILabel!
    @IBOutlet weak var percentageSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sumTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
        sumTextField.inputAccessoryView = toolBar

    }
    
    @IBAction func sumTextField(_ sender: Any) {
        calculateTip()
    }
    
    @IBAction func sliderValueChange(_ sender: Any) {
        calculateTip()
    }
    
    @objc func keyboardWillAppear() {
       percentageSlider.isEnabled = false
        
    }
    
    @objc func keyboardWillDisappear() {
        percentageSlider.isEnabled = true
        calculateTip()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let components = string.components(separatedBy: inverseSet)
        let filtered = components.joined(separator: "")
        
        if filtered == string {
            return true
        } else {
            if string == "." {
                let countdots = textField.text!.components(separatedBy:".").count - 1
                if countdots == 0 {
                    return true
                }else{
                    if countdots > 0 && string == "." {
                        return false
                    } else {
                        return true
                    }
                }
            } else {
                return false
            }
        }
    }
   
    
    func calculateTip() {
        let percentage = Int(percentageSlider.value)
        tipPercentLabel.text = ("Tip(\(percentage))%")
        
        if (sumTextField.text?.contains("$"))! {
            sumTextField.text?.removeFirst()
        }

        if let sum = Double(sumTextField.text!) {
            let tip = ((Double(percentage)*sum)/100)
            let roundTip = String(format:"%.2f", tip)
            
            totalTipSumLabel.text = String("$\(roundTip)")
            let total = sum + tip
            let roundTotal = String(format:"%.2f", total)
            totalSumLabel.text = String("$\(roundTotal)")
            addDollarPrefix()
        }
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
        addDollarPrefix()
    }
    
    func addDollarPrefix() {
        if !(sumTextField.text?.contains("$"))! && !((sumTextField.text?.isEmpty)!) {
            var dollarPrefix = "$"
            dollarPrefix += sumTextField.text!
            sumTextField.text = dollarPrefix
        }
    }
}
