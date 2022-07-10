//
//  SettingsViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/23.
//

import UIKit
import FirebaseAuth
import SwiftUI

class SettingsViewController: UIViewController {
    
    // MARK: - UI Properties
    
    lazy var tableView: SettingsTableView = {
        let tableView = SettingsTableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.interactionDelegate = self
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.title = "Settings"
        setUpView()
    }
    
    // MARK: - Methods
    
    func showAlert(title: String, message: String, optionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: optionTitle, style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func setUpView() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
}

extension SettingsViewController: SettingsTableViewDelegate {
    func showAccountSettingVC() {
        self.show(EditProfileViewController(), sender: nil)
    }
    
    func signOut() {
        AccountManager.shared.signOut() { error in
            if let error = error {
                print(error)
                self.showAlert(title: "Error", message: "\(error)", optionTitle: "")
            }
            
            self.navigationController?.popToRootViewController(animated: false)
            TabBarViewController.shared.selectedIndex = 0
        }
    }
    
    func deleteAccount() {
        AccountManager.shared.deleteUser() { error in
            if let error = error {
                print(error)
                self.showAlert(title: "Error", message: "\(error)", optionTitle: "")
            }
            
            self.navigationController?.popToRootViewController(animated: false)
            TabBarViewController.shared.selectedIndex = 0
        }
    }
}
