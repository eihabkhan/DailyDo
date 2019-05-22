//
//  ViewController.swift
//  DailyDo
//
//  Created by Eihab Khan on 5/22/19.
//  Copyright © 2019 Eihab Khan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    // MARK: Properties
    var tasks = [Task]()
    let appDelegate = AppDelegate.getAppDelegate()
    let context = AppDelegate.getAppDelegate().persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTasks()
    }

    
    // MARK: Internal
    @objc func addNewTask() {
        if let taskEditorViewController = storyboard?.instantiateViewController(withIdentifier: "TaskEditor") as? TaskEditorViewController {
            present(taskEditorViewController, animated: true)
        }
    }
    
    func loadTasks() {
        let request = Task.createFetchRequest()
        let sort = NSSortDescriptor(key: "priority", ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            tasks = try context.fetch(request)
            print("Received \(tasks.count) tasks")
            tableView.reloadData()
        } catch {
            print("ERROR: \(error.localizedDescription)")
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
        
        return [delete, edit]
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completeAction = UIContextualAction(style: .normal, title:  "Complete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            print("OK, marked as Closed")
            success(true)
        })
        completeAction.backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.5254901961, blue: 0, alpha: 1)
        completeAction.image = UIImage(named: "check")
        return UISwipeActionsConfiguration(actions: [completeAction])
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

