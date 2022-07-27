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
    
    func showAlert(title: String, message: String, optionTitle: String, actionHandler: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: optionTitle, style: .default, handler: actionHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancelAction)
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

    // MARK: - SettingsTableViewDelegate
extension SettingsViewController: SettingsTableViewDelegate {
    func showAccountSettingVC() {
        self.show(EditProfileViewController(), sender: nil)
    }
    
    func signOut() {
        showAlert(title: "Sign Out", message: "Are you sure you want to Sign Out?", optionTitle: "Sign Out") { _ in
            AccountManager.shared.signOut() { error in
                if let error = error {
                    print(error)
                    self.showError(message: "Something went wrong.\nPlease try again.")
                }
                
                self.navigationController?.popToRootViewController(animated: false)
                TabBarViewController.shared.selectedIndex = 0
            }
        }
    }
    
    func deleteAccount() {
        showAlert(title: "Delete Account", message: "Are you sure you want to delete your account?", optionTitle: "Delete") { _ in
            AccountManager.shared.deleteUser() { error in
                if let error = error {
                    print(error)
                    self.showError(message: "Something went wrong.\nPlease try again.")
                }
                
                self.navigationController?.popToRootViewController(animated: false)
                TabBarViewController.shared.selectedIndex = 0
            }
        }
    }
}
