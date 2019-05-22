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
    let appDelegate = AppDelegate.getAppDelegate()
    let context = AppDelegate.getAppDelegate().persistentContainer.viewContext
    var filterAction: UIBarButtonItem!
    
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
        
        filterAction = UIBarButtonItem(title: "Filter: Current", style: .plain, target: self, action: #selector(filterTapped))
        
        if Auth.auth().currentUser == nil {
            navigationItem.rightBarButtonItem = addItem
        } else {
            navigationItem.rightBarButtonItems = [addItem, profileItem]
        }
        
        navigationItem.leftBarButtonItem = filterAction
        
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
    
    @objc func filterTapped() {
        let ac = UIAlertController(title: "Filter Tasks", message: "Choose how you want to view your tasks", preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Show Current Tasks", style: .default, handler: { [weak self] (_) in
            self?.filterAction.title = "Filter: Current"
            self?.loadTasks()
        }))
        ac.addAction(UIAlertAction(title: "Show Completed Tasks", style: .default, handler: { [weak self] (_) in
            self?.filterAction.title = "Filter: Completed"
            self?.loadTasks(completed: true)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func loadTasks(completed: Bool = false) {
        
        let request = Task.createFetchRequest()
        let sort = NSSortDescriptor(key: "priority", ascending: true)
        let predicate = NSPredicate(format: "isComplete == %@", NSNumber(value: completed))
        print(completed)
        request.predicate = predicate
        request.sortDescriptors = [sort]
        
        do {
            tasks = try context.fetch(request)
            print("Received \(tasks.count) tasks")
            tableView.reloadData()
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    
    func checkUserExistance() {
        if Auth.auth().currentUser == nil {
            if let loginVC = storyboard?.instantiateViewController(withIdentifier: "Login") {
                present(loginVC, animated: true)
            }
        }
    }
    
    
    
    @objc func promptForDeletion(task: Task, at indexPath: IndexPath) {
        let ac = UIAlertController(title: "Delete Task?", message: "Are you sure you want to delete this task", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {[weak self] (_) in
            self?.delete(task: task, at: indexPath)
            
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func delete(task: Task, at indexPath: IndexPath) {
        appDelegate.persistentContainer.viewContext.delete(task)
        tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        appDelegate.saveContext()
    }
    
    func complete(task: Task) {
        let request = Task.createFetchRequest()
        let predicate = NSPredicate(format: "uuid == %@", task.uuid)
        request.predicate = predicate
    
        do {
            if let taskToComplete = try context.fetch(request).first {
                print(taskToComplete)
                taskToComplete.setValue(true, forKey: "isComplete")
                try context.save()
                loadTasks()
            }
            
        } catch {
            print("Error updating task, \(error.localizedDescription)")
        }
    }
    
    // MARK: TableView - Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") {[weak self] (_, indexPath) in
            guard let task = self?.tasks[indexPath.row] else { return }
            self?.promptForDeletion(task: task, at: indexPath)
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") {[weak self] (action, indexPath) in
            if let editTaskVC = self?.storyboard?.instantiateViewController(withIdentifier: "TaskEditor") as? TaskEditorViewController {
                if let task = self?.tasks[indexPath.row] {
                    print("Selected Task: \(task.title)")
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
        print(tasks[indexPath.row].uuid)
        cell.configure(withTask: tasks[indexPath.row])
        return cell
    }
    
    
}

