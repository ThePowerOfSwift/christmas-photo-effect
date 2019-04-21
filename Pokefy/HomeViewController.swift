//
//  HomeViewController.swift
//  Pokefy
//
//  Created by Saad on 7/24/16.
//  Copyright © 2016 Saad. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, GADInterstitialDelegate {

    @IBOutlet var sliderImage: UIImageView!
    @IBOutlet var containerWidthConstraint: NSLayoutConstraint!
    var iMinSessions = 3
    var iTryAgainSessions = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenWidth = UIScreen.main.bounds.size.width
        screenHeight = UIScreen.main.bounds.size.height
        init_data()
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            Helper.changeMultiplier(containerWidthConstraint, multiplier: 0.8)
        }

        
        let images = [UIImage(named: "slider1")!, UIImage(named: "slider2")!, UIImage(named: "slider3")!, UIImage(named: "slider4")!]
        sliderImage.animationImages = images
        sliderImage.animationDuration = 10
        sliderImage.startAnimating()
        
        /*UIView.transition(with: sliderImage, duration: 5, options: .transitionFlipFromBottom, animations: {() -> Void in
            self.sliderImage.image! = UIImage(named: "slider1")!
        }, completion: {(_ done: Bool) -> Void in
            UIView.transition(with: self.sliderImage, duration: 5, options: .transitionFlipFromBottom, animations: {() -> Void in
                self.sliderImage.image! = UIImage(named: "slider2")!
            }, completion: {(_ done: Bool) -> Void in
                UIView.transition(with: self.sliderImage, duration: 5, options: .transitionFlipFromBottom, animations: {() -> Void in
                    self.sliderImage.image! = UIImage(named: "slider3")!
                }, completion: {(_ done: Bool) -> Void in
                })
            })
        })*/
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        rateMe()
        interstitialAd = createAndLoadInterstitial()
        
        
        stickersImageArray.removeAll()
        stickersImagePosition.removeAll()
    }
    
    func init_data() {
        if(UserDefaults.standard.bool(forKey: "HasLaunchedOnce"))
        {
            // app already launched
            print("Already Launched")
            
        }
        else
        {
            // This is the first launch ever
            print("First Launch")
            UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
            //In App Purchase Initialization
            UserDefaults.standard.set(100, forKey: "CoinCount")
            UserDefaults.standard.set(unlockedStickers, forKey: "UnlockedStickers")
            
            UserDefaults.standard.set(false, forKey: "RemoveWatermarkAd")
            UserDefaults.standard.synchronize()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [AnyHashable: Any]?) {
        takenImage = image
        self.dismiss(animated: false, completion: nil)
        goToCropImageVC()
    }
    
    func goToCropImageVC() {
        
        
        let ciVC = self.storyboard?.instantiateViewController(withIdentifier: "CropViewController") as! CropViewController
        present(ciVC, animated: true, completion: nil)
    }

    @IBAction func moreAppsButtonTapped(_ sender: UIButton) {
       //showInterstitialAd()
        UIApplication.shared.openURL(NSURL(string: DEVELOPER_PAGE_LINK)! as URL)
    }
    @IBAction func purchaseButtonTapped(_ sender: UIButton) {
        let iapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InAppPurchaseViewController") as! InAppPurchaseViewController
        
        
        self.addChildViewController(iapVC)
        iapVC.view.frame = self.view.frame
        self.view.addSubview(iapVC.view)
        iapVC.didMove(toParentViewController: self)
    }
    @IBAction func rateButtonTapped(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string: APP_STORE_LINK)!)
    }
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    @IBAction func libraryButtonTapped(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func rateMe() {
        let neverRate = UserDefaults.standard.bool(forKey: "neverRate")
        var numLaunches = UserDefaults.standard.integer(forKey: "numLaunches") + 1
        
        if (!neverRate && (numLaunches == iMinSessions || numLaunches >= (iMinSessions + iTryAgainSessions + 1)))
        {
            showRateMe()
            numLaunches = iMinSessions + 1
        }
        UserDefaults.standard.set(numLaunches, forKey: "numLaunches")
    }
    
    func showRateMe() {
        let alert = UIAlertController(title: "Rate Us", message: "Do you love this app?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Rate it Now!", style: UIAlertActionStyle.default, handler: { alertAction in
            UIApplication.shared.openURL(URL(string : APP_STORE_LINK)!)
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No Thanks", style: UIAlertActionStyle.default, handler: { alertAction in
            UserDefaults.standard.set(true, forKey: "neverRate")
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Maybe Later", style: UIAlertActionStyle.default, handler: { alertAction in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let request = GADRequest()
        let interstitial = GADInterstitial(adUnitID: ADMOB_AD_UNIT_ID_INTERSTATIAL)
        interstitial.delegate = self
        interstitial.load(request)
        return interstitial
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
    
}
