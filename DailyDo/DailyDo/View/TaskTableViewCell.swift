//
//  TaskTableViewCell.swift
//  DailyDo
//
//  Created by Eihab Khan on 5/22/19.
//  Copyright © 2019 Eihab Khan. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var priorityIndicatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configure(withTask task: Task) {
        self.taskTitleLabel.text = task.title
        applyPriorityColor(withPriority: TaskPriority(rawValue: task.priority)!)
    }
    
    private func applyPriorityColor(withPriority priority: TaskPriority) {
        var color: UIColor
        switch priority {
        case .p1:
            color = #colorLiteral(red: 0.8352941176, green: 0, blue: 0.09803921569, alpha: 1)
        case .p2:
            color = #colorLiteral(red: 1, green: 0.4156862745, blue: 0, alpha: 1)
        case .p3:
            color = #colorLiteral(red: 1, green: 0.8509803922, blue: 0.4470588235, alpha: 1)
        default:
            color = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        self.priorityIndicatorView.backgroundColor = color
    }

}
