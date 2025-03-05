//
//  GoogleAuthViewModel.swift
//  splitlah
//
//  Created by Quý Đức on 6/3/25.
//

import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth

class GoogleAuthViewModel: ObservableObject {
  @Published var user: GIDGoogleUser? = nil
  
  func signIn() {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let rootVC = windowScene.windows.first?.rootViewController else {
      return
    }
    
    GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { signInResult, error in
      guard let result = signInResult, error == nil else {
        print("Google Sign-In failed: \(error?.localizedDescription ?? "Unknown error")")
        return
      }
      
      self.user = result.user
      self.authenticateWithFirebase(user: result.user)
    }
  }
  
  private func authenticateWithFirebase(user: GIDGoogleUser) {
    guard let idToken = user.idToken?.tokenString else { return }
    let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
    
    Auth.auth().signIn(with: credential) { authResult, error in
      if let error = error {
        print("Firebase authentication failed: \(error.localizedDescription)")
        return
      }
      print("User signed in with Firebase: \(authResult?.user.email ?? "No email")")
    }
  }
  
  func signOut() {
    GIDSignIn.sharedInstance.signOut()
    try? Auth.auth().signOut()
    self.user = nil
  }
}
