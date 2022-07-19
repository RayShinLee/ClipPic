//
//  EditProfileTableView.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/7/4.
//

import UIKit

class EditProfileTableView: UITableView {

    // MARK: - Properties
    
    var firstName: String?
    var lastName: String?
    
    // MARK: - View life cycle
    
    init(frame: CGRect) {
        super.init(frame: frame, style: .plain)
        self.backgroundColor = .systemBackground
        register(EditProfileTableViewCell.self, forCellReuseIdentifier: "editCell")
        
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

    // MARK: - UITableView

extension EditProfileTableView: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: "editCell", for: indexPath)
        guard let editCell = cell as? EditProfileTableViewCell else {
            return cell
        }
        
        switch indexPath.row {
        case 0:
            editCell.nameLabel.text = "First Name"
            editCell.nameTextField.placeholder = "Enter first name"
            editCell.textChangeHandler = { [weak self] text in
                self?.firstName = text
            }
        case 1:
            editCell.nameLabel.text = "Last Name"
            editCell.nameTextField.placeholder = "Enter last name"
            editCell.textChangeHandler = { [weak self] text in
                self?.lastName = text
            }
        default:
            assert(false)
        }
        return editCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}
