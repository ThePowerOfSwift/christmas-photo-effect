//
//  Helper.swift
//  Hell Sticker
//
//  Created by Saad on 11/1/16.
//  Copyright © 2016 Saad. All rights reserved.
//

import Foundation
import UIKit

class Helper{

    
   static func changeMultiplier(_ constraint: NSLayoutConstraint, multiplier: CGFloat) {
        
        let newConstraint = NSLayoutConstraint(
            item: constraint.firstItem,
            attribute: constraint.firstAttribute,
            relatedBy: constraint.relation,
            toItem: constraint.secondItem,
            attribute: constraint.secondAttribute,
            multiplier: multiplier,
            constant: constraint.constant
        )
        
        newConstraint.priority = constraint.priority
        
        NSLayoutConstraint.deactivate([constraint])
        NSLayoutConstraint.activate([newConstraint])
     
        //return newConstraint
        
    }
    
    
}
