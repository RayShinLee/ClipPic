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
    
    func setUpView() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
}

extension SettingsViewController: SettingsTableViewDelegate {
    func signOut() {
        AccountManager.shared.signOut()
    }
}
