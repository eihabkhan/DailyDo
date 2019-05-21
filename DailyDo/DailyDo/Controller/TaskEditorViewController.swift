//
//  TaskEditorViewController.swift
//  DailyDo
//
//  Created by Eihab Khan on 5/22/19.
//  Copyright © 2019 Eihab Khan. All rights reserved.
//

import UIKit

class TaskEditorViewController: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet var priorityButtons: [UIButton]!
    @IBOutlet weak var addTaskButton: UIButton!
    
    var selectedPriority = 4
    var isInEditingMode = false
    let addButton = UIBarButtonItem(image: UIImage(named: "send"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(doneClicked))
    private var appDelegate = AppDelegate.getAppDelegate()
    private var context = AppDelegate.getAppDelegate().persistentContainer.viewContext
    var task: Task? {
        didSet {
            isInEditingMode = !(task == nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addGesture()
        
        titleField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        titleField.becomeFirstResponder()
        titleField.delegate = self
        attachKeyboardAction()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    // MARK: Internal
    // TextField Observer
    @objc func textFieldDidChange() {
        if let title = titleField.text {
            addButton.isEnabled = !title.isEmpty
            addTaskButton.isEnabled = !title.isEmpty
        }
    }
    
    func attachKeyboardAction() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
        addButton.tintColor = #colorLiteral(red: 0.8784313725, green: 0.368627451, blue: 0.3647058824, alpha: 1)
        addButton.isEnabled = false
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        doneButton.tintColor = #colorLiteral(red: 0.8784313725, green: 0.368627451, blue: 0.3647058824, alpha: 1)
        toolbar.setItems([doneButton, flexSpace, addButton], animated: true)
        titleField.inputAccessoryView = toolbar
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    func setPriority(forButton sender: UIButton) {
        sender.alpha = 1
        selectedPriority = (priorityButtons.firstIndex(of: sender)!) + 1
        for button in priorityButtons where button != sender {
            button.alpha = 0.2
        }
    }
    
    func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dissmissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dissmissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: Actions
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTaskTapped(_ sender: UIButton) {
    }
    
    @IBAction func priorityTapped(_ sender: UIButton) {
        setPriority(forButton: sender)
    }

}


extension TaskEditorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
