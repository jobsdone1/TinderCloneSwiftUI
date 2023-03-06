//
//  HomeView.swift
//  Tinder 2
//
//  Created by Alejandro Piguave on 31/12/21.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var homeViewModel = HomeViewModel()
    @State private var showMatchView = false
    @StateObject var locationDataManager = LocationDataManager()
    
    var body: some View {
        ZStack{
            VStack{
                switch locationDataManager.locationManager.authorizationStatus {
                case .authorizedWhenInUse:       if(homeViewModel.isLoading){
                    FilledLoadingView()}
                else{
                    SwipeView(
                        profiles: $homeViewModel.userProfiles,
                        onSwiped: { userModel, hasLiked in
                            homeViewModel.swipeUser(user: userModel, hasLiked: hasLiked)
                        }
                    )
                }
                                
                            case .restricted, .denied:  // Location services currently unavailable.
                                // Insert code here of what should happen when Location services are NOT authorized
                                Text("Current location data was restricted or denied.")
                            case .notDetermined:        // Authorization not determined yet.
                                Text("Finding your location...")
                                ProgressView()
                            default:
                                ProgressView()
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
                    Image(systemName: "person.crop.circle").resizable().scaledToFit().frame(height: 35).foregroundGradient(colors: AppColor.appColors).frame(maxWidth: .infinity).frame(height: 50)
                })
            }

            ToolbarItem(placement: .principal){
                Image("logo").resizable().scaledToFit().frame(height: 35)
                        .foregroundGradient(colors: AppColor.appColors)
                        .frame(maxWidth: .infinity)
            }
            
            ToolbarItem(placement: .automatic){
                NavigationLink(destination: MatchListView(), label: {
                    Image(systemName: "plus.circle.fill").foregroundGradient(colors: AppColor.appColors).frame(maxWidth: .infinity).frame(height: 35)
                })
            }

            ToolbarItem(placement: .navigationBarTrailing){
                NavigationLink(destination: MatchListView(), label: {
                    Image(systemName: "bubble.left.and.bubble.right.fill").resizable().scaledToFit().frame(height: 35).foregroundGradient(colors: AppColor.appColors).frame(maxWidth: .infinity)
                })
            }
        }
    }

    private func performOnAppear(){
        if homeViewModel.isFirstFetching{
            homeViewModel.fetchProfiles()
        }
    }
}


//Match view
struct MatchView: View {
    let matchName: String
    let matchImage: UIImage
    let onSendMessageButtonClicked: () -> ()
    let onKeepSwipingClicked: () -> ()
    var body: some View {
        VStack{
            Spacer()
            Image("its-a-match").resizable().scaledToFit()
            Text(String(format: NSLocalizedString("its-a-match-text", comment: "Text for when two users match"), matchName)).font(.subheadline).fontWeight(.bold).foregroundColor(.white).padding()
            Image(uiImage: matchImage)
                .centerCropped().aspectRatio(0.7, contentMode: .fit)
                .cornerRadius(10)
            Button(action: onSendMessageButtonClicked, label: {
                Text("send-message").padding([.leading,.trailing], 25).padding([.top, .bottom], 15)
            }).background(.white).cornerRadius(25).padding(.top)
            
            Button(action: onKeepSwipingClicked, label: {
                Text("keep-swiping").foregroundColor(.white)
            }).padding(12)
            Spacer()
        }
        .padding()
        .background(LinearGradient(colors: AppColor.appColors.map{$0.opacity(0.8)}, startPoint: .leading, endPoint: .trailing))
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
