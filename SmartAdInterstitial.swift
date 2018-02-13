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

@objc
public protocol SmartAdInterstitialDelegate: NSObjectProtocol {
    func smartAdInterstitialDone()
    func smartAdInterstitialFail(_ error: Error?)
}

open class SmartAdInterstitial: NSObject {
    
    fileprivate var delegate            : SmartAdInterstitialDelegate?
    
    fileprivate var controller          : UIViewController!
    fileprivate var adType              : SmartAdType!
    fileprivate var googleID            : String?
    fileprivate var facebookID          : String?
    
    fileprivate var delayMilliseconds   : Double!
    fileprivate var isShowAfterLoad     = false
    
    fileprivate var gInterstitial       : GADInterstitial?
    fileprivate var fInterstitial       : FBInterstitialAd?
    
    public convenience init(_ controller: UIViewController, adOrder: SmartAdOrder, googleID: String?, facebookID: String?, isShowAfterLoad: Bool = true) {
        self.init()
        
        self.delegate        = controller as? SmartAdInterstitialDelegate
        self.controller      = controller
        self.adType          = adOrder.adType
        self.googleID        = googleID
        self.facebookID      = facebookID
        self.isShowAfterLoad = isShowAfterLoad
                
        loadAd()
    }
    
    public convenience init(_ controller: UIViewController, adOrder: SmartAdOrder, googleID: String?, facebookID: String?) {
        self.init(controller, adOrder: adOrder, googleID: googleID, facebookID: facebookID, isShowAfterLoad: true)
    }
    
    public func loadAd(delayMilliseconds: Double = 0.0) {
        if SmartAd.IsShowAd(self) {
            self.delayMilliseconds = delayMilliseconds

            if adType == .google {
                loadGoogle()
            } else {
                loadFacebook()
            }
        }
    }
    
    @discardableResult
    public func showAd() -> Bool {
        if let gAd = gInterstitial, gAd.isReady {
            gAd.present(fromRootViewController: self.controller)
            self.delegate?.smartAdInterstitialDone()
            gInterstitial = nil
            return true
        } else if let fAd = fInterstitial, fAd.isAdValid {
            fAd.show(fromRootViewController: self.controller)
            self.delegate?.smartAdInterstitialDone()
            fInterstitial = nil
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
        if isShowAfterLoad {
            DispatchQueue.main.asyncAfter(deadline: .now() + delayMilliseconds) {
                self.showAd()
            }
        }
    }
    
    public func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        printLog(error.localizedDescription)
        
        if adType == .google {
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
        if isShowAfterLoad {
            DispatchQueue.main.asyncAfter(deadline: .now() + delayMilliseconds) {
                self.showAd()
            }
        }
    }
    
    public func interstitialAd(_ interstitialAd: FBInterstitialAd, didFailWithError error: Error) {
        printLog(error.localizedDescription)
        
        if adType == .facebook {
            self.loadGoogle()
        } else {
            delegate?.smartAdInterstitialFail(nil)
        }
    }
}





