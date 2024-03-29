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
import SafariServices

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
                                                       buttonStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 18
        return stackView
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [privacyPolicyButton, eulaButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.spacing = 0
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
    
    lazy var privacyPolicyButton: UIButton = {
        let privacyPolicyButton = UIButton()
        privacyPolicyButton.translatesAutoresizingMaskIntoConstraints = false
        privacyPolicyButton.isUserInteractionEnabled = true
        privacyPolicyButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        privacyPolicyButton.setTitleColor(.systemGray, for: .normal)
        privacyPolicyButton.setTitle("Privacy Policy", for: .normal)
        privacyPolicyButton.addTarget(self, action: #selector(taptermsButton), for: .touchUpInside)
        return privacyPolicyButton
    }()
    
    lazy var eulaButton: UIButton = {
        let eulaButton = UIButton()
        eulaButton.translatesAutoresizingMaskIntoConstraints = false
        eulaButton.isUserInteractionEnabled = true
        eulaButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        eulaButton.setTitleColor(.systemGray, for: .normal)
        eulaButton.setTitle("EULA", for: .normal)
        eulaButton.addTarget(self, action: #selector(tapEULAButton), for: .touchUpInside)
        return eulaButton
    }()
    
    lazy var googleButton: GIDSignInButton = {
        let googleButton = GIDSignInButton()
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        googleButton.colorScheme = .light
        googleButton.style = .wide
        googleButton.addTarget(self, action: #selector(tapGoogleSignIn), for: .touchUpInside)
        return googleButton
    }()
    
    lazy var siwaButton: ASAuthorizationAppleIDButton = {
        let siwaButton = ASAuthorizationAppleIDButton()
        siwaButton.translatesAutoresizingMaskIntoConstraints = false
        siwaButton.addTarget(self, action: #selector(tapAppleSignIn), for: .touchUpInside)
        return siwaButton
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        setUpView()
        loopVideo()
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
        guard let url = URL(
            string: "https://www.privacypolicies.com/live/67f30222-1200-4518-82cd-2408a0ea3728") else {
                self.showError(message: "Something went wrong.\nPlease try again.")
                return
            }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
    
    @objc func tapEULAButton() {
        guard let url = URL(
            string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") else {
                self.showError(message: "Something went wrong.\nPlease try again.")
                return
            }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
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
        privacyPolicyButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        privacyPolicyButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        eulaButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        eulaButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    func setUpSignInButtons() {
        googleButton.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.7).isActive = true
        googleButton.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.18).isActive = true
        siwaButton.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.7).isActive = true
        siwaButton.heightAnchor.constraint(equalTo: googleButton.heightAnchor).isActive = true
    }
}

    // MARK: - AccountManagerDelegate

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
