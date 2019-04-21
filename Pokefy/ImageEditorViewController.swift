//
//  ImageEditorViewController.swift
//  Pokefy
//
//  Created by Saad on 8/16/16.
//  Copyright © 2016 Saad. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ImageEditorViewController: UIViewController, GADInterstitialDelegate {

    @IBOutlet var facemaskButton: UIButton!
    @IBOutlet var specialfxButton: UIButton!
    @IBOutlet var filtersButton: UIButton!
    @IBOutlet var emojiButton: UIButton!
    @IBOutlet var stickerButton: UIButton!
    @IBOutlet var coinCountLabel: UILabel!
    @IBOutlet var containerWidthConstraint: NSLayoutConstraint!
    @IBOutlet var stickerCollectionView: UICollectionView!
    @IBOutlet var containerHolderView: UIView!
    @IBOutlet var originalImage: UIImageView!
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var imageForFilters: UIImageView!
    @IBOutlet var filtersScrollView: UIScrollView!
    @IBOutlet var filtersToolView: UIView!
    @IBOutlet var stickersToolView: UIView!
    
    @IBOutlet var watermarkImg: UIImageView!
    var sticker: Sticker?
    var screenWidth, screenHeight: CGFloat!
    var old_distance: CGFloat = 0.0
    
    var stickerDataSource = StickersDataSource()
    var stickerFrames = [StickerFrame]()
    
    var totalCoins: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interstitialAd = createAndLoadInterstitial()
        
       
        screenWidth = UIScreen.main.bounds.size.width
        screenHeight = UIScreen.main.bounds.size.height
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            Helper.changeMultiplier(containerWidthConstraint, multiplier: 0.8)
        }
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // init_ad()
        watermarkImg.isHidden = true
        
        
        // Get the cropped image previously made
        originalImage.image = croppedImage
        
        // Set the image for filters as the Original image
        imageForFilters.image = originalImage.image
        
        // Place Tool Views outside the screen, on the bottom
        
        
        filtersToolView.isHidden = true
        
        stickerButton.setBackgroundImage(UIImage(named: "stickerh"), for: UIControlState())
        
        setupFiltersTool()
        
        let singletapGeststickerImage = UITapGestureRecognizer()
        singletapGeststickerImage.addTarget(self, action: #selector(clearScreenView(_:)))
        singletapGeststickerImage.numberOfTapsRequired = 1
        containerView.addGestureRecognizer(singletapGeststickerImage)
        
        totalCoins = UserDefaults.standard.integer(forKey: "CoinCount")
        coinCountLabel.text = String(totalCoins)
        
    }
    
    func clearScreenView(_ sender: UITapGestureRecognizer){
        hideControls()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        let hasPurchased = UserDefaults.standard.bool(forKey: "RemoveWatermarkAd")
        
        if !hasPurchased {
            let randomNo = Int(arc4random() % 3)
            
            if (randomNo == 3)
            {
                showInterstitialAd()
            }
            
        }
        
        
    }

    func init_ad() {
       // let hasPurchased = UserDefaults.standard.bool(forKey: "RemoveWatermarkAd")
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showInterstitialAd() {
        
        if interstitialAd != nil {
            if interstitialAd!.isReady {
                
                interstitialAd?.present(fromRootViewController: self)
                print("Ad presented")
            } else {
                print("Ad was not ready for presentation")
            }
        }
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let request = GADRequest()
        let interstitial = GADInterstitial(adUnitID: ADMOB_AD_UNIT_ID_INTERSTATIAL)
        interstitial.delegate = self
        interstitial.load(request)
        return interstitial
    }
    
    var stickerButt: UIButton?
    var stickerImage: UIImageView?
    var stickerView: UIView?
    var resizezButton: UIButton?
    
    
    
    
    
    func stickerButtTapped(sticker: Sticker) {
        hideControls()
        
        
        let nib = UINib(nibName: "StickerView", bundle: nil)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        nibView.clipsToBounds = true
        
        nibView.frame = CGRect(x: 20, y: 20, width: 180, height: 180)
        //nibView.tag = sender.tag
        containerView.addSubview(nibView)

        
        let nibSubviews = nibView.subviews
        
        let stickerImageView = nibSubviews[0] as! UIImageView
        stickerImageView.backgroundColor = UIColor.clear
        stickerImageView.image = UIImage(named: (sticker.imageName))
        stickerImageView.isUserInteractionEnabled = true
        stickerImageView.isMultipleTouchEnabled = true
        stickerImageView.layer.borderWidth = 2
        stickerImageView.layer.borderColor = UIColor.gray.cgColor
        
        let mirrorButton = nibSubviews[4] as! UIButton
        mirrorButton.addTarget(self, action: #selector(mirrorImage(_:)), for: .touchUpInside)
        
        let cancelButton = nibSubviews[2] as! UIButton
        cancelButton.addTarget(self, action: #selector(removeSticker(_:)), for: .touchUpInside)
        
        // Add PAN GESTURES to the sticker
        let panGestSticker = UIPanGestureRecognizer()
        panGestSticker.addTarget(self, action: #selector(moveSticker(_:)))
        nibView.addGestureRecognizer(panGestSticker)
        
        let resizeButton = nibSubviews[1] as! UIButton
        
        let panGestResizeButton = UIPanGestureRecognizer()
        panGestResizeButton.addTarget(self, action: #selector(zoomStickerButton(_:)))
        resizeButton.addGestureRecognizer(panGestResizeButton)
        
        let rotateButton = nibSubviews[3] as! UIButton
        
        
        let panGestRotateButton = UIPanGestureRecognizer()
        panGestRotateButton.addTarget(self, action: #selector(rotateStickerButton(_:)))
        rotateButton.addGestureRecognizer(panGestRotateButton)
        
        
        
        
        let singletapGeststicker = UITapGestureRecognizer()
        singletapGeststicker.addTarget(self, action: #selector(bringStickerToFront(_:)))
        singletapGeststicker.numberOfTapsRequired = 1
        nibView.addGestureRecognizer(singletapGeststicker)
        
        let stickerFrame = StickerFrame(mainView:nibView, stickerImage: stickerImageView, removeButton: cancelButton,rotateButton: rotateButton, resizeButton: resizeButton, flipButton: mirrorButton)
        
        stickerFrames.append(stickerFrame)
        
        
        
        
        
    }
    
    func mirrorImage(_ sender: UIButton) {
        let mainView = sender.superview
        let imageView = mainView?.subviews[0] as! UIImageView
        if (imageView.transform.isIdentity) {
            imageView.transform = CGAffineTransform(scaleX: -1, y: 1)
            
        } else {
            imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
    }
    
    
    // DELETE STICKER (with a double-tap on a sticker
    func removeSticker(_ sender: UIButton) {
        sender.superview?.removeFromSuperview()

    }
    
    // MOVE STICKER
    func moveSticker(_ recognizer: UIPanGestureRecognizer) {
        
        
        let translation = recognizer.translation(in: recognizer.view)
        
        if let view = recognizer.view {
            view.transform = view.transform.translatedBy(x: translation.x, y: translation.y)
        }
        
        recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
    }

    
    // ZOOM STICKER
    func zoomStickerButton(_ sender: UIPanGestureRecognizer) {
        let parentview = sender.view?.superview
        let currentPoint = sender.location(in: sender.view)
        let width = parentview?.frame.size.width
        
        let scale = (width! + currentPoint.x) / width!
        
        if scale > 0 {
            parentview?.transform = (parentview?.transform.scaledBy(x: scale, y: scale))!
        }
        
    
    }
    
    // ROTATE STICKER
    func rotateStickerButton(_ sender: UIPanGestureRecognizer) {
        let parentview = sender.view?.superview
        
        
        if sender.state == .began || sender.state == .changed{
            let vel = sender.velocity(in: sender.view)
            if vel.x > 0{
                
                parentview?.transform = (parentview?.transform)!.rotated(by: CGFloat(M_PI) / 80.0)
                sender.setTranslation(CGPoint.zero, in: sender.view)
            }
            else {
                parentview?.transform = (parentview?.transform)!.rotated(by: -(CGFloat(M_PI) / 80.0))
                sender.setTranslation(CGPoint.zero, in: sender.view)
            }
        }
        
    }
    
    func bringStickerToFront(_ sender: UITapGestureRecognizer){
        hideControls()
        let subViews = sender.view?.subviews
        subViews?[0].layer.borderWidth = 2
        subViews?[1].isHidden = false
        subViews?[2].isHidden = false
        subViews?[3].isHidden = false
        subViews?[4].isHidden = false
        containerView.bringSubview(toFront: sender.view!)
    }
    
    func hideControls() {
        
        for i in 0..<stickerFrames.count{
            stickerFrames[i].flipButton.isHidden = true
            stickerFrames[i].resizeButton.isHidden = true
            stickerFrames[i].rotateButton.isHidden = true
            stickerFrames[i].removeButton.isHidden = true
            stickerFrames[i].stickerImage.layer.borderWidth = 0
        
        }
    }
    
    func storeAdjustedPosition(_ frame: CGRect, centre: CGPoint, index: Int)  {
        stickersImagePosition[index].frame = frame
        stickersImagePosition[index].centrePoint = centre
    }

    var filterButt: UIButton?
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        normalize_button()
        showToolView(FILTERSTOOL_NAME)
        hideToolView(STICKERSTOOL_NAME)
        //view.bringSubviewToFront(filtersToolView)
        filtersButton.setBackgroundImage(UIImage(named: "filtersh"), for: UIControlState())
    }
    
    @IBOutlet var scrollFrameView: UIView!
    // Filters List & Names ------------------------------
    let filtersList = [
        "CIVignette",              //0
        "CIVignette",              //1
        "CIPhotoEffectInstant",    //2
        "CIPhotoEffectProcess",    //3
        "CIPhotoEffectTransfer",   //4
        "CISepiaTone",             //5
        "CIPhotoEffectChrome",     //6
        "CIPhotoEffectFade",       //7
        "CIPhotoEffectTonal",      //8
        "CIPhotoEffectNoir",       //9
        "CIDotScreen",             //10
        "CIColorPosterize",        //11
        "CISharpenLuminance",      //12
        "CIGammaAdjust",           //13
        
        // Add here new CIFilters...
    ]
    
    /*-----------------------------------------------*/
    
    
    func setupFiltersTool() {
        //print("Height of Frame: \(scrollFrameView.frame.size.height)")
        // Variables for setting the Buttons
        var xCoord: CGFloat = 0
        let yCoord: CGFloat = 3
        let cellHeight = scrollFrameView.frame.size.height * 0.5
        let buttonWidth:CGFloat = cellHeight
        let buttonHeight: CGFloat = cellHeight
        let gapBetweenButtons: CGFloat = 10
        
       
        
        // Loop for creating buttons =========================
        var itemCount = 0
        for i in 0..<filtersList.count {
            itemCount = i
            
            // Create a Button for each Texture ==========
            filterButt = UIButton(type: UIButtonType.custom)
            filterButt?.frame = CGRect(x: xCoord, y: yCoord, width: buttonWidth, height: buttonHeight)
            filterButt?.tag = itemCount
            filterButt?.showsTouchWhenHighlighted = true
            filterButt?.addTarget(self, action: #selector(filterButtTapped(_:)), for: UIControlEvents.touchUpInside)
            //filterButt?.layer.cornerRadius = filterButt!.bounds.width/2
            filterButt?.clipsToBounds = true
            
            
            /*=================================================
             ================ FILTER SETTINGS ==================*/
            
            let ciContext = CIContext(options: nil)
            let coreImage = CIImage(image: originalImage.image!)
            let filter = CIFilter(name: "\(filtersList[itemCount])" )
            filter!.setDefaults()
            
            
            switch itemCount {
            case 0: // NO filter (don't edit this filter)
                break
                
            case 1: // Vignette
                filter!.setValue(3.0, forKey: kCIInputRadiusKey)
                filter!.setValue(4.0, forKey: kCIInputIntensityKey)
                break
                
            case 11: //Poster
                filter!.setValue(6.0, forKey: "inputLevels")
                break
                
            case 12: // Sharpen
                filter!.setValue(0.9, forKey: kCIInputSharpnessKey)
                break
                
            case 13: // Gamma Adjust
                filter!.setValue(3, forKey: "inputPower")
                break
                
                
                /* You can ddd new filters here,
                 Check Core Image Filter Reference here: https://developer.apple.com/library/mac/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html
                 */
                
                
            default: break
            } // END FILTER SETTINGS =========================================
            
            
            
            filter!.setValue(coreImage, forKey: kCIInputImageKey)
            let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
            let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
            let imageForButton = UIImage(cgImage: filteredImageRef!);
            
            // Assign filtered image to the button
            filterButt!.setBackgroundImage(imageForButton, for: UIControlState())
            
            // Add Buttons based on xCood
            xCoord +=  buttonWidth + gapBetweenButtons
            filtersScrollView.addSubview(filterButt!)
        } // END LOOP =========================================
        
        
        // Place Buttons into the ScrollView =====
        filtersScrollView.contentSize = CGSize( width: (buttonWidth+gapBetweenButtons) * CGFloat(itemCount), height: yCoord)
    }
    
    func filterButtTapped(_ button: UIButton) {
        
        // Set the filteredImage
        imageForFilters.image = button.backgroundImage(for: UIControlState())
        
        // NO Filter (go back to Original image)
        if button.tag == 0 {   imageForFilters.image = originalImage.image  }
    }
    
    @IBAction func closeFiltersButton(_ sender: UIButton) {
        if (sender.tag == 2){
            hideToolView(FILTERSTOOL_NAME)
        }
        else if(sender.tag == 1)
        {
            hideToolView(STICKERSTOOL_NAME)
        }
        
    }
    
    
    
    
    // ANIMATION TO SHOW/HIDE TOOL VIEWS ================================
    func showToolView(_ toolName:String) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
            if toolName == FILTERSTOOL_NAME { self.filtersToolView.isHidden = false }
            if toolName == STICKERSTOOL_NAME { self.stickersToolView.isHidden = false }
            }, completion: { (finished: Bool) in
                
        });
        
        
    }
    
    func hideToolView(_ toolName:String) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
            if toolName == FILTERSTOOL_NAME { self.filtersToolView.isHidden = true  }
            if toolName == STICKERSTOOL_NAME { self.stickersToolView.isHidden = true  }
            
            
            }, completion: { (finished: Bool) in
                
        });
    }
    @IBAction func pokifyButtonTapped(_ sender: UIButton) {
        normalize_button()
        showToolView(STICKERSTOOL_NAME)
        hideToolView(FILTERSTOOL_NAME)

        
        if sender.tag == 1 {
            stickerType = "sticker"
            stickerButton.setBackgroundImage(UIImage(named: "stickerh"), for: UIControlState())
        }
        else if sender.tag == 2{
            stickerType = "emoji"
            emojiButton.setBackgroundImage(UIImage(named: "emojih"), for: UIControlState())
            
        }
        else if sender.tag == 3{
            stickerType = "facemask"
            facemaskButton.setBackgroundImage(UIImage(named: "facemaskh"), for: UIControlState())
        }
        else if sender.tag == 4{
            stickerType = "se"
            specialfxButton.setBackgroundImage(UIImage(named: "spfxh"), for: UIControlState())
        }
        
        stickerDataSource = StickersDataSource()
        UIView.transition(with: self.stickerCollectionView, duration: 0.33, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            self.stickerCollectionView.reloadData()
            }, completion: nil)
        
        
    }
    

    func normalize_button(){
        stickerButton.setBackgroundImage(UIImage(named: "sticker"), for: UIControlState())
        emojiButton.setBackgroundImage(UIImage(named: "emoji"), for: UIControlState())
        facemaskButton.setBackgroundImage(UIImage(named: "facemask"), for: UIControlState())
        specialfxButton.setBackgroundImage(UIImage(named: "spfx"), for: UIControlState())
        filtersButton.setBackgroundImage(UIImage(named: "filters"), for: UIControlState())
    }
    
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        
        let hasPurchased = UserDefaults.standard.bool(forKey: "RemoveWatermarkAd")
        
        if hasPurchased {
            watermarkImg.isHidden = true
        }
        else
        {
            watermarkImg.isHidden = false
        }
        hideControls()
         containerView.bringSubview(toFront: watermarkImg)
        showHUD()
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(snap_image), userInfo: nil, repeats: false)
        
       
        
        
    }
    
    func snap_image() {
        let rect:CGRect = containerView.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
        containerView.drawHierarchy(in: containerView.bounds, afterScreenUpdates: false)
        editedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        watermarkImg.isHidden = true
        let shareVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShareViewController") as! ShareViewController
        
        
        self.addChildViewController(shareVC)
        shareVC.view.frame = self.view.frame
        self.view.addSubview(shareVC.view)
        shareVC.didMove(toParentViewController: self)
    }
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        let moreVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        
        
        self.addChildViewController(moreVC)
        moreVC.view.frame = self.view.frame
        self.view.addSubview(moreVC.view)
        moreVC.didMove(toParentViewController: self)
    }
    
    @IBAction func coinButtonAction(_ sender: UIButton) {
        let moreVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InAppPurchaseViewController") as! InAppPurchaseViewController
        
        
        self.addChildViewController(moreVC)
        moreVC.view.frame = self.view.frame
        self.view.addSubview(moreVC.view)
        moreVC.didMove(toParentViewController: self)
    }
    
    
}


extension ImageEditorViewController:UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return stickerDataSource.count
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellHeight = screenHeight * 0.13
        
        return CGSize(width: cellHeight, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StickerCollectionCell", for: indexPath) as! StickerCollectionViewCell
        
        if let sticker = stickerDataSource.stickerForItemAtIndexPath(indexPath){
            cell.sticker = sticker
        }
        
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let sticker = stickerDataSource.stickerForItemAtIndexPath(indexPath) {
            
            var lockStatus = true
            
            if sticker.isLocked == false{
                lockStatus = false
            }
            
            if let unlockedStickersArray : AnyObject? = UserDefaults.standard.object(forKey: "UnlockedStickers") as AnyObject?? {
                unlockedStickers = unlockedStickersArray! as! [NSString]
                if unlockedStickers.contains(sticker.imageName as NSString) {
                    lockStatus = false
                }
                
            }
            
            
            if (lockStatus == true)
            {
                let alert = UIAlertController(title: "Sticker Locked!", message: "Spend \(STICKER_UNLOCK_COIN_AMOUNT) coins to unlock this sticker.", preferredStyle: UIAlertControllerStyle.alert)
                
                
                let action1 = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alertAction in
                    
                    if self.totalCoins >= STICKER_UNLOCK_COIN_AMOUNT {
                        self.save_unlock_status(sticker: sticker)
                    }
                    else {
                        self.showAlertWithMessage("", alertMessage: "You do not have enough coins")
                    }
                    alert.dismiss(animated: true, completion: nil)
                })
                let action2 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil)
                
                alert.addAction(action2)
                alert.addAction(action1)
                    self.present(alert, animated: true, completion: nil)
                
                
            }
            else
            {
                stickerButtTapped(sticker: sticker)
            }
            
            print(sticker.imageName)
        }
    }
    
    func save_unlock_status(sticker: Sticker)
    {
    
        if let unlockedStickersArray : AnyObject? = UserDefaults.standard.object(forKey: "UnlockedStickers") as AnyObject?? {
            unlockedStickers = unlockedStickersArray! as! [NSString]
            if !unlockedStickers.contains(sticker.imageName as NSString) {
                unlockedStickers.append(sticker.imageName as NSString)
            }
            UserDefaults.standard.set(unlockedStickers, forKey: "UnlockedStickers")
            print(unlockedStickers)
        }
        changeCoinAmount(STICKER_UNLOCK_COIN_AMOUNT)
        
    }
    func changeCoinAmount(_ changeAmount: Int) {
        totalCoins = totalCoins - changeAmount
        UserDefaults.standard.set(totalCoins, forKey: "CoinCount")
        totalCoins = UserDefaults.standard.integer(forKey: "CoinCount")
        coinCountLabel.text = String(totalCoins)
    
        stickerDataSource = StickersDataSource()
        UIView.transition(with: self.stickerCollectionView, duration: 0.33, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            self.stickerCollectionView.reloadData()
        }, completion: nil)
    }
    
    
    func showAlertWithMessage(_ alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
