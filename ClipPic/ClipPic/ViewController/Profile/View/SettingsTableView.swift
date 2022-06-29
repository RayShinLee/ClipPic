//
//  SettingsTableView.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/29.
//

import UIKit

class SettingsTableView: UITableView {

    // MARK: - View life cycle
    init(frame: CGRect) {
        super.init(frame: frame, style: .plain)
        self.backgroundColor = .systemBackground
        register(SettingTableViewCell.self, forCellReuseIdentifier: "settingCell")
        
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingsTableView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)
        guard let settingCell = cell as? SettingTableViewCell else {
            return cell
        }
        
        switch indexPath.section {
        case 0:
            settingCell.settingOptionLabel.text = "Account settings"
            settingCell.settingOptionLabel.textColor = .red
        case 1:
            settingCell.settingOptionLabel.text = "Sign Out"
        case 2:
            settingCell.settingOptionLabel.text = "Delete Account"
        default:
            assert(false)
        }
        
        return settingCell
    }
}
