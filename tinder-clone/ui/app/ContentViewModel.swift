//
//  GoogleSignInViewModel.swift
//  Tinder 2
//
//  Created by Alejandro Piguave on 1/1/22.
//

import Foundation

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import GoogleSignIn
import SwiftUI

enum AuthState{
    case loading, loggedApprover, loggedUser, unlogged
}

class ContentViewModel: NSObject, ObservableObject {
    @Published var authState: AuthState = .loading
    private var userId: String? { Auth.auth().currentUser?.uid }
    private let db = Firestore.firestore()

    func updateAuthState(){
        
        if (Auth.auth().currentUser != nil) {
            let docRef = db.collection("users").document(userId!)
            docRef.getDocument { (document, error) in
                print(document!.exists)
                if (document?.exists ?? true) {
                    self.authState = .loggedUser
                }
                else{
                    self.authState = .loggedApprover
                }
            }
            
        }
        else {
            self.authState = .unlogged
        }
    }
    
    func signOut(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.authState = .unlogged
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}
