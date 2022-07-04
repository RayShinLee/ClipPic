//
//  LoginSignUpViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/24.
//

import UIKit
import AVFoundation
import FirebaseAuth
import GoogleSignIn
import SwiftUI
import AuthenticationServices

class SignInViewController: UIViewController {
    
    // MARK: - Properties
    
    var backgroundVideoPlayer: AVPlayer = {
        guard let path = Bundle.main.path(forResource: "pexels-teona-swift-6912204", ofType: "mp4") else {
            fatalError("Invalid Video path")
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        return player
    }()
    
    lazy var backgroundVideoPlayerLayer: AVPlayerLayer = {
        let playerLayer = AVPlayerLayer(player: backgroundVideoPlayer)
        playerLayer.videoGravity = .resizeAspectFill
        return playerLayer
    }()
    
    // MARK: - UI Properties
    
    var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 90
        return backgroundView
    }()
    
    var videoView: UIView = {
        let videoView = UIView()
        videoView.translatesAutoresizingMaskIntoConstraints = false
        return videoView
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
        logoImageView.backgroundColor = .white
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
        welcomeLabel.font = UIFont(name: "PingFang TC", size: 28.0)
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
    
    var googleButton: GIDSignInButton = {
        let googleButton = GIDSignInButton()
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        googleButton.colorScheme = .light
        googleButton.style = .wide
        return googleButton
    }()
    
    var siwaButton: ASAuthorizationAppleIDButton = {
        let siwaButton = ASAuthorizationAppleIDButton()
        siwaButton.translatesAutoresizingMaskIntoConstraints = false
        return siwaButton
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        setUpView()
        loopVideo()
        siwaButton.addTarget(self, action: #selector(tapAppleSignIn), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(tapGoogleSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundVideoPlayerLayer.frame = videoView.bounds
    }
    
    // MARK: - Action methods
    @objc func tapGoogleSignIn() {
        AccountManager.shared.delegte = self
        AccountManager.shared.signInWithGoogle(on: self)
    }
    
    @objc func tapAppleSignIn() {
        AccountManager.shared.delegte = self
        AccountManager.shared.signInWithApple(on: view)
    }
    
    // MARK: - Methods
    
    private func loopVideo() {
        backgroundVideoPlayer.play()
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { _ in
            self.backgroundVideoPlayer.seek(to: .zero)
            self.backgroundVideoPlayer.play()
        }
    }
    
    func setUpView() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(videoView)
        videoView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        videoView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        videoView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        videoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
        videoView.layer.addSublayer(backgroundVideoPlayerLayer)
        
        videoView.addSubview(logoImageView)
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
        googleButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 60).isActive = true
        googleButton.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.7).isActive = true
        googleButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        backgroundView.addSubview(siwaButton)
        siwaButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        siwaButton.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 20).isActive = true
        siwaButton.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.7).isActive = true
        siwaButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

extension SignInViewController: AccountManagerDelegate {
    func sigInSuccess(shouldSetUpAccount: Bool) {
        if shouldSetUpAccount {
            let setUpAccountViewController = SetUpAccountViewController()
            navigationController?.pushViewController(setUpAccountViewController, animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
