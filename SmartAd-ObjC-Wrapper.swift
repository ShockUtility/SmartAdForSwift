//
//  SmartAd-ObjC-Wrapper.swift
//  SmartAdDemo
//
//  Created by shock on 2017. 10. 26..
//  Copyright © 2017년 shock. All rights reserved.
//

import Foundation
import GoogleMobileAds
import FBAudienceNetwork

extension SmartAd { // ObjC
    @objc
    public static var _TEST_BANNER_FACEBOOK: String {
        return TEST_BANNER_FACEBOOK
    }
    
    @objc
    public static var _TEST_BANNER_GOOGLE: String {
        return TEST_BANNER_GOOGLE
    }
    
    @objc
    public class func _addTestDevice(isGoogle: Bool, ids: [String]) {
        if isGoogle {
            googleTestDevices = ids
        } else {
            FBAdSettings.addTestDevices(ids)
        }
    }
    
    @objc
    public class func _setIsShowAdFunc(validClasses:[AnyClass], isShow: @escaping (()->Bool)) {
        IsShowAdFunc = { () in
            return (validClasses, isShow())
        }
    }
}

extension SmartAdBanner { // ObjC
    @objc
    public func _showAd() {
        showAd()
    }
}

extension SmartAdInterstitial { // ObjC
    @objc
    public convenience init(_ controller: UIViewController, adOrder: Int, googleID: String?, facebookID: String?, isShowAfterLoad: Bool = true) {
        self.init(controller, adOrder: SmartAdOrder(rawValue: adOrder) ?? .random, googleID: googleID, facebookID: facebookID, isShowAfterLoad: isShowAfterLoad)
    }
    
    @objc
    public convenience init(_ controller: UIViewController, adOrder: Int, googleID: String?, facebookID: String?) {
        self.init(controller, adOrder: adOrder, googleID: googleID, facebookID: facebookID, isShowAfterLoad: true)
    }
    
    @objc
    public convenience init(_ controller: UIViewController, googleID: String?, facebookID: String?) {
        self.init(controller, adOrder: .random, googleID: googleID, facebookID: facebookID)
    }
    
    @objc
    public func _loadAd() {
        loadAd(delayMilliseconds: 0.0)
    }
    
    @objc
    public func _loadAd(delayMilliseconds: Double = 0.0) {
        loadAd(delayMilliseconds: delayMilliseconds)
    }
    
    @objc
    @discardableResult
    public func _showAd() -> Bool {
        return showAd()
    }
}

extension SmartAdAward { // ObjC
    @objc
    public convenience init(_ controller: UIViewController, adOrder: Int, googleID: String?, facebookID: String?) {
        self.init(controller, adOrder: SmartAdOrder(rawValue: adOrder) ?? .random, googleID: googleID, facebookID: facebookID)
    }
    
    @objc
    public func _showAd() {
        showAd()
    }
}

extension SmartAdAlertController { // ObjC
    @objc
    public class func _alert(_ controller: UIViewController,
                             adOrder: Int,
                             googleID: String?, facebookID: String?,
                             title: String,
                             completed: @escaping (_ isOK: Bool) -> Void)
    {
        alert(controller, adOrder: SmartAdOrder(rawValue: adOrder) ?? .random,
              googleID: googleID, facebookID: facebookID, title: title, completed: completed)
    }
    
    @objc
    public class func _confirm(_ controller: UIViewController,
                               adOrder: Int,
                               googleID: String?, facebookID: String?,
                               title: String,
                               completed: @escaping (_ isOK: Bool) -> Void)
    {
        confirm(controller, adOrder: SmartAdOrder(rawValue: adOrder) ?? .random,
                googleID: googleID, facebookID: facebookID, title: title, completed: completed)
    }
    
    @objc
    public class func _select(_ controller: UIViewController,
                              adOrder: Int,
                              googleID: String?, facebookID: String?,
                              title: String,
                              titleOK: String, titleCancel: String,
                              completed: @escaping (_ isOK: Bool) -> Void)
    {
        select(controller, adOrder: SmartAdOrder(rawValue: adOrder) ?? .random,
               googleID: googleID, facebookID: facebookID,
               title: title, titleOK: titleOK, titleCancel: titleCancel, completed: completed)
    }
}


