//
//  ProfileViewController.swift
//  DailyDo
//
//  Created by Eihab Khan on 5/22/19.
//  Copyright © 2019 Eihab Khan. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var user: User?
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    func configureUI(){
        emailLabel.text = user?.email
        usernameLabel.text = user?.displayName
    }
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            if let loginVC = storyboard?.instantiateViewController(withIdentifier: "Login") {
                navigationController?.popViewController(animated: true)
                present(loginVC, animated: true)
            }
            
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    @IBAction func showHistoryTapped(_ sender: UIButton) {
        if let historyVC = storyboard?.instantiateViewController(withIdentifier: "History") as? HistoryViewController {
            DataService.shared.readTasks {[weak self] (tasks) in
                guard let tasks = tasks else { return }
                historyVC.completedTasks = tasks.filter { $0.isComplete }
                self?.navigationController?.pushViewController(historyVC, animated: true)
            }
            
            
            
        }
    }
    


}

