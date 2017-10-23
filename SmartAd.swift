//
//  SmartAd.swift
//  SmartAd
//
//  Created by shock on 2017. 10. 23..
//  Copyright © 2017년 shock. All rights reserved.
//

import Foundation
import GoogleMobileAds
import FBAudienceNetwork

enum SmartAdType {
    case google
    case facebook
}

open class SmartAd: NSObject {
    static let TEST_BANNER_FACEBOOK = "YOUR_PLACEMENT_ID"
    static let TEST_BANNER_GOOGLE   = "ca-app-pub-3940256099942544/1712485313"
    
    static var googleTestDevices:[Any]  = []
    static var googleRequest: GADRequest {
        get {
            let request = GADRequest()
            if googleTestDevices.count>0 {
                request.testDevices = googleTestDevices
            }
            return request
        }
    }
    
    class func addTestDevice(type:SmartAdType, ids: [Any]) {
        switch type {
        case .google:
            googleTestDevices = ids
            break
        case .facebook:
            FBAdSettings.addTestDevices(ids as! [String])
            break
        }
    }
    
    @objc
    public class func addTestDevice(isGoogle: Bool, ids: [String]) {
        if isGoogle {
            googleTestDevices = ids
        } else {
            FBAdSettings.addTestDevices(ids)
        }
    }
    
    // 광고를 실행하거나 막기 위해서 커스텀 평션을 만들어서 붙여줄 수 있다
    // 예) 광고 구매 인앱을 결제한 경우 다음 함수를 대입해 주면 광고가 차단된다.
    static var IsShowAdFunc: (() -> (validClasses:[AnyClass], isShow: Bool))?
    static func IsShowAd(_ owner: AnyObject) -> Bool {
        if let ret = IsShowAdFunc?() {                                              // 함수가 존재한다.
            if ret.validClasses.contains(where: { owner.classForCoder == $0 }) {    // 적용 클래스에 포함되어 있다면
                return ret.isShow
            }
        }
        return true
    }
}







