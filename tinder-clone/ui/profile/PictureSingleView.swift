//
//  PictureGridView.swift
//  tinder-clone
//
//  Created by Alejandro Piguave on 4/1/22.
//

import SwiftUI

struct PictureSingleView: View {
    let columns = [
        GridItem(.flexible()),
    ]
    @Binding var pictures: [ProfilePicture]
    @Binding var picturesChanged: Bool
    @Binding var droppedOutside: Bool
    @State var cells: [GridCell] = (0...0).map{  _ in GridCell() }

    let onAddedImageClick: (Int) -> ()
    let onAddImageClick: () -> ()
    
    init( pictures: Binding< [ProfilePicture] >,  picturesChanged: Binding<Bool> = .constant(false), droppedOutside: Binding<Bool> = .constant(false), onAddedImageClick: @escaping (Int) -> () = {value in}, onAddImageClick: @escaping () -> () = {}){
        self._pictures = pictures
        self._picturesChanged = picturesChanged
        self._droppedOutside = droppedOutside
        self.onAddImageClick = onAddImageClick
        self.onAddedImageClick = onAddedImageClick
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ReorderableForEach(droppedOutside: $droppedOutside, items: cells) { cell in
                getCellView(cell: cell)
            } moveAction: { from, to in
                picturesChanged = true
                cells.move(fromOffsets: from, toOffset: to)
            }
        }
        .onChange(of: pictures, perform: { newValue in
            cells = (0...0).map{ GridCell(picture: $0 < newValue.count ? newValue[$0] : nil)}
        })
    }
    
    func getCellView(cell: GridCell) -> some View {
        if let picture = cell.picture, let index = pictures.firstIndex(of: picture){
            return AnyView(AddedImageView(image: picture.picture, action:{
                onAddedImageClick(index)
            }))
        } else {
            return AnyView(AddImageView(action: onAddImageClick))
        }
    }
}

struct PictureSingleView_Previews: PreviewProvider {
    static var previews: some View {
        PictureSingleView(pictures: .constant([]), droppedOutside: .constant(false), onAddedImageClick: {index in}, onAddImageClick: {})
    }
}
