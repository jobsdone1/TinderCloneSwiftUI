//
//  SwipeView.swift
//  tinder-clone
//
//  Created by Alejandro Piguave on 1/1/22.
//

import SwiftUI


struct SwipeApproverView: View {
    @Binding var profiles: [UserModel]
    @State var swipeAction: SwipeAction = .doNothing
    //Bool: true if it was a like (swipe to the right
    var onSwiped: (UserModel, Bool) -> ()
    
    var body: some View {
        VStack{
            Spacer()
            VStack{
                ZStack{
                    Text("no-more-profiles").font(.title3).fontWeight(.medium).foregroundColor(Color(UIColor.systemGray)).multilineTextAlignment(.center)
                    ForEach(profiles.indices, id: \.self){ index  in
                        let model: UserModel = profiles[index]
                        
                        if(index == profiles.count - 1){
                            SwipeableCardView(model: model, swipeAction: $swipeAction, onSwiped: performSwipe)
                        } else if(index == profiles.count - 2){
                            SwipeCardView(model: model)
                        }
                    }
                }
            }.padding()
            Spacer()
            HStack{
                Spacer()
                GradientOutlineButton(action:{swipeAction = .swipeLeft}, iconName: "multiply", colors: AppColor.dislikeColors)
                Spacer()
                GradientOutlineButton(action: {swipeAction = .swipeRight}, iconName: "heart", colors: AppColor.likeColors)
                Spacer()
            }.padding(.bottom)
        }
    }
    
    private func performSwipe(userProfile: UserModel, hasLiked: Bool){
        removeTopItem()
        onSwiped(userProfile, hasLiked)
    }
    
    private func removeTopItem(){
        profiles.removeLast()
    }
    
    
}




struct SwipeApproverView_Previews: PreviewProvider {
    @State static private var profiles: [UserModel] = [
        UserModel(userId: "defdwsfewfes", name: "Michael Jackson", age: 50, pictures: [UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!]),
        UserModel(userId: "defdwsfewfes", name: "Michael Jackson", age: 50, pictures: [UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!])
    ]
    static var previews: some View {
        SwipeApproverView(profiles: $profiles, onSwiped: {_,_ in})
    }
}
