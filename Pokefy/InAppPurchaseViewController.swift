//
//  InAppPurchaseViewController.swift
//  Pokefy
//
//  Created by Saad on 8/29/16.
//  Copyright © 2016 Saad. All rights reserved.
//

import UIKit
import StoreKit

class InAppPurchaseViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    @IBOutlet var coinCountLabel: UILabel!
    @IBOutlet var popUpViewBg: UIView!
    
    var products = [SKProduct]()
    var busyView: UIActivityIndicatorView!
    var totalCoins: Int!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.showAnimate()
        
        
        
        
        busyView = UIActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: screenHeight))
        busyView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        busyView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        self.view.addSubview(busyView)
        
        SKPaymentQueue.default().add(self)
        
        busyView.startAnimating()
        
        
        requestProductInformation()
        totalCoins = UserDefaults.standard.integer(forKey: "CoinCount")
        coinCountLabel.text = String(totalCoins)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func requestProductInformation() {
        if SKPaymentQueue.canMakePayments() {
            products = [SKProduct]()
            let productIDs = Set(["com.tidepace.ChristmasPhotoEffects.BowlofCoin", "com.tidepace.ChristmasPhotoEffects.BagofCoin"])
            let productRequest = SKProductsRequest(productIdentifiers: productIDs)
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            showAlert("", alertMessage: "In app purchase disabled")
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        busyView.stopAnimating()
        products = response.products
        if products.count == 0 {
            showAlert("", alertMessage: "No products found")
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        busyView.stopAnimating()
        showAlert("", alertMessage: error.localizedDescription)
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
    @IBAction func productButtonTapped(_ sender: UIButton) {
        if products.count == 0 {
            showAlert("", alertMessage: "No products to purchase")
        }
        else {
            busyView.startAnimating()
            var index = 0
            for i in 0 ..< products.count {
                if sender.tag == 1 && products[i].productIdentifier == "com.tidepace.ChristmasPhotoEffects.BowlofCoin" {
                    index = i
                    break
                }
                if sender.tag == 2 && products[i].productIdentifier == "com.tidepace.ChristmasPhotoEffects.BagofCoin" {
                    index = i
                    break
                }
                
            }
            let payment = SKPayment(product: products[index])
            SKPaymentQueue.default().add(payment)
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions as [SKPaymentTransaction] {
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                completeTransaction(transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
                busyView.stopAnimating()
                
            case SKPaymentTransactionState.failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                showAlert("", alertMessage: "Transaction failed")
                busyView.stopAnimating()
                
            default:
                break
            }
        }
    }
    
    func completeTransaction(_ transaction: SKPaymentTransaction)
    {
        if transaction.payment.productIdentifier == "com.tidepace.ChristmasPhotoEffects.BowlofCoin" {
            deliverProduct(500)
        }
        else if transaction.payment.productIdentifier == "com.tidepace.ChristmasPhotoEffects.BagofCoin" {
            deliverProduct(1500)
        }
        
    }
    
    func deliverProduct(_ coinIncrement: Int) {
        var totalCoins = UserDefaults.standard.integer(forKey: "CoinCount")
        totalCoins += coinIncrement
        UserDefaults.standard.set(totalCoins, forKey: "CoinCount")
        coinCountLabel.text = String(totalCoins)
        UserDefaults.standard.set(true, forKey: "RemoveWatermarkAd")
    }
    
    
    
    @IBAction func videoAdView(_ sender: UIButton) {
        if ALInterstitialAd.isReadyForDisplay() {
            ALInterstitialAd.show()
            deliverProduct(STICKER_UNLOCK_COIN_AMOUNT)
        } else {
            print("ad not ready")
        }
    }
    @IBAction func closeButtontapped(_ sender: UIButton) {
        self.removeAnimate()
    }
    func showAlert(_ alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func restorePurchaseTapped(_ sender: UIButton) {
        busyView.startAnimating()
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
