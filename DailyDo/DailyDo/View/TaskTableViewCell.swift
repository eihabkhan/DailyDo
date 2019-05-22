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
            color = #colorLiteral(red: 0.8784313725, green: 0.368627451, blue: 0.3647058824, alpha: 1)
        case .p2:
            color = #colorLiteral(red: 0.9960784314, green: 0.8901960784, blue: 0.4784313725, alpha: 1)
        case .p3:
            color = #colorLiteral(red: 0.5333333333, green: 0.7803921569, blue: 0.7568627451, alpha: 1)
        default:
            color = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        self.priorityIndicatorView.backgroundColor = color
    }

}
