//
//  LoginView.swift
//  Tinder 2
//
//  Created by Alejandro Piguave on 31/12/21.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FacebookLogin

struct LoginView: View {
    @EnvironmentObject var contentViewModel: ContentViewModel
    @StateObject private var loginViewModel = LoginViewModel()
    @State private var emailAddress: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack{
            Spacer(minLength: 100)
            Image("logo").resizable()
                .scaledToFit()
                .frame(width: 150).padding(40).aspectRatio( contentMode: .fit)
        
            Button{
                Task {
                    await loginViewModel.signIn(controller:getRootViewController())
                    contentViewModel.updateAuthState()
                }
            } label: {
                HStack{
                    Image("icons8-google-48")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("Sign in with Google")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: 200, alignment: .leading)
                .padding(.top, 10)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.bottom, 10)
                
            }.background(.white).cornerRadius(22)
            
            Button{
                Task {
                    await loginViewModel.signIn_Facebook(controller:getRootViewController())
                    contentViewModel.updateAuthState()
                }
            } label: {
                HStack{
                    Image("facebook-logo")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("Sign in with Facebook")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: 200, alignment: .leading)
                .padding(.top, 10)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.bottom, 10)
                
            }.background(.white).cornerRadius(22)
            
            Spacer(minLength: 80)
            VStack{
                TextField("", text: $emailAddress)              .frame(maxWidth: 200, alignment: .leading)
                    .placeholder(when: emailAddress == "") {
                        Text("enter-your-email").foregroundColor(.gray)
                    }
                    .padding(.top, 10)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.bottom, 10)
                    .foregroundColor(.gray)
                    .textFieldStyle(.plain)
                    .textContentType(.emailAddress)
                
                
                    .background(.white).cornerRadius(22)
                
                SecureField("", text: $password)              .frame(maxWidth: 200, alignment: .leading)
                    .padding(.top, 10)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.bottom, 10)
                    .foregroundColor(.gray)
                    .placeholder(when: password == "") {
                        Text("enter-your-password").foregroundColor(.gray)
                    }
                    .background(.white).cornerRadius(22)
                
                Button {
                    submitInfo()
                } label: {
                    Text("I forgot my password") .font(.system(size: 18)).foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding()
                
                Button {
                    submitInformation()
                } label: {
                    HStack {
                        Image("mail")
                            .resizable()
                            .frame(width: 24, height: 24)
                        
                        Text("Sign in with email")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                
                
            }
            Spacer(minLength: 30)
            
            NavigationLink(destination: ChooseAccountTypeView(), label: {
                Text("Create account")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding(.top, 30)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.bottom, 30)
                
            })
        }
        .frame(maxWidth: .infinity)
        .background(LinearGradient(colors: AppColor.appColors, startPoint: .leading, endPoint: .trailing)).ignoresSafeArea()
    }
    private func submitInformation() {
    }
    private func submitInfo() {
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

extension View{
    func getRootViewController() -> UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else{
            return .init()
        }
        
        
        
        return root
    }
    
    func placeholder<Content: View>(
            when shouldShow: Bool,
            alignment: Alignment = .leading,
            @ViewBuilder placeholder: () -> Content) -> some View {

            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    
    
}
