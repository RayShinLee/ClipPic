//
//  CPLoadingHUD.swift
//  ClipPicHUD
//
//  Created by Rayshin Lee on 2022/7/8.
//

import UIKit
import CoreGraphics

class ClipPicProgressHUD: UIView {
    
    // MARK: - Type properties & methods
    private static let `default` = ClipPicProgressHUD()
    
    static func show() {
        guard let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first else {
            return
        }
        
        DispatchQueue.main.async {
            ClipPicProgressHUD.default.show(on: keyWindow)
        }
    }
    
    static func hide() {
        DispatchQueue.main.async {
            ClipPicProgressHUD.default.hide()
        }
    }
    
    // MARK: - UI Properties
    private lazy var hudBackgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var logoInnerImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo_center")
        return imageView
    }()
    
    private lazy var logoOutsideImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo_outside")
        return imageView
    }()
    
    private var logoInnerImageViewWidthConstraint: NSLayoutConstraint?
    
    private var logoInnerImageViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: - Object life cycle
    private init() {
        super.init(frame: .zero)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func show(on view: UIView) {
        view.addSubview(self)
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        layoutIfNeeded()
    }
    
    private func hide() {
        removeFromSuperview()
    }
    
    private func animate() {
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn) {
            self.logoOutsideImageView.transform = CGAffineTransform(rotationAngle: .pi)
            self.logoInnerImageViewWidthConstraint?.constant = 100
            self.logoInnerImageViewHeightConstraint?.constant = 100
            self.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                self.logoOutsideImageView.transform = CGAffineTransform(rotationAngle: 0)
                self.logoInnerImageViewWidthConstraint?.constant = 130
                self.logoInnerImageViewHeightConstraint?.constant = 130
                self.layoutIfNeeded()
            } completion: { _ in
                self.animate()
            }
        }
    }

    private func setUpViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        addSubview(hudBackgroundView)
        hudBackgroundView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        hudBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        hudBackgroundView.widthAnchor.constraint(equalToConstant: 160).isActive = true
        hudBackgroundView.heightAnchor.constraint(equalToConstant: 160).isActive = true
        
        hudBackgroundView.addSubview(logoOutsideImageView)
        logoOutsideImageView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        logoOutsideImageView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        logoOutsideImageView.centerXAnchor.constraint(equalTo: hudBackgroundView.centerXAnchor).isActive = true
        logoOutsideImageView.centerYAnchor.constraint(equalTo: hudBackgroundView.centerYAnchor).isActive = true
        
        hudBackgroundView.addSubview(logoInnerImageView)
        logoInnerImageViewWidthConstraint = logoInnerImageView.widthAnchor.constraint(equalToConstant: 130)
        logoInnerImageViewHeightConstraint = logoInnerImageView.heightAnchor.constraint(equalToConstant: 130)
        logoInnerImageViewWidthConstraint?.isActive = true
        logoInnerImageViewHeightConstraint?.isActive = true
        logoInnerImageView.centerXAnchor.constraint(equalTo: hudBackgroundView.centerXAnchor).isActive = true
        logoInnerImageView.centerYAnchor.constraint(equalTo: hudBackgroundView.centerYAnchor).isActive = true
        animate()
    }
}
