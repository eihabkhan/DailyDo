//
//  HistoryViewController.swift
//  DailyDo
//
//  Created by Eihab Khan on 5/22/19.
//  Copyright © 2019 Eihab Khan. All rights reserved.
//

import UIKit

class HistoryViewController: UITableViewController {
    
    var completedTasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    // MARK: TableView - Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedTasks.count
    }
    
    // MARK: TableView - Delegate

}
