//
//  SmartAdBanner2.swift
//  SmartAd
//
//  Created by shock on 2018. 4. 13..
//

import UIKit
import GoogleMobileAds
import FBAudienceNetwork

@objc
public protocol SmartAdBannerDelegate: NSObjectProtocol {
    func smartAdBannerDone(_ view: SmartAdBanner)
    func smartAdBannerFail(_ view: SmartAdBanner, error: Error?)
}

public class SmartAdBanner: UIView {

    @IBOutlet open weak var delegate: SmartAdBannerDelegate?
    
    @IBInspectable public var adOrderString      : String?  {
        willSet {
            adType = SmartAdOrder(named: newValue?.lowercased() ?? "").adType
        }
    }
    @IBInspectable public var googleAdID         : String?
    @IBInspectable public var facebookAdID       : String?
    @IBInspectable public var isAwakeShow        : Bool    = true
    @IBInspectable public var isHideAfterFail    : Bool    = true
    @IBInspectable public var isAutoHeight       : Bool    = true
    
    public var adType          : SmartAdType = SmartAdOrder.random.adType
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
    
    public func showAd() {
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
                if adType == .google, gAdView != nil {
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
        self.isHidden = isHideAfterFail
        delegate?.smartAdBannerFail(self, error: error)
    }
}


extension SmartAdBanner: GADBannerViewDelegate {
    public func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        onDone(adHeight: bannerView.adSize.size.height)
    }
    
    public func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        bannerView.removeFromSuperview()
        bannerView.delegate = nil
        gAdView = nil
        
        if adType == .google, fAdView != nil {
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
        adView.removeFromSuperview()
        adView.delegate = nil
        fAdView = nil
        
        if adType == .facebook, gAdView != nil {
            gAdView?.load(SmartAd.googleRequest)
        } else {
            onFail(error)
        }
    }
}

