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

// 구글 네이티브 광고 사이즈 (https://support.google.com/admob/answer/6270315?hl=ko&ref_topic=7384597)
// --------------------------------------------------
//            넓이             높이
// --------------------------------------------------
//   - 소형 :  280 ~ 1200       80 ~  612
//   - 중형 :  280 ~ 1200      132 ~ 1200
//   - 대형 :  280 ~ 1200      250 ~ 1200
// --------------------------------------------------

// 페이스북 네이티브 광고 사이즈 (https://developers.facebook.com/docs/audience-network/ios/nativeadtemplate)
// --------------------------------------------------
//            넓이             높이
// --------------------------------------------------
//   - 특대 :  자동             400
//   - 대형 :  자동             300
//   - 중형 :  자동             120
//   - 소형 :  자동             100
// --------------------------------------------------







