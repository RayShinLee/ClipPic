//
//  AccountManager.swift
//  ClipPic
//
//  Created by RayShin Lee on 2022/6/29.
//

import Foundation
import AuthenticationServices
import CryptoKit
import GoogleSignIn
import FirebaseAuth
import FirebaseCore

class AccountManager: NSObject {
    
    static let shared = AccountManager()
    
    let firebaseAuth = Auth.auth()
    
    // Apple Sign In
    fileprivate var currentNonce: String?
    
    fileprivate var signInView: UIView?
    
    // FirebaseAuth
    var isLogin: Bool {
        return currentFirebaseUser != nil
    }
    
    var currentFirebaseUser: FirebaseAuth.User? {
        return firebaseAuth.currentUser
    }
    
    var userUID: String? {
        return currentFirebaseUser?.uid
    }
    
    var appUser: User?
    
    // MARK: - Object Lifecycle
    private override init() {
        
    }
    
    func signOut() {
        do {
            try firebaseAuth.signOut()
        } catch {
            print("sign out error")
        }
        print(isLogin)
    }
}

// MARK: - Apple Sign In
extension AccountManager: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = signInView?.window else {
            fatalError()
        }
        return window
    }
    
    func signInWithApple(on view: UIView) {
        signInView = view
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
                print(self.isLogin)
            }
        }
    }
}
/*
// MARK: - Google Sign In
extension AccountManager {
    func signInWithGoogle(on view: UIView) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            
            if let error = error {
                print("GIDSignIn Fail")
                return
            }
            
            guard let authentication = user?.authentication,
                  let idToken = authentication.idToken else {
                      return
                  }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    let authError = error as NSError
                    if isMFAEnabled, authError.code == AuthErrorCode.secondFactorRequired.rawValue {
                        // The user is a multi-factor user. Second factor challenge is required.
                        guard let resolver = authError.userInfo[AuthErrorUserInfoMultiFactorResolverKey] as? MultiFactorResolver else {
                            return
                        }
                        var displayNameString = ""
                        for tmpFactorInfo in resolver.hints {
                            displayNameString += tmpFactorInfo.displayName ?? ""
                            displayNameString += " "
                        }
                        self.showTextInputPrompt(withMessage: "Select factor to sign in\n\(displayNameString)",
                                                 completionBlock: { userPressedOK, displayName in
                            var selectedHint: PhoneMultiFactorInfo?
                            for tmpFactorInfo in resolver.hints {
                                if displayName == tmpFactorInfo.displayName {
                                    selectedHint = tmpFactorInfo as? PhoneMultiFactorInfo
                                }
                            }
                            PhoneAuthProvider.provider().verifyPhoneNumber(with: selectedHint!,
                                                                           uiDelegate: nil,
                                                                           multiFactorSession: resolver.session) { verificationID, error in
                                if error != nil {
                                    print("Multi factor start sign in failed. Error: \(error.debugDescription)")
                                } else {
                                    self.showTextInputPrompt(
                                        withMessage: "Verification code for \(selectedHint?.displayName ?? "")",
                                        completionBlock: { userPressedOK, verificationCode in
                                            let credential: PhoneAuthCredential? = PhoneAuthProvider.provider()
                                                .credential(withVerificationID: verificationID!,
                                                            verificationCode: verificationCode!)
                                            let assertion: MultiFactorAssertion? = PhoneMultiFactorGenerator
                                                .assertion(with: credential!)
                                            resolver.resolveSignIn(with: assertion!) { authResult, error in
                                                if error != nil {
                                                    print("Multi factor finanlize sign in failed. Error: \(error.debugDescription)")
                                                } else {
                                                    self.navigationController?.popViewController(animated: true)
                                                }
                                            }
                                        }
                                    )
                                }
                            }
                        }
                        )
                    } else {
                        self.showMessagePrompt(error.localizedDescription)
                        return
                    }
                    // ...
                    return
                }
                // User is signed in
                // ...
            }
        }
    }
}
*/
