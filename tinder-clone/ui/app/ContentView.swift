//
//  ContentView.swift
//  tinder-clone
//
//  Created by Alejandro Piguave on 1/1/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var contentViewModel: ContentViewModel
    
    var body: some View {
        NavigationView{
            switch(contentViewModel.authState){
            case .loading:
                LoadingView()
            case .loggedUser:
                HomeView()
            case .loggedApprover:
                HomeApproverView()
            case .unlogged:
                LoginView()
            }
        }.onAppear(perform: {
            contentViewModel.updateAuthState()
        })
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
