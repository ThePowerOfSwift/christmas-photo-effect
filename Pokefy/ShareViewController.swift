//
//  ShareViewController.swift
//  Pokefy
//
//  Created by Saad on 8/22/16.
//  Copyright © 2016 Saad. All rights reserved.
//

import UIKit
import Social
import MessageUI


class ShareViewController: UIViewController, MFMailComposeViewControllerDelegate, UIDocumentInteractionControllerDelegate{

    @IBOutlet var coinCountLabel: UILabel!
    @IBOutlet var containerWidthConstraint: NSLayoutConstraint!
    @IBOutlet var previewImage: UIImageView!
    @IBOutlet var popUpBgView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // adding the blur effect
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = popUpBgView.bounds
        popUpBgView.insertSubview(blurView, at: 0)
        previewImage.image = editedImage
        
        self.showAnimate()
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            Helper.changeMultiplier(containerWidthConstraint, multiplier: 0.8)
        }

        let totalCoins = UserDefaults.standard.integer(forKey: "CoinCount")
        coinCountLabel.text = String(totalCoins)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
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
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.removeAnimate()
    }

    @IBAction func fbShareButtonTapped(_ sender: UIButton) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let fbSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            fbSheet?.setInitialText(SHARING_MESSAGE)
            fbSheet?.add(editedImage)
            self.present(fbSheet!, animated: true, completion: nil)
        } else {
            
            showAlert("Facebook", alertMessage: "Please login to your Facebook account in Settings")
        }
    }

    @IBAction func twitterShareTapped(_ sender: UIButton) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let twSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twSheet?.setInitialText(SHARING_MESSAGE)
            twSheet?.add(editedImage)
            self.present(twSheet!, animated: true, completion: nil)
        } else {
            
            showAlert("Twitter", alertMessage: "Please login to your Twitter account in Settings")
        }
    }
    var docIntController = UIDocumentInteractionController()
    @IBAction func instagramShareTapped(_ sender: UIButton) {
//        let instagramURL = NSURL(string: "instagram://app")!
//        if UIApplication.sharedApplication().canOpenURL(instagramURL) {
        
            //Save the Image to default device Directory
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let savedImagePath:String = paths + "/image.igo"
            let imageData: Data = UIImageJPEGRepresentation(editedImage!, 1.0)!
            try? imageData.write(to: URL(fileURLWithPath: savedImagePath), options: [])
            
            //Load the Image Path
            let getImagePath = paths + "/image.igo"
            let fileURL: URL = URL(fileURLWithPath: getImagePath)
            
            
            docIntController = UIDocumentInteractionController(url: fileURL)
            docIntController.uti = "com.instagram.exclusivegram"
            docIntController.delegate = self
            docIntController.presentOpenInMenu(from: CGRect.zero, in: self.view, animated: true)
            
//        } else {
//            let alert:UIAlertView = UIAlertView(title: APP_NAME,
//                                                message: "Instagram not found, please download it on the App Store",
//                                                delegate: nil,
//                                                cancelButtonTitle: "OK")
//            alert.show()
//        }
    }
    @IBAction func pinterestShareTapped(_ sender: UIButton) {
    }
    @IBAction func mailShareTapped(_ sender: UIButton) {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setSubject(SHARING_SUBJECT)
        mailComposer.setMessageBody(SHARING_MESSAGE, isHTML: true)
        
        // Attach image
        let imageData = UIImageJPEGRepresentation(editedImage!, 1.0)
        mailComposer.addAttachmentData(imageData!, mimeType: "image/png", fileName: "MyPhoto.png")
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposer, animated: true, completion: nil)
        }
        
    }
    
    // Email delegate
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        var outputMessage = ""
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            outputMessage = "Mail cancelled"
        case MFMailComposeResult.saved.rawValue:
            outputMessage = "Mail saved"
        case MFMailComposeResult.sent.rawValue:
            outputMessage = "Mail sent"
        case MFMailComposeResult.failed.rawValue:
            outputMessage = "Something went wrong with sending Mail, try again later."
        default: break
        }
        
        showAlert(APP_NAME, alertMessage: outputMessage)
        
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func moreShareTapped(_ sender: UIButton) {
        // NOTE: The following method works only on a Real device, not on iOS Simulator, + You should have apps like Instagram, iPhoto, etc. already installed into your device!
        
        //Save the Image to default device Directory
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let savedImagePath:String = paths + "/image.jpg"
        let imageData: Data = UIImageJPEGRepresentation(editedImage!, 1.0)!
        try? imageData.write(to: URL(fileURLWithPath: savedImagePath), options: [])
        
        //Load the Image Path
        let getImagePath = paths + "/image.jpg"
        let fileURL: URL = URL(fileURLWithPath: getImagePath)
        
        // Open the Document Interaction controller for Sharing options
        docIntController.delegate = self
        docIntController = UIDocumentInteractionController(url: fileURL)
        docIntController.presentOpenInMenu(from: CGRect.zero, in: self.view, animated: true)
    }
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        let moreVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        
        
        self.addChildViewController(moreVC)
        moreVC.view.frame = self.view.frame
        self.view.addSubview(moreVC.view)
        moreVC.didMove(toParentViewController: self)
    }
    @IBAction func saveImageTapped(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(editedImage!, nil,nil, nil)
        simpleAlert("Your picture has been saved to Photo Library!")

    }
    
    @IBAction func buyCoinTapped(_ sender: UIButton) {
        let moreVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InAppPurchaseViewController") as! InAppPurchaseViewController
        
        
        self.addChildViewController(moreVC)
        moreVC.view.frame = self.view.frame
        self.view.addSubview(moreVC.view)
        moreVC.didMove(toParentViewController: self)
    }
    func showAlert(_ alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        print("Test PArent")
        hideHUD()
    }
}
