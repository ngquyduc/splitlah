//
//  GoogleSignInView.swift
//  splitlah
//
//  Created by Quý Đức on 6/3/25.
//

import SwiftUI
import GoogleSignInSwift

struct GoogleSignInView: View {
  @StateObject private var authViewModel = GoogleAuthViewModel()
  
  var body: some View {
    VStack {
      if authViewModel.user != nil {
        Text("Welcome, \(authViewModel.user?.profile?.name ?? "User")")
        Button("Sign Out") {
          authViewModel.signOut()
        }
        .padding()
      } else {
        GoogleSignInButton(action: authViewModel.signIn)
          .frame(width: 200, height: 50)
      }
      
      if let user = authViewModel.user {
        VStack {
          AsyncImage(url: user.profile?.imageURL(withDimension: 100))
            .clipShape(Circle())
          Text(user.profile?.name ?? "No Name")
          Text(user.profile?.email ?? "No Email")
        }
      }
    }
  }
}
