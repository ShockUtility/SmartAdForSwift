[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-iOS-green.svg)](https://developer.apple.com/swift)
[![GitHub release](https://img.shields.io/github/release/ShockUtility/SmartAdForSwift.svg)](https://github.com/ShockUtility/SmartAdForSwift)
[![English](https://github.com/ShockUtility/SmartAdForSwift/blob/master/res/en.png?raw=true)](https://github.com/ShockUtility/SmartAdForSwift)
[![Korea](https://github.com/ShockUtility/SmartAdForSwift/blob/master/res/kr.png?raw=true)](https://github.com/ShockUtility/SmartAdForSwift/blob/master/README_kr.md)
[![Japan](https://github.com/ShockUtility/SmartAdForSwift/blob/master/res/jp.png?raw=true)](https://github.com/ShockUtility/SmartAdForSwift/blob/master/README_jp.md)

# SmartAd 소개
SmartAd 는 iOS 와 Android 에서 AdMob 과 Audience Network 광고 프레임웍을 간편하게 사용하기 위한 라이브러리 입니다.

- [SmartAd for Swift](https://github.com/ShockUtility/SmartAdForSwift) -> [Demo Project](https://github.com/ShockUtility/SmartAdDemoForSwift)
- [SmartAd for Android](https://github.com/ShockUtility/SmartAdForAndroid)) -> [Demo Project](https://github.com/ShockUtility/SmartAdDemoForAndroid)



# 설치
```code
Source 폴더의 파일들을 개발중인 프로젝트에 직접 추가해서 사용해야 합니다.
```

# 의존성
```code
  pod 'Google-Mobile-Ads-SDK'
  pod 'FBAudienceNetwork'
  pod 'ShockExtension'  
```
- 개발환경 XCode 9.0, Swift4 에서 작성 되었습니다.
- Google-Mobile-Ads-SDK (7.23.0) 에서 테스트 되었습니다.
- FBAudienceNetwork (4.25.0) 에서 테스트 되었습니다.


# 지원되는 광고 형식
## AdMob
- AdView (기본 베너)
- InterstitialAd (전면 광고)
- RewardedVideoAd (보상 광고)

## Audience Network
- AdView (기본 베너)
- InterstitialAd (삽입 광고)
- RewardedVideoAd (보상 광고)



# 사용법

## 기본 베너 (SmartAdBanner)
![Screenshot](https://github.com/ShockUtility/SmartAdForSwift/blob/master/screenshot/screen_01.png?raw=true)<br>
StoryBoard 에서 뷰를 추가하고 커스텀 뷰를 'SmartAdBanner' 로 변경 후 프로퍼티만 셋팅하면 코딩 없이 바로 동작 됩니다.<br>
반환값을 리턴받고 싶은 경우엔 delegate 를 설정하고 다음과 같이 SmartAdBannerDelegate를 구현한다.
```swift
extension ViewController: SmartAdBannerDelegate {
    func smartAdBannerDone(_ view: SmartAdBanner) {
        // 광고가 표시됨
    }

    func smartAdBannerFail(_ error: Error?) {
        // 마지막으로 로딩을 시도한 광고의 에러 메세지
    }
}
```

`* 주의 : isAutoHeight 값이 적용되기 위해서는 SmartAdBanner 의 오토 레이아웃에 Height 값이 지정되어 있어야 합니다. 각 플렛폼의 광고가 로딩 완료 되면 광고 크기에 맞게 Height 값이 수정되며 실패할 경우 0으로 셋팅되어 화면에 표시되지 않습니다. `
<br>
`* 주의 : SmartAdBanner 는 크기 형식에 따라 최소 넓이가 300 또는 320 보다 커야 정상적으로 표시 됩니다.`

## 전면 광고 (SmartAdInterstitial)
전면 광고를 호출하는 가장 간단한 코드는 다음과 같다.
```swift
smartAdInterstitial = SmartAdInterstitial(self, googleID: "XXXXX", facebookID: "XXXXX")
smartAdInterstitial?.showAd()
```

상황에 따라 결과값을 반환 받고 싶을 경우 컨트롤러에 SmartAdInterstitialDelegat를 구현하면 된다
```swift
extension ViewController: SmartAdInterstitialDelegate {
    func smartAdInterstitialDone() {
        // 광고가 표시됨
    }
    
    func smartAdInterstitialFail(_ error: Error?) {
        // 마지막으로 로딩을 시도한 광고의 에러 메세지
    }
}
```
 
SmartAdInterstitial 의 showAd 함수는 다음과 같은 파라미터를 추가해서 호출 할 수 있습니다.<br>
firstDelayMilliseconds : 첫번째 광고 로딩이 성공한 경우 몇초 후에 표기할지를 설정 <br>
secondDelayMilliseconds : 첫번째 광고 로딩이 실패 했다면 몇초 후에 두번째 광고를 로딩 할지 설정
```swift
func showAd(isGoogleFirst: Bool = true, 
            firstDelayMilliseconds:Double = 1.5, 
            secondDelayMilliseconds:Double = 3.0)
```

## 보상 광고 (SmartAdAward)
Activity 에서 호출하는 가장 간단한 코드는 다음과 같다.
```swift
smartAdAward = SmartAdAward(self, googleID: "XXXXX", facebookID: nil)
smartAdAward?.showAd()
```

보상광고의 결과값을 얻기 위해서 다음과 같은 루틴이 필요하다.
```swift
extension ViewController: SmartAdAwardDelegate {
    func smartAdAwardDone(_ isAward: Bool) {
        if isAward {
            // 광고창이 닫히고 보상이 완료됨
        } else {
            // 광고창이 닫히고 보상이 취소됨
        }
    }
    
    func smartAdAwardFail(_ error: Error?) {
        // 마지막으로 로딩을 시도한 광고의 에러 메세지
    }
}
```

## 얼럿 광고 (SmartAdAlertController)

기본적인 알림 얼럿은 다음과 같고 기본 높이 값은 250 이며 상황에 맞게 설정해야 광고가 표시된다.
```swift
SmartAdAlertController.cirfirm(self, title: "title", googleID: "XXXXX", facebookID: "XXXXX") { (isOK) in
    if isOK {
        self.disconnectHost()
    }
}
```

## 테스트 장비 추가
```swift
SmartAd.addTestDevice(type: .google, ids: [kGADSimulatorID,"XXXXX"])
SmartAd.addTestDevice(type: .facebook, ids: ["XXXXX","YYYYY"])
```

## 광고 호출 커스텀 함수 등록
SmartAd 의 모든 광고 모듈은 광고를 표시하기 전에 SmartAd.IsShowAdFunc 를 참조한다. IsShowAdFunc 는 기본적으로 null 이므로
모든 광고가 표기되는데 인앱 결제나 특정 상황에서 광고를 중단 시키기 위해서 이 함수를 다음과 같이 커스터마이징 하면 광고 호출을 손쉽게 제어 할 수 있다.
```swift
SmartAd.IsShowAdFunc = { () in
    // --- 사용자가 임의로 작성함 ---
    let def = UserDefaults.standard
    let isShowAd def.bool(forKey: "isShowAd")
    return ([SmartAdBanner.self, SmartAdInterstitial.self, SmartAdAward.self, SmartAdAlertController.self], isShowAd)
    // --- 사용자가 임의로 작성함 ---
}
```



# License
```code
The MIT License

Copyright (c) 2009-2017 ShockUtility.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
