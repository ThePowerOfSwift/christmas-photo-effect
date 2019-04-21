//
//  StickerCollectionViewCell.swift
//  Pokefy
//
//  Created by Saad on 8/21/16.
//  Copyright © 2016 Saad. All rights reserved.
//

import UIKit

class StickerCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet var stickerButton: UIButton!
    
    @IBOutlet var lockImage: UIImageView!
    @IBOutlet var sticketImage: UIImageView!
    var sticker:Sticker? {
        didSet {
            if let sticker = sticker {
                sticketImage.image = UIImage(named: sticker.imageName)
                
                if(sticker.isLocked == false)
                {
                    lockImage.isHidden = true
                }
                else
                {
                
                    if let unlockedStickersArray : AnyObject? = UserDefaults.standard.object(forKey: "UnlockedStickers") as AnyObject?? {
                        unlockedStickers = unlockedStickersArray! as! [NSString]
                        if unlockedStickers.contains(sticker.imageName as NSString) {
                            lockImage.isHidden = true
                        }
                        
                    }
                }
                
                
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sticketImage.image = nil
        lockImage.isHidden = false
    }
    
    
    
}
