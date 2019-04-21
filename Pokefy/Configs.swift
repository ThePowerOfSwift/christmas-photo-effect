//
//  Configs.swift
//  Pokefy
//
//  Created by Saad on 8/9/16.
//  Copyright © 2016 Saad. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

// Replace the red string below with the name you'll give to your own version of this app
var APP_NAME = "Christmas Photo Effect"
var APP_STORE_LINK = "https://itunes.apple.com/us/app/christmas-photo-effect/id1184256995"
var DEVELOPER_PAGE_LINK = "https://itunes.apple.com/us/developer/ishtiaque-ahmed/id1141804263"
//TEST
//var ADMOB_AD_UNIT_ID_BANNER = "ca-app-pub-3940256099942544/2934735716"
//var ADMOB_AD_UNIT_ID_INTERSTATIAL = "ca-app-pub-3940256099942544/4411468910"

//LIVE
var ADMOB_AD_UNIT_ID_BANNER = "ca-app-pub-9772389634309522/2420544409"
var ADMOB_AD_UNIT_ID_INTERSTATIAL = "ca-app-pub-9772389634309522/6973228004"



var interstitialAd: GADInterstitial?

// You can edit these strings as you wish, they are responsible for the sharing section on twitter and Facebook
var SHARING_SUBJECT = "My \(APP_NAME) Picture!"
var SHARING_MESSAGE = "Hi there, check this picture out, I've made it with #\(APP_NAME)"

var editedImage: UIImage?
var takenImage: UIImage?
var croppedImage: UIImage?



var collageFrameNr = 0
var imageTAG = -1

// For saving data locally
var DEFAULTS = UserDefaults.standard

// Load BOOLs
var saveImageToLibrary = DEFAULTS.bool(forKey: "saveImageToLibrary")

// HUD View
let hudView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
let indicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
extension UIViewController {
    func showHUD() {
        hudView.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
        hudView.backgroundColor = UIColor.darkGray
        hudView.alpha = 0.9
        hudView.layer.cornerRadius = hudView.bounds.size.width/2
        
        indicatorView.center = CGPoint(x: hudView.frame.size.width/2, y: hudView.frame.size.height/2)
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        hudView.addSubview(indicatorView)
        indicatorView.startAnimating()
        view.addSubview(hudView)
    }
    
    func hideHUD() { hudView.removeFromSuperview() }
    
    func simpleAlert(_ mess:String) {
        let alert = UIAlertController(title: APP_NAME, message: mess, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}

// DO NOT edit these variables, they are responsible for showing/hiding tools in the Image Editor Controller
var FRAMESTOOL_NAME = "Frames"
var STICKERSTOOL_NAME = "Stickers"
var FILTERSTOOL_NAME = "Filters"
var TEXTURESTOOL_NAME = "Textures"
var ADJUSTMENTTOOL_NAME = "Adjustment"


var stickersImageArray = [String]()

var stickersImagePosition = [StickerPosition]()
var stickerType: String?
var stickerPack: Int?


var screenWidth, screenHeight: CGFloat!
// Array of Colors (check settings below)
let colorsList = [
    red, orange, yellow, lightGreen, mint, aqua, blueJeans, lavander,
    darkPurple, pink, darkRed,  paleWhite, lightGray, mediumGray, darkGray
]


// DEFINE PALETTE OF COLORS  (you can edit the RGBA values of these colors if you want, just leave "255.0" the wauy it is, edit only the other values.
// Alpha value goes from 0.0 to 1.0 - RGB values go from 0.0 to 255.0
var red = UIColor(red: 237.0/255.0, green: 85.0/255.0, blue: 100.0/255.0, alpha: 1.0)
var orange = UIColor(red: 250.0/255.0, green: 110.0/255.0, blue: 82.0/255.0, alpha: 1.0)
var yellow = UIColor(red: 255.0/255.0, green: 207.0/255.0, blue: 85.0/255.0, alpha: 1.0)
var lightGreen = UIColor(red: 160.0/255.0, green: 212.0/255.0, blue: 104.0/255.0, alpha: 1.0)
var mint = UIColor(red: 72.0/255.0, green: 207.0/255.0, blue: 174.0/255.0, alpha: 1.0)
var aqua = UIColor(red: 79.0/255.0, green: 192.0/255.0, blue: 232.0/255.0, alpha: 1.0)
var blueJeans = UIColor(red: 93.0/255.0, green: 155.0/255.0, blue: 236.0/255.0, alpha: 1.0)
var lavander = UIColor(red: 172.0/255.0, green: 146.0/255.0, blue: 237.0/255.0, alpha: 1.0)
var darkPurple = UIColor(red: 150.0/255.0, green: 123.0/255.0, blue: 220.0/255.0, alpha: 1.0)
var pink = UIColor(red: 236.0/255.0, green: 136.0/255.0, blue: 192.0/255.0, alpha: 1.0)
var darkRed = UIColor(red: 218.0/255.0, green: 69.0/255.0, blue: 83.0/255.0, alpha: 1.0)
var paleWhite = UIColor(red: 246.0/255.0, green: 247.0/255.0, blue: 251.0/255.0, alpha: 1.0)
var lightGray = UIColor(red: 230.0/255.0, green: 233.0/255.0, blue: 238.0/255.0, alpha: 1.0)
var mediumGray = UIColor(red: 204.0/255.0, green: 208.0/255.0, blue: 217.0/255.0, alpha: 1.0)
var darkGray = UIColor(red: 67.0/255.0, green: 74.0/255.0, blue: 84.0/255.0, alpha: 1.0)
//------------------------------------------------------------------------------------------------------------------

var STICKER_UNLOCK_COIN_AMOUNT = 10
var unlockedStickers = [NSString]()

