[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-iOS-green.svg)](https://developer.apple.com/swift)
[![GitHub release](https://img.shields.io/github/release/ShockUtility/SmartAdForSwift.svg)](https://github.com/ShockUtility/SmartAdForSwift)
[![English](https://github.com/ShockUtility/SmartAdForSwift/blob/master/res/en.png?raw=true)](https://github.com/ShockUtility/SmartAdForSwift)
[![Korea](https://github.com/ShockUtility/SmartAdForSwift/blob/master/res/kr.png?raw=true)](https://github.com/ShockUtility/SmartAdForSwift/blob/master/README_kr.md)
[![Japan](https://github.com/ShockUtility/SmartAdForSwift/blob/master/res/jp.png?raw=true)](https://github.com/ShockUtility/SmartAdForSwift/blob/master/README_jp.md)



# SmartAd
SmartAd is an easy-to-use library for AdMob and Audience Network advertising frameworks on iOS and Android.

- [SmartAd for Swift](https://github.com/ShockUtility/SmartAdForSwift) -> [Demo Project](https://github.com/ShockUtility/SmartAdDemoForSwift)
- [SmartAd for Android](https://github.com/ShockUtility/SmartAdForAndroid)) -> [Demo Project](https://github.com/ShockUtility/SmartAdDemoForAndroid)



# Install
```code
You need to add the files in the Source folder directly to the project you are developing.
```



# Dependencies
```code
  pod 'Google-Mobile-Ads-SDK'
  pod 'FBAudienceNetwork'
  pod 'ShockExtension'  
```



# Development environment
- XCode 9.0
- Swift4
- Google-Mobile-Ads-SDK (7.23.0)
- FBAudienceNetwork (4.25.0)
- ShockExtension (0.7.3)



# Supported ad formats
## Google AdMob
- AdView
- InterstitialAd
- RewardedVideoAd

## Facebook Audience Network
- AdView
- InterstitialAd
- RewardedVideoAd



# Usage

## SmartAdBanner
![Screenshot](https://github.com/ShockUtility/SmartAdForSwift/blob/master/res/screen_01.png?raw=true)<br>
If you add a view in the StoryBoard, change the custom view to 'SmartAdBanner' and then set the properties only, it will work without coding. <br>
If you want to return a return value, set the delegate and implement SmartAdBannerDelegate as follows.
```swift
extension ViewController: SmartAdBannerDelegate {
    func smartAdBannerDone(_ view: SmartAdBanner) {
        // Success...
    }

    func smartAdBannerFail(_ error: Error?) {
        // Fail...
    }
}
```

`* Note: In order for the isAutoHeight value to be applied, the Height value must be assigned to the AutoAdBanner's Auto Layout. When the advertisement of each platform is loaded, the Height value is corrected according to the advertisement size. If it fails, the value is set to 0 and it is not displayed on the screen. `
<br>
`* Note: The SmartAdBanner will display normally if the minimum width is greater than 300 or 320, depending on the size format.`

## SmartAdInterstitial
Here is the example code that calls the interstitial.
```swift
var interstitialAd: SmartAdInterstitial?

override func viewDidLoad() {
    super.viewDidLoad()
    
    interstitialAd = SmartAdInterstitial(self, adOrder: .random,
                                         googleID: "googleID", facebookID: "facebookID")
	interstitialAd?.loadAd()
}

```

Use SmartAdInterstitialDelegate if you want to return the result.
```swift
extension ViewController: SmartAdInterstitialDelegate {
    func smartAdInterstitialDone() {
        // Success...
    }
    
    func smartAdInterstitialFail(_ error: Error?) {
        // Fail...
    }
}
```
 
Functions of the SmartAdInterstitial class
```swift
public convenience init(_ controller: UIViewController, adOrder: SmartAdOrder,
                        googleID: String?, facebookID: String?, isShowAfterLoad: Bool = true)
public convenience init(_ controller: UIViewController, adOrder: SmartAdOrder,
                        googleID: String?, facebookID: String?)
public func loadAd(delayMilliseconds: Double = 0.0)
public func showAd() -> Bool
```

## SmartAdAward
Here is the example code that calls the award ad.
```swift
var awardAd: SmartAdAward?

override func viewDidLoad() {
    super.viewDidLoad()

    awardAd = SmartAdAward.init(self, adOrder: .google,
                                googleID: "googleID",
                                facebookID: "facebookID")
    awardAd?.showAd()
}
```

Use SmartAdAwardDelegate if you want to return the result.
```swift
extension ViewController: SmartAdAwardDelegate {
    func smartAdAwardDone(_ isGoogle: Bool, _ isAwardShow: Bool, _ isAwardClick: Bool) {
        // Success...
    }
    
    func smartAdAwardFail(_ error: Error?) {
        // Fail...
    }
}
```

Functions of the SmartAdAward class
 ```swift
public convenience init(_ controller: UIViewController, adOrder: SmartAdOrder,
                        googleID: String?, facebookID: String?)
public func showAd()
```

## SmartAdAlertController

Alert with OK button only.
```swift
SmartAdAlertController.alert(self,
                            adOrder: .random,
                            googleID: "googleID",
                            facebookID: "facebookID",
                            title: "Alert") { (_) in
   // Clicked OK
}
```

Alert with OK & Cancel.
```swift
SmartAdAlertController.confirm(self,
                               adOrder: .google,
                               googleID: "googleID",
                               facebookID: "facebookID",
                               title: "Confirm") { (isOK) in
   if isOK {
       // Clicked OK
   } else {
       // Clicked Cancel
   }
}
```

Customizing Alert.
```swift
SmartAdAlertController.select(self,
                              adOrder: .facebook,
                              googleID: "googleID",
                              facebookID: "facebookID",
                              title: "Select",
                              titleOK: "Yes",
                              titleCancel: "No") { (isOK) in
   if isOK {
       // Clicked Yes
   } else {
       // Clicked No
   }
}
```

## Add test device
```swift
SmartAd.addTestDevice(type: .google, ids: [kGADSimulatorID, "XXXXX"])
SmartAd.addTestDevice(type: .facebook, ids: ["XXXXX","YYYYY"])
```

## Register the ad activation function
You can register and use this function to stop ads in-app billing or under certain circumstances.
```swift
SmartAd.IsShowAdFunc = { () in
    // You can customize the content to suit your situation.
    // Here's an example that applies to all ad classes except SmartAdAward.
    let def = UserDefaults.standard
    let isShowAd = def.bool(forKey: "isShowAd")
    return ([SmartAdBanner.self, SmartAdInterstitial.self, SmartAdAlertController.self], isShowAd)
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
