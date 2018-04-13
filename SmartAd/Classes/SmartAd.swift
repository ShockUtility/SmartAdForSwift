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

public enum SmartAdType:Int {
    case google   = 1
    case facebook = 2
}

public enum SmartAdOrder:Int {
    case random   = 0
    case google   = 1
    case facebook = 2
    
    init(named: String) {
        switch named.lowercased() {
        case "google"  : self = .google
        case "facebook": self = .facebook
        default        : self = .random  
        }
    }
    
    var adType: SmartAdType {
        get {
            switch self {
            case .google  : return .google
            case .facebook: return .facebook
            case .random  : return (arc4random_uniform(2) == 0) ? .google : .facebook
            }
        }
    }
}

open class SmartAd: NSObject {
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
    
    open class func addTestDevice(type: SmartAdType, ids: [Any]) {
        switch type {
        case .google:
            googleTestDevices = ids
            break
        case .facebook:
            FBAdSettings.addTestDevices(ids as! [String])
            break
        }
    }
    
    // 광고를 실행하거나 막기 위해서 커스텀 평션을 만들어서 붙여줄 수 있다
    // 예) 광고 구매 인앱을 결제한 경우 다음 함수를 대입해 주면 광고가 차단된다.    
    open static var IsShowAdFunc: (() -> (validClasses:[AnyClass], isShow: Bool))?
    open class func IsShowAd(_ owner: AnyObject) -> Bool {
        if let ret = IsShowAdFunc?() {                                              // 함수가 존재한다.
            if ret.validClasses.contains(where: { owner.classForCoder == $0 }) {    // 적용 클래스에 포함되어 있다면
                return ret.isShow
            }
        }
        return true
    }
}









