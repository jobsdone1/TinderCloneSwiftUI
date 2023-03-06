//
//  HomeView.swift
//  Tinder 2
//
//  Created by Alejandro Piguave on 31/12/21.
//

import SwiftUI

struct HomeApproverView: View {
    @StateObject private var homeViewModel = HomeApproverViewModel()
    @State private var showMatchView = false

    var body: some View {
        ZStack{
            VStack{
                if(homeViewModel.isLoading){
                    FilledLoadingView()
                } else {
                    SwipeApproverView(
                        profiles: $homeViewModel.userProfiles,
                        onSwiped: { userModel, hasLiked in
                            homeViewModel.swipeUser(user: userModel, hasLiked: hasLiked)
                        }
                    )
                }
            }

            .onAppear(perform: performOnAppear)
            .onReceive(homeViewModel.$lastMatchProfile, perform: { newValue in
                if newValue != nil{
                    withAnimation{
                        showMatchView.toggle()
                    }
                }
            })
            
            if(showMatchView){
                MatchView(matchName: homeViewModel.lastMatchProfile?.name ?? "", matchImage: homeViewModel.lastMatchProfile?.pictures.first ?? UIImage(), onSendMessageButtonClicked: {
                    withAnimation{
                        showMatchView.toggle()
                    }
                }, onKeepSwipingClicked: {
                    withAnimation{
                        showMatchView.toggle()
                    }
                })
            }
        }.navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading){
                NavigationLink(destination: EditProfileView(), label: {
                    Image(systemName: "person.crop.circle").foregroundGradient(colors: AppColor.appColors).frame(maxWidth: .infinity)
                })
            }

            ToolbarItem(placement: .principal){
                Image("logo").resizable().scaledToFit().frame(height: 35)
                        .foregroundGradient(colors: AppColor.appColors)
                        .frame(maxWidth: .infinity)
            }

        }
    }

    private func performOnAppear(){
        if homeViewModel.isFirstFetching{
            homeViewModel.fetchProfiles()
        }
    }
}



struct HomeApproverView_Previews: PreviewProvider {
    static var previews: some View {
        HomeApproverView()
    }
}
