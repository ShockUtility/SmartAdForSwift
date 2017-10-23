//
//  SmartAdBanner.swift
//  SmartAd
//
//  Created by shock on 2017. 10. 23..
//  Copyright © 2017년 shock. All rights reserved.
//

import Foundation
import GoogleMobileAds
import FBAudienceNetwork
import ShockExtension

@objc
public protocol SmartAdBannerDelegate: NSObjectProtocol {
    func smartAdBannerDone(_ view: SmartAdBanner)
    func smartAdBannerFail(_ error: Error?)
}

open class SmartAdBanner: UIView {
    
    @IBOutlet open weak var delegate: SmartAdBannerDelegate?
/*
    #if TARGET_INTERFACE_BUILDER
    @IBOutlet open weak var delegate: AnyObject?
    #else
    open weak var delegate: SmartAdBannerDelegate?
    #endif
*/
    @IBInspectable public var googleAdID         : String?
    @IBInspectable public var facebookAdID       : String?
    @IBInspectable public var isAwakeShow        : Bool    = true
    @IBInspectable public var isGoogleFirst      : Bool    = true
    @IBInspectable public var isRandomAD         : Bool    = false
    @IBInspectable public var isHiddenAfterFail  : Bool    = true
    @IBInspectable public var isAutoHeight       : Bool    = true
    
    fileprivate var gAdView    : GADBannerView?
    fileprivate var fAdView    : FBAdView?
    
    fileprivate lazy var rootController: UIViewController? = {
        var responder: UIResponder? = self
        while responder != nil {
            if let res = responder as? UIViewController {
                return res
            }
            responder = responder?.next
        }
        return nil
    }()
    
    fileprivate lazy var fbAdSize: FBAdSize = {
        let height = self.frame.size.height
        if height >= 250 {
            return kFBAdSizeHeight250Rectangle
        }
        else if height >= 90 {
            return kFBAdSizeHeight90Banner
        }
        return kFBAdSizeHeight50Banner
    }()
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        if isAwakeShow {
            showAd()
        }
    }
    
    @objc
    public func showAd() {
        if isRandomAD {
            isGoogleFirst = arc4random_uniform(2)==0
        }
        
        if SmartAd.IsShowAd(self) {
            if let gID = googleAdID {
                gAdView = GADBannerView()
                if let gAdView = gAdView {
                    gAdView.delegate = self
                    gAdView.rootViewController = rootController
                    gAdView.adUnitID = gID
                    self <<== gAdView
                }
            }
            
            if let fID = facebookAdID {
                fAdView = FBAdView(placementID: fID, adSize: fbAdSize, rootViewController: rootController)
                if let fAdView = fAdView {
                    fAdView.delegate = self
                    self <<== fAdView
                }
            }
            
            if gAdView==nil && fAdView==nil {
                onFail(nil)
            } else {
                if isGoogleFirst && gAdView != nil {
                    gAdView?.load(SmartAd.googleRequest)
                } else if fAdView != nil {
                    fAdView?.loadAd()
                }
            }
        } else {
            onDone(adHeight: 0)
        }
    }
    
    fileprivate func onDone(adHeight: CGFloat) {
        if isAutoHeight {
            if let constraint = (constraints.filter{$0.firstAttribute == .height}.first) {
                constraint.constant = adHeight
            }
        }
        delegate?.smartAdBannerDone(self)
    }
    
    fileprivate func onFail(_ error: Error?) {
        self.isHidden = isHiddenAfterFail
        delegate?.smartAdBannerFail(error)
    }
}

extension SmartAdBanner: GADBannerViewDelegate {
    public func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        onDone(adHeight: bannerView.adSize.size.height)
    }
    
    public func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        printLog(error.localizedDescription)
        
        if isGoogleFirst, fAdView != nil {
            fAdView?.loadAd()
        } else {
            onFail(error)
        }
    }
}

extension SmartAdBanner: FBAdViewDelegate {
    public func adViewDidLoad(_ adView: FBAdView) {
        onDone(adHeight: fbAdSize.size.height)
    }
    
    public func adView(_ adView: FBAdView, didFailWithError error: Error) {
        printLog(error.localizedDescription)
        
        if !isGoogleFirst, gAdView != nil {
            gAdView?.load(SmartAd.googleRequest)
        } else {
            onFail(error)
        }
    }
}





