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
        guard let path = Bundle.main.path(forResource: "polaroid", ofType: "mp4") else {
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
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [welcomeLabel,
                                                       separatorView,
                                                       googleButton,
                                                       siwaButton,
                                                       termsButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 18
        return stackView
    }()
    
    var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.layer.cornerRadius = 20
        logoImageView.clipsToBounds = true
        logoImageView.image = UIImage(named: "ClipPic_Logo_icon")
        return logoImageView
    }()
    
    var welcomeLabel: UILabel = {
        let welcomeLabel = UILabel()
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
        welcomeLabel.text = "Welcome To ClipPic"
        welcomeLabel.textColor = UIColor(red: 137/255, green: 71/255, blue: 155/255, alpha: 1)
        welcomeLabel.textAlignment = .center
        return welcomeLabel
    }()
    
    var termsButton: UIButton = {
        let termsButton = UIButton()
        termsButton.translatesAutoresizingMaskIntoConstraints = false
        termsButton.isUserInteractionEnabled = true
        termsButton.setTitleColor(.black, for: .normal)
        termsButton.setTitle("Privacy Policy", for: .normal)
        return termsButton
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
    
    @objc func taptermsButton() {
        WebKitViewController().viewModel = WebkitModel(urlString: "https://www.freeprivacypolicy.com/live/9bd68d82-0ebc-46ec-bcc9-75fe509bfcdd")
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.present(WebKitViewController(), animated: true, completion: nil)
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
        
        view.addSubview(backgroundView)
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 100).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 35).isActive = true
        backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
        
        backgroundView.addSubview(logoImageView)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 8).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 110).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        backgroundView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true

        setUpStackView()
    }
    
    func setUpStackView() {
        welcomeLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        welcomeLabel.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.13).isActive = true
        separatorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        setUpSignInButtons()
        termsButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        termsButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setUpSignInButtons() {
        googleButton.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.7).isActive = true
        googleButton.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.18).isActive = true
        siwaButton.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.7).isActive = true
        siwaButton.heightAnchor.constraint(equalTo: googleButton.heightAnchor).isActive = true
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
