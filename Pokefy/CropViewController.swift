//
//  CropViewController.swift
//  Pokefy
//
//  Created by Saad on 8/14/16.
//  Copyright © 2016 Saad. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CropViewController: UIViewController, GADInterstitialDelegate {

    @IBOutlet var containerWidthConstraint: NSLayoutConstraint!
    @IBOutlet var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet var containerView: UIView!
    @IBOutlet var bkgImage: UIImageView!
    @IBOutlet var imageToBeCropped: UIImageView!
    @IBOutlet var imageToBeCroppedWidth: NSLayoutConstraint!
    @IBOutlet var imageToBeCroppedHeight: NSLayoutConstraint!
    
    @IBOutlet var cropbarImage: UIImageView!
    @IBOutlet var imageToBeCroppedAspectConstraints: NSLayoutConstraint!
    
    var screenWidth, screenHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        screenWidth = UIScreen.main.bounds.size.width
        screenHeight = UIScreen.main.bounds.size.height
        
        interstitialAd = createAndLoadInterstitial()
        //showInterstitialAd()
        
        Helper.changeMultiplier(imageToBeCroppedAspectConstraints, multiplier: (takenImage?.size.width)! / (takenImage?.size.height)!)
        
        imageToBeCropped.image = takenImage
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            Helper.changeMultiplier(containerWidthConstraint, multiplier: 0.8)
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        init_ad()
    }
    
    func init_ad() {
        _ = UserDefaults.standard.bool(forKey: "RemoveWatermarkAd")
        
        
    }
    
    @IBAction func cropButtonTapped(_ sender: UIButton) {
        cropbarImage.isHidden = true
        showHUD()
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(cropImage), userInfo: nil, repeats: false)
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
    
    func cropImage() {
        
        
        let rect:CGRect = containerView.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
        containerView.drawHierarchy(in: containerView.bounds, afterScreenUpdates: false)
        croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        stickerType = "sticker"
        let imageEditorVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageEditorViewController") as! ImageEditorViewController
        present(imageEditorVC, animated: true, completion: nil)
        
        
        
        
    }
    
    
    func changeMultiplier(_ constraint: NSLayoutConstraint, multiplier: CGFloat) {
        
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
        //print(newConstraint.multiplier)
        //return newConstraint
        
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let request = GADRequest()
        let interstitial = GADInterstitial(adUnitID: ADMOB_AD_UNIT_ID_INTERSTATIAL)
        interstitial.delegate = self
        interstitial.load(request)
        return interstitial
    }
    
    

    
    @IBAction func moveImage(_ sender: UIPanGestureRecognizer) {
        //print("Panned")
        let translation: CGPoint =  sender.translation(in: self.view)
        sender.view?.center = CGPoint(x: sender.view!.center.x +  translation.x, y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
    }
    @IBAction func zoomImage(_ sender: UIPinchGestureRecognizer) {
        sender.view?.transform = sender.view!.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1
    }

    @IBAction func rotateImage(_ sender: UIRotationGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began ||
            sender.state == UIGestureRecognizerState.changed {
            sender.view!.transform = sender.view!.transform.rotated(by: sender.rotation)
            sender.rotation = 0
        }
    }
    @IBAction func backButtonTapped(_ sender: UIButton) {
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(homeVC, animated: true, completion: nil)
    }
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        let moreVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        
        
        self.addChildViewController(moreVC)
        moreVC.view.frame = self.view.frame
        self.view.addSubview(moreVC.view)
        moreVC.didMove(toParentViewController: self)
    }

}
