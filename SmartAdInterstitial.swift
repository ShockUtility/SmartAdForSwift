//
//  SmartAdInterstitial.swift
//  SmartAd
//
//  Created by shock on 2017. 10. 23..
//  Copyright © 2017년 shock. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
import FBAudienceNetwork
import ShockExtension

protocol SmartAdInterstitialDelegate: NSObjectProtocol {
    func smartAdInterstitialDone()
    func smartAdInterstitialFail(_ error: Error?)
}

open class SmartAdInterstitial: NSObject {
    
    fileprivate var controller  : UIViewController!
    fileprivate var googleID    : String?
    fileprivate var facebookID  : String?
    
    var delegate: SmartAdInterstitialDelegate?
    
    var isGoogleFirst           : Bool!
    var delayMilliseconds       : Double!
    
    var gInterstitial: GADInterstitial?
    var fInterstitial: FBInterstitialAd?
    
    var isLoadAfterShow         = false
    
    @objc
    public convenience init(_ controller: UIViewController, googleID: String?, facebookID: String?, isGoogleFirst: Bool = true) {
        self.init()
        
        self.controller    = controller
        self.googleID      = googleID
        self.facebookID    = facebookID
        self.isGoogleFirst = isGoogleFirst
        self.delegate      = controller as? SmartAdInterstitialDelegate
    }
    
    @objc
    public func loadAd(isLoadAfterShow: Bool = true, delayMilliseconds: Double = 1.5) {
        if SmartAd.IsShowAd(self) {
            self.isLoadAfterShow = isLoadAfterShow
            self.delayMilliseconds = delayMilliseconds

            if isGoogleFirst {
                loadGoogle()
            } else {
                loadFacebook()
            }
        }
    }
    
    @objc
    @discardableResult
    public func showLoadedAd() -> Bool {
        if let gAd = gInterstitial, gAd.isReady {
            gAd.present(fromRootViewController: self.controller)
            self.delegate?.smartAdInterstitialDone()
            return true
        } else if let fAd = fInterstitial, fAd.isAdValid {
            fAd.show(fromRootViewController: self.controller)
            self.delegate?.smartAdInterstitialDone()
            return true
        }
        return false
    }
}

extension SmartAdInterstitial: GADInterstitialDelegate {
    func loadGoogle() {
        if let gID = googleID {
            gInterstitial = GADInterstitial(adUnitID: gID)
            gInterstitial?.delegate = self
            gInterstitial?.load(SmartAd.googleRequest)
        }
    }
    
    public func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        if isLoadAfterShow {
            DispatchQueue.main.asyncAfter(deadline: .now() + delayMilliseconds) {
                self.showLoadedAd()
            }
        }
    }
    
    public func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        printLog(error.localizedDescription)
        
        if isGoogleFirst {
            self.loadFacebook()
        } else {
            delegate?.smartAdInterstitialFail(error)
        }
    }
}

extension SmartAdInterstitial: FBInterstitialAdDelegate {
    func loadFacebook() {
        if let gID = facebookID {
            fInterstitial = FBInterstitialAd(placementID: gID)
            fInterstitial?.delegate = self
            fInterstitial?.load()
        }
    }
    
    public func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        if isLoadAfterShow {
            DispatchQueue.main.asyncAfter(deadline: .now() + delayMilliseconds) {
                self.showLoadedAd()
            }
        }
    }
    
    public func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        if !isGoogleFirst {
            self.loadGoogle()
        } else {
            delegate?.smartAdInterstitialFail(nil)
        }
    }
}







