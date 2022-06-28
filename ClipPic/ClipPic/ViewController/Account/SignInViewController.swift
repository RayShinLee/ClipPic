//
//  LoginSignUpViewController.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/24.
//

import UIKit
import AVFoundation
import AuthenticationServices
import CryptoKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    // MARK: - Properties
    
    var backgroundVideoPlayer: AVPlayer = {
        guard let path = Bundle.main.path(forResource: "dino", ofType: "mp4") else {
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
    
    fileprivate var currentNonce: String?

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
        welcomeLabel.font = UIFont(name: "PingFang TC", size: 27.0)
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
        googleButton.layer.cornerRadius = 5
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
        //tabBarController?.tabBar.isHidden = true
        setUpView()
        loopVideo()
        siwaButton.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundVideoPlayerLayer.frame = videoView.bounds
    }
    
    // MARK: - Action methods
    
    @objc func appleSignInTapped() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authController = ASAuthorizationController(authorizationRequests: [request])
        authController.presentationContextProvider = self
        authController.delegate = self
        authController.performRequests()
    }
    
    // MARK: - Methods
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func loopVideo() {
        backgroundVideoPlayer.play()
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { _ in
            self.backgroundVideoPlayer.seek(to: .zero)
            self.backgroundVideoPlayer.play()
        }
    }
    
    func setUpView() {
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

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding,
                                ASAuthorizationControllerDelegate {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window! // Which window should the authorization dialog appear -> self(SignInVC)
    }
    
    // MARK: Delegate
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
        guard let error = error as? ASAuthorizationError else {
            return
        }
        
        switch error.code {
        case .canceled:
            print("Cancelled")
        case .unknown:
            print("Unknown")
        case .invalidResponse:
            print("Invalid Response")
        case .notHandled:
            print("Not handled. Maybe internet failure during login.")
        case .failed:
            print("Failed")
        default:
            print("Default")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            UserDefaults.standard.set(appleIDCredential.user, forKey: "appleAuthorizedUserIdKey")
            
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }

            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Failed to fetch identity token")
                return
            }

            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Failed to decode identity token")
                return
            }
            
            let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                              idToken: idTokenString,
                                                              rawNonce: nonce)
            
            Auth.auth().signIn(with: firebaseCredential) { (authResult, error) in
                 if let error = error {
                    print(error.localizedDescription)
                    return
                 }
                print(authResult?.user)
                
                 
                 // User is signed in to Firebase with Apple.
                 // Make a request to set user's display name on Firebase
                 
//                 let changeRequest = authResult?.user.createProfileChangeRequest()
//                 changeRequest?.displayName = appleIDCredential.fullName?.givenName
//                 changeRequest?.commitChanges(completion: { (error) in
//
//                    if let error = error {
//                        print(error.localizedDescription)
//                    } else {
//                        print("Updated display name: \(Auth.auth().currentUser!.displayName!)")
//                    }
//                 })
            }
        }
    }
}

/*
 Apple auth
 let userID = appleIDCredential.user
 let email = appleIDCredential.email
 let givenName = appleIDCredential.fullName?.givenName
 let familyName = appleIDCredential.fullName?.familyName
 let nickName = appleIDCredential.fullName?.nickname
 
 var identityToken : String?
 if let token = appleIDCredential.identityToken {
     identityToken = String(bytes: token, encoding: .utf8)
 }
 
 var authorizationCode : String?
 if let code = appleIDCredential.authorizationCode {
     authorizationCode = String(bytes: code, encoding: .utf8)
 }
*/
