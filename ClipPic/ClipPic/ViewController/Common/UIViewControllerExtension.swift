//
//  UIViewControllerExtension.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/7/13.
//

import Foundation
import UIKit

extension UIViewController {
    
    // MARK: - Alert Method
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
