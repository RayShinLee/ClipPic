//
//  LoginSignUpViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/24.
//

import UIKit

class SignInViewController: UIViewController {
    
    // MARK: - Properties
    
    
    // MARK: - UI Properties
    
    var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 90
        return backgroundView
    }()
    
    var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .black
        return separatorView
    }()
    
    var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "Quokdog")
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.layer.cornerRadius = 20
        logoImageView.clipsToBounds = true
        return logoImageView
    }()
    
    var welcomeLabel: UILabel = {
        let welcomeLabel = UILabel()
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.text = "Welcome To ClipPic"
        welcomeLabel.textColor = .black
        welcomeLabel.textAlignment = .center
        welcomeLabel.font = UIFont(name: "PingFang TC", size: 25.0)
        return welcomeLabel
    }()
    
    var termsLabel: UILabel = {
        let termsLabel = UILabel()
        termsLabel.translatesAutoresizingMaskIntoConstraints = false
        termsLabel.lineBreakMode = .byWordWrapping
        termsLabel.numberOfLines = 0
        termsLabel.textColor = .lightGray
        termsLabel.font = UIFont(name: "PingFang TC", size: 10.0)
        termsLabel.textAlignment = .center
        termsLabel.text = "By continuing you agree to ClipPics's Terms of Service and Privacy Policy"
        return termsLabel
    }()
    
    var googleButton: UIButton = {
        let googleButton = UIButton(type: .custom)
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        googleButton.setTitle("Continue With Google", for: .normal)
        googleButton.backgroundColor = UIColor(red: 222/255, green: 82/255, blue: 70/255, alpha: 1)
        googleButton.layer.cornerRadius = 20
        return googleButton
    }()
    
    var appleButton: UIButton = {
        let appleButton = UIButton(type: .custom)
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.setTitle("Continue With Apple", for: .normal)
        appleButton.backgroundColor = .black
        appleButton.layer.cornerRadius = 20
        return appleButton
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        setUpView()
    }
    
    // MARK: - Methods
    
    func setUpView() {
        view.addSubview(logoImageView)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        view.addSubview(backgroundView)
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 100).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 35).isActive = true
        backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55).isActive = true
        setUpBackgroundView()
    }
    
    func setUpBackgroundView() {
        backgroundView.addSubview(welcomeLabel)
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        welcomeLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 30).isActive = true
        
        backgroundView.addSubview(separatorView)
        separatorView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 30).isActive = true
        separatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        separatorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        backgroundView.addSubview(termsLabel)
        termsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        termsLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        termsLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        termsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        setUpSignInButtons()
    }
    
    func setUpSignInButtons() {
        backgroundView.addSubview(googleButton)
        googleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        googleButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 30).isActive = true
        googleButton.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.7).isActive = true
        googleButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        backgroundView.addSubview(appleButton)
        appleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appleButton.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 10).isActive = true
        appleButton.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.7).isActive = true
        appleButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
