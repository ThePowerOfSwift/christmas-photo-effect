//
//  Sticker.swift
//  Pokefy
//
//  Created by Saad on 8/21/16.
//  Copyright © 2016 Saad. All rights reserved.
//


import UIKit




class Sticker {
    
    var imageName: String
    var type: String
    var isLocked: Bool
    
    init(imageName:String, type: String, isLocked: Bool) {
        self.imageName = imageName
        self.type = type
        self.isLocked = isLocked
        
    }
    
    convenience init(copying sticker: Sticker) {
        self.init(imageName: sticker.imageName, type: sticker.type, isLocked: sticker.isLocked)
    }
    
}


class StickerPosition{
    var frame: CGRect
    var centrePoint: CGPoint
    
    init(frame:CGRect, centrePoint: CGPoint){
        self.frame = frame
        self.centrePoint = centrePoint
    }

}

class  StickerFrame{
    var mainView: UIView
    var stickerImage: UIImageView
    var removeButton: UIButton
    var rotateButton: UIButton
    var resizeButton: UIButton
    var flipButton: UIButton

    
    init(mainView:UIView, stickerImage: UIImageView, removeButton: UIButton,rotateButton: UIButton, resizeButton: UIButton, flipButton: UIButton) {
        self.mainView = mainView
        self.stickerImage = stickerImage
        self.removeButton = removeButton
        self.rotateButton = rotateButton
        self.resizeButton = resizeButton
        self.flipButton = flipButton
        
    }
}
