//
//  MoreViewController.swift
//  Pokefy
//
//  Created by Saad on 8/28/16.
//  Copyright © 2016 Saad. All rights reserved.
//

import UIKit
import Social
import GoogleMobileAds

class MoreViewController: UIViewController, GADInterstitialDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.showAnimate()
    }

    override func viewWillAppear(_ animated: Bool) {
        interstitialAd = createAndLoadInterstitial()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func premiumContentsTapped(_ sender: UIButton) {
    }

    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }
    @IBAction func rateUsTapped(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string: APP_STORE_LINK)!)
    }
    @IBAction func tellAFriendTapped(_ sender: UIButton) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let facebookSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet?.add(URL(string: APP_STORE_LINK))
            self.present(facebookSheet!, animated: true, completion: nil)
        }
    }
    @IBAction func premiumContentTapped(_ sender: UIButton) {
        //self.view.removeFromSuperview()
        let iapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InAppPurchaseViewController") as! InAppPurchaseViewController
        
        
        self.addChildViewController(iapVC)
        iapVC.view.frame = self.view.frame
        self.view.addSubview(iapVC.view)
        iapVC.didMove(toParentViewController: self)
        
    }
    
    @IBAction func returnToHomeTapped(_ sender: UIButton) {
        
        
        let alert = UIAlertController(title: APP_NAME, message: "Are you sure you want to exit? You'll lose all changes you've made so far.", preferredStyle: UIAlertControllerStyle.alert)
        
        let action1 = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: returnHome)
        let action2 = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(action1)
        alert.addAction(action2)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    func returnHome(_ action: UIAlertAction){
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(homeVC, animated: true, completion: nil)
    }
   
    @IBAction func restorePurchaseTapped(_ sender: UIButton) {
        let iapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InAppPurchaseViewController") as! InAppPurchaseViewController
        
        
        self.addChildViewController(iapVC)
        iapVC.view.frame = self.view.frame
        self.view.addSubview(iapVC.view)
        iapVC.didMove(toParentViewController: self)
    }
    @IBAction func moreAppsTappled(_ sender: UIButton) {
        showInterstitialAd()
    }
    @IBAction func moreCloseTapped(_ sender: UIButton) {
        self.removeAnimate()
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
