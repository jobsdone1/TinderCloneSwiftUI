//
//  ChooseAccountTypeView.swift
//  Tinder 2
//
//  Created by Alejandro Piguave on 31/12/21.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FacebookLogin

struct ChooseAccountTypeView: View {
    @EnvironmentObject var contentViewModel: ContentViewModel
    @StateObject private var chooseAccountTypeModel = ChooseAccountTypeModel()
    @State private var emailAddress: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack{
            Spacer(minLength: 50)
            FilledLoadingView2()
                .scaledToFit()
                .frame(width: 150).padding(40).aspectRatio( contentMode: .fit)
            Spacer(minLength: 65)
            NavigationLink(destination: CreateProfileView(),
                           label: {
                VStack{Text("Approver")
                        .foregroundColor(.gray)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 20))
                    HStack{
                        Image("logo")
                            .resizable()
                            .foregroundGradient(colors: AppColor.appColors)
                            .frame(width: 20, height: 20)
                        Text("approver")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity).font(.system(size: 14)).multilineTextAlignment(.leading)
                    }}})
                .frame(maxWidth: 200, alignment: .leading)
                .padding(.top, 10)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.bottom, 10)
                .background(.white).cornerRadius(22)
            Spacer(minLength: 10)
            NavigationLink(destination: CreateProfileView(),
                           label: {
                VStack{Text("User")
                        .foregroundColor(.gray)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 20))
                    HStack{
                        Image(systemName: "person.crop.circle").resizable().foregroundGradient(colors: AppColor.appColors)
                            .frame(width: 20, height: 20)
                        Text("approval")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity).font(.system(size: 14)).multilineTextAlignment(.leading)
                    }}})
                .frame(maxWidth: 200, alignment: .leading)
                .padding(.top, 10)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.bottom, 10)
                .background(.white).cornerRadius(22)
            
            Spacer(minLength: 200)
            
        
        }
        .frame(maxWidth: .infinity)
        .background(LinearGradient(colors: AppColor.appColors, startPoint: .leading, endPoint: .trailing)).ignoresSafeArea()
    }
    private func submitInformation() {
    }
    private func submitInfo() {
    }
}

struct ChooseAccountTypeView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseAccountTypeView()
    }
}
