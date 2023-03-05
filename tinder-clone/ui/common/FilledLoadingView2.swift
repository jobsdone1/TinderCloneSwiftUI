//
//  FilledLoadingView.swift
//  tinder-clone
//
//  Created by Alejandro Piguave on 18/1/22.
//

import SwiftUI

struct FilledLoadingView2: View {
    @State private var isAnimating = false
    var body: some View {
        Image("logo").resizable()
            .scaledToFit()
            .frame(width: isAnimating ? 200 : 145)
            .foregroundGradient(colors: AppColor.grayColors)
            .onAppear {
                DispatchQueue.main.async {
                    withAnimation(Animation.easeOut(duration: 1).repeatForever()){
                        self.isAnimating = true
                    }
                }
            }
    }
}

struct FilledLoadingView2_Previews: PreviewProvider {
    static var previews: some View {
        FilledLoadingView2()
    }
}
