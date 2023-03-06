//
//  CreateProfileViewModel.swift
//  tinder-clone
//
//  Created by Alejandro Piguave on 27/10/22.
//

import Foundation

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import GoogleSignIn
import SwiftUI
import FacebookLogin
import FacebookCore

struct ApproverData{
    let name: String
    let birthDate: Date
    let bio: String
    let isMale: Bool
    let orientation: Orientation
    let pictures: [UIImage]
}

class CreateApproverViewModel: NSObject, ObservableObject {
    @Published private (set) var signUpError: String? = nil
    @Published private (set) var isLoading: Bool = false
    @Published private (set) var isSignUpComplete: Bool = false
    
    private let firestoreRepository: FirestoreRepository = FirestoreRepository.shared
    private let storageRepository: StorageRepository = StorageRepository.shared
    
    func signUp(approverData: ApproverData, controller: UIViewController) {
        self.isLoading = true
        Task{
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                publishError(message: "Default Firebase app does not exist.")
                return
            }

            // Create Google Sign In configuration object.
            let configuration = GIDConfiguration(clientID: clientID)

            do{
                // Start the sign in flow!
                let user = try await signInWithGoogle(with: configuration, presenting: controller)

                guard let userEmail = user.profile?.email else {
                    publishError(message: "Empty e-mail address")
                    return
                }
                guard try await isNewUser(email: userEmail) else {
                    publishError(message: "User already exists.")
                    return
                }

                guard let idToken = user.authentication.idToken else {
                    publishError(message: "No ID token found.")
                    return
                }

                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.authentication.accessToken)

                try await Auth.auth().signIn(with: credential)
                //Successfully logged in

                let fileNames = try await storageRepository.uploadUserPictures(approverData.pictures)

                try await firestoreRepository.createApproverProfile(name: approverData.name, pictures: fileNames)

                DispatchQueue.main.async {
                    self.isLoading = false
                    self.isSignUpComplete = true
                }
                }catch{
                publishError(message: error.localizedDescription)
                return
            }
        }
    }
    
    func signUp_Facebook(approverData: ApproverData, controller: UIViewController) {
        self.isLoading = true
        Task{

            
            do{             // Start the sign in flow!
                let loginManager = LoginManager()
                loginManager.logIn(permissions: ["public_profile", "email"])
            
                
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                
                try await Auth.auth().signIn(with: credential)
                
                let fileNames = try await storageRepository.uploadUserPictures(approverData.pictures)
                
                try await firestoreRepository.createUserProfile(name: approverData.name, birthDate: approverData.birthDate, bio: approverData.bio, isMale: approverData.isMale, orientation: approverData.orientation, pictures: fileNames)
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.isSignUpComplete = true
                }
            }catch{
                publishError(message: error.localizedDescription)
                return
            }
        }
    }

    private func publishError(message: String) {
        DispatchQueue.main.async {
            self.signUpError = message
            self.isLoading = false
        }
    }
    private func isNewUser(email: String) async throws-> Bool{
        let methods = try await Auth.auth().fetchSignInMethods(forEmail: email)
        return methods.isEmpty
    }
    
    
    func signInWithGoogle(with configuration: GIDConfiguration, presenting controller: UIViewController) async throws -> GIDGoogleUser{
        return try await withCheckedThrowingContinuation{ continuation in
            GIDSignIn.sharedInstance.signIn(with: configuration, presenting: controller) { user, error in
                if let error = error {
                    continuation.resume(throwing: error)
                }
                continuation.resume(returning: user!)
            }
        }
    }

}
