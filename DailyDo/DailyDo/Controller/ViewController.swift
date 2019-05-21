//
//  ViewController.swift
//  DailyDo
//
//  Created by Eihab Khan on 5/22/19.
//  Copyright © 2019 Eihab Khan. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))
    }

    
    // MARK: Internal
    @objc func addNewTask() {
        if let taskEditorViewController = storyboard?.instantiateViewController(withIdentifier: "TaskEditor") as? TaskEditorViewController {
            present(taskEditorViewController, animated: true)
        }
    }
    
    
}

