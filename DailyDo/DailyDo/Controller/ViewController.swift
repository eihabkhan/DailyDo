//
//  ViewController.swift
//  DailyDo
//
//  Created by Eihab Khan on 5/22/19.
//  Copyright © 2019 Eihab Khan. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UITableViewController {

    // MARK: Properties
    var tasks = [Task]()
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkUserExistance()
        setupNavItems()
        loadTasks()
    }
    
    func setupNavItems() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))
        let profileItem = UIBarButtonItem(image: UIImage(named: "profile")!, landscapeImagePhone: UIImage(named: "profile")!, style: .plain, target: self, action: #selector(profileTapped))

        if Auth.auth().currentUser == nil {
            navigationItem.rightBarButtonItem = addItem
        } else {
            navigationItem.rightBarButtonItems = [addItem, profileItem]
        }
        
    }

    
    // MARK: Internal
    
    @objc func profileTapped() {
        if let profileVC = storyboard?.instantiateViewController(withIdentifier: "Profile") as? ProfileViewController {
            profileVC.user = Auth.auth().currentUser
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    @objc func addNewTask() {
        if let taskEditorViewController = storyboard?.instantiateViewController(withIdentifier: "TaskEditor") as? TaskEditorViewController {
            present(taskEditorViewController, animated: true)
        }
    }
    
    
    func loadTasks(completed: Bool = false) {
        spinner.startAnimating()
        DataService.shared.readTasks {[weak self] (tasks) in
            self?.tasks = tasks.filter { !$0.isComplete }
            self?.spinner.stopAnimating()
            self?.tableView.reloadData()
        }
    }
    
    
    func checkUserExistance() {
        if Auth.auth().currentUser == nil {
            if let loginVC = storyboard?.instantiateViewController(withIdentifier: "Login") {
                present(loginVC, animated: true)
            }
        }
    }
    
    
    
    @objc func promptForDeletion(at indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        let ac = UIAlertController(title: "Delete Task?", message: "Are you sure you want to delete this task", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] (_) in
            self?.delete(task: task)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func delete(task: Task) {
        DataService.shared.delete(task: task)
        loadTasks()
    }
    
    func complete(task: Task) {
        DataService.shared.REF_TASKS.child(Auth.auth().currentUser!.uid).child(task.uuid).updateChildValues([
            "isComplete": true
            ])
        loadTasks()
    }
    
    // MARK: TableView - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") {[weak self] (_, indexPath) in
            self?.promptForDeletion(at: indexPath)
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") {[weak self] (action, indexPath) in
            if let editTaskVC = self?.storyboard?.instantiateViewController(withIdentifier: "TaskEditor") as? TaskEditorViewController {
                if let task = self?.tasks[indexPath.row] {

                    editTaskVC.task = task
                    self?.present(editTaskVC, animated: true)
                }
                
            }
        }
        
        let complete = UITableViewRowAction(style: .normal, title: "Complete") { [weak self] (action, indexPath) in
            guard let task = self?.tasks[indexPath.row] else { return }
            self?.complete(task: task)
            
        }
        
        complete.backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.5254901961, blue: 0, alpha: 1)
        return [delete, edit, complete]
    }
    
    
    // MARK: TableView - Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Task", for: indexPath) as? TaskTableViewCell else { return TaskTableViewCell() }
        cell.configure(withTask: tasks[indexPath.row])
        return cell
    }
    
    
}

