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
    let addButton = UIBarButtonItem(image: UIImage(named: "send"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(addTaskTapped(_:)))
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
        // Keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        titleField.becomeFirstResponder()
        titleField.delegate = self
        attachKeyboardAction()
        checkForExistingTask()
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
    
    @objc func keyboardWillAppear() {
        titleField.inputAccessoryView?.isHidden = false
    }
    
    @objc func keyboardWillDisappear() {
        //Do something here
        titleField.inputAccessoryView?.isHidden = true
        print("Keyboard hidden")
    }
    
    func checkForExistingTask() {
        if isInEditingMode {
            guard let task = task  else { return }
            
            titleField.text = task.title
            let priority = TaskPriority(rawValue: task.priority)!
            
            switch priority {
            case .p1:
                selectedPriority = 1
            case .p2:
                selectedPriority = 2
            case .p3:
                selectedPriority = 3
            default:
                selectedPriority = 4
            }
            
            setPriority(forButton: priorityButtons[selectedPriority - 1])
            addTaskButton.setTitle("Update Task", for: .normal)
            
        }
        
    }
    
    func update(task: Task) {
        let request = Task.createFetchRequest()
        let predicate = NSPredicate(format: "uuid == %@", task.uuid)
        request.predicate = predicate
        
        do {
            if let taskToUpdate = try context.fetch(request).first {
                print(taskToUpdate)
                taskToUpdate.setValue(task.title, forKey: "title")
                taskToUpdate.setValue(task.priority, forKey: "priority")
                try context.save()
            }
            
        } catch {
            print("Error updating task, \(error.localizedDescription)")
        }
        
    }
    
    func attachKeyboardAction() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dissmissKeyboard))
        addButton.tintColor = #colorLiteral(red: 0.8784313725, green: 0.368627451, blue: 0.3647058824, alpha: 1)
        addButton.isEnabled = false
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        doneButton.tintColor = #colorLiteral(red: 0.8784313725, green: 0.368627451, blue: 0.3647058824, alpha: 1)
        toolbar.setItems([doneButton, flexSpace, addButton], animated: true)
        titleField.inputAccessoryView = toolbar
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
        guard let title = titleField.text else { return }
        
        if isInEditingMode {
            
            let updatedTask = task!
            updatedTask.title = title
            updatedTask.priority = "p\(selectedPriority)"
            
            update(task: updatedTask)
            
            
        } else {
            let task = Task(context: context)
            task.title = title
            task.priority = "p\(selectedPriority)"
            task.uuid = UUID().uuidString
            appDelegate.saveContext()
        }
        
        dismiss(animated: true, completion: nil)
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
