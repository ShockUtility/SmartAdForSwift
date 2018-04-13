//
//  SmartAdAward.swift
//  SmartAd
//
//  Created by shock on 2017. 10. 23..
//  Copyright © 2017년 shock. All rights reserved.
//

import Foundation
import GoogleMobileAds
import FBAudienceNetwork

@objc
public protocol SmartAdAwardDelegate: NSObjectProtocol {
    func smartAdAwardDone(_ isGoogle: Bool, _ isAwardShow: Bool, _ isAwardClick: Bool)
    func smartAdAwardFail(_ error: Error?)
}

public class SmartAdAward: NSObject {
    fileprivate var delegate        : SmartAdAwardDelegate?
    
    fileprivate var controller      : UIViewController!
    fileprivate var adType          : SmartAdType!
    fileprivate var googleID        : String?
    fileprivate var facebookID      : String?
    
    fileprivate var loadingAlert    : UIAlertController?
    fileprivate var isShowAfterLoad = false
    
    fileprivate var isAwardShow     : Bool = false
    fileprivate var isAwardClick    : Bool = false
    
    fileprivate var fRewardedVideoAd: FBRewardedVideoAd?
    
    public convenience init(_ controller: UIViewController, adOrder: SmartAdOrder, googleID: String?, facebookID: String?) {
        self.init()
        
        self.controller    = controller
        self.adType        = adOrder.adType
        self.googleID      = googleID
        self.facebookID    = facebookID
        self.delegate      = controller as? SmartAdAwardDelegate
    }
    
    public func showAd() {
        if SmartAd.IsShowAd(self) {
            loadingAlert = UIAlertController.ad_loading(controller!, loadingStyle: .gray) { (loading) in
                if self.adType == .google {
                    self.showGoogle()
                } else {
                    self.showFacebook()
                }
            }
        }
    }
}

// Google

extension SmartAdAward: GADRewardBasedVideoAdDelegate {
    func showGoogle() {
        if let id = googleID {
            GADRewardBasedVideoAd.sharedInstance().delegate = self
            GADRewardBasedVideoAd.sharedInstance().load(SmartAd.googleRequest, withAdUnitID: id)
        } else {
            loadingAlert?.dismiss(animated: true, completion: {
                self.delegate?.smartAdAwardFail(nil)
            })
        }
    }
    
    // 광고 로딩 완료
    public func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        loadingAlert?.dismiss(animated: true, completion: {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self.controller!) // 광고 오픈
        })
    }
    
    // 광고 로딩 싫패
    public func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
        if adType == .google {
            showFacebook()
        } else {
            loadingAlert?.dismiss(animated: true, completion: {
                self.delegate?.smartAdAwardFail(error)
            })
        }
    }
    
    // 광고를 끝까지 시청해서 보상 완료
    public func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        isAwardShow = true
    }
    
    // 광고가 닫혀야 완료 콜백이 가능하다.
    public func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        delegate?.smartAdAwardDone(true, isAwardShow, isAwardClick)
    }
}

// Facebook

extension SmartAdAward: FBRewardedVideoAdDelegate {
    func showFacebook() {
        if let id = facebookID {
            fRewardedVideoAd = FBRewardedVideoAd(placementID: id)
            fRewardedVideoAd?.delegate = self
            fRewardedVideoAd?.load()
        } else {
            loadingAlert?.dismiss(animated: true, completion: {
                self.delegate?.smartAdAwardFail(nil)
            })
        }
    }
    
    // 광고 로딩 완료
    public func rewardedVideoAdDidLoad(_ rewardedVideoAd: FBRewardedVideoAd) {
        loadingAlert?.dismiss(animated: true, completion: {
            self.fRewardedVideoAd?.show(fromRootViewController: self.controller!) // 광고 오픈
        })
    }
    
    // 광고 로딩 싫패
    public func rewardedVideoAd(_ rewardedVideoAd: FBRewardedVideoAd, didFailWithError error: Error) {
        if adType == .facebook {
            showGoogle()
        } else {
            loadingAlert?.dismiss(animated: true, completion: {
                self.delegate?.smartAdAwardFail(error)
            })
        }
    }
    
    // 광고를 끝까지 시청해서 보상 완료
    public func rewardedVideoAdVideoComplete(_ rewardedVideoAd: FBRewardedVideoAd) {
        isAwardShow = true
    }
    
    // 설치 버튼 클릭 시
    public func rewardedVideoAdDidClick(_ rewardedVideoAd: FBRewardedVideoAd) {
        isAwardClick = true
    }
    
    // 광고창을 닫을때 발생 (보상과 상관 없다)
    public func rewardedVideoAdDidClose(_ rewardedVideoAd: FBRewardedVideoAd) {
        delegate?.smartAdAwardDone(false, isAwardShow, isAwardClick)
    }
}





