[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-iOS-green.svg)](https://developer.apple.com/swift)
[![GitHub release](https://img.shields.io/github/release/ShockUtility/SmartAdForSwift.svg)](https://github.com/ShockUtility/SmartAdForSwift)
[![English](https://github.com/ShockUtility/SmartAdForSwift/blob/master/res/en.png?raw=true)](https://github.com/ShockUtility/SmartAdForSwift)
[![Korea](https://github.com/ShockUtility/SmartAdForSwift/blob/master/res/kr.png?raw=true)](https://github.com/ShockUtility/SmartAdForSwift/blob/master/README_kr.md)
[![Japan](https://github.com/ShockUtility/SmartAdForSwift/blob/master/res/jp.png?raw=true)](https://github.com/ShockUtility/SmartAdForSwift/blob/master/README_jp.md)



# SmartAd 紹介
SmartAdはiOSとAndroidでAdMobとAudience Networkの広告フレームワークを簡単に使用するためのライブラリです。

- [SmartAd for Swift](https://github.com/ShockUtility/SmartAdForSwift) -> [Demo Project](https://github.com/ShockUtility/SmartAdDemoForSwift)
- [SmartAd for Android](https://github.com/ShockUtility/SmartAdForAndroid)) -> [Demo Project](https://github.com/ShockUtility/SmartAdDemoForAndroid)



# インストール
```code
Sourceフォルダのファイルを開発中のプロジェクトに直接追加して使用します。
```



# 依存性
```code
  pod 'Google-Mobile-Ads-SDK'
  pod 'FBAudienceNetwork'
  pod 'ShockExtension'  
```



# 開発環境
- XCode 9.0
- Swift4
- Google-Mobile-Ads-SDK (7.23.0)
- FBAudienceNetwork (4.25.0)
- ShockExtension (0.7.3)



# サポートされている広告フォーマット
## Google AdMob
- AdView
- InterstitialAd
- RewardedVideoAd

## Facebook Audience Network
- AdView
- InterstitialAd
- RewardedVideoAd



# 使い方

## SmartAdBanner
![Screenshot](https://github.com/ShockUtility/SmartAdForSwift/blob/master/res/screen_01.png?raw=true)<br>
StoryBoardでビューを追加して、カスタムビューを「SmartAdBanner」に変更した後プロパティのみ設定するコードなしですぐに動作します。<br>
戻り値を返す受けたい場合には、delegateを設定して、次のようにSmartAdBannerDelegateを実装する。
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

`* 注意：isAutoHeight値が適用されるためには、SmartAdBannerのオートレイアウトにHeight値が指定されている。各プラットフォームの広告の読み込みが終了すると、広告のサイズに合わせてHeightの値が変更され失敗した場合は、0に設定されて画面に表示されません。 `
<br>
`* 注意：SmartAdBannerはサイズ形式に応じて、少なくとも幅が300または320より大きく正常に表示されます。`

## SmartAdInterstitial
前面広告呼び出すサンプルコードは、以下の通りである。
```swift
var interstitialAd: SmartAdInterstitial?

override func viewDidLoad() {
	super.viewDidLoad()
    
	interstitialAd = SmartAdInterstitial(self, adOrder: .random,
                                         googleID: "googleID", facebookID: "facebookID")
	interstitialAd?.loadAd()
}

```

結果の値を返す必要する場合は、コントローラにSmartAdInterstitialDelegateを実装
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
 
SmartAdInterstitialクラスの関数
```swift
public convenience init(_ controller: UIViewController, adOrder: SmartAdOrder,
                        googleID: String?, facebookID: String?, isShowAfterLoad: Bool = true)
public convenience init(_ controller: UIViewController, adOrder: SmartAdOrder,
                        googleID: String?, facebookID: String?)
public func loadAd(delayMilliseconds: Double = 0.0)
public func showAd() -> Bool
```

## SmartAdAward
補償広告呼び出すサンプルコードは、以下の通りである。
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

結果の値を返す必要する場合は、コントローラにSmartAdAwardDelegateを実装
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

SmartAdAwardクラスの関数
```swift
public convenience init(_ controller: UIViewController, adOrder: SmartAdOrder,
                        googleID: String?, facebookID: String?)
public func showAd()
```

## SmartAdAlertController

OKボタンだけあるアラート
```swift
SmartAdAlertController.alert(self,
                            adOrder: .random,
                            googleID: "googleID",
                            facebookID: "facebookID",
                            title: "Alert") { (_) in
   // Clicked OK
}
```

確認/キャンセルアラート
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

カスタムアラート
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

## 試験装置を追加
```swift
SmartAd.addTestDevice(type: .google, ids: [kGADSimulatorID, "XXXXX"])
SmartAd.addTestDevice(type: .facebook, ids: ["XXXXX","YYYYY"])
```

## 広告呼び出しカスタム関数の登録
SmartAdのすべての広告モジュールは、広告を表示する前にSmartAd.IsShowAdFuncを参照する。
IsShowAdFuncは基本的にnullであるため、 すべての広告が表記されアプリ内課金や特定の状況では、広告を停止しさせるために、
この関数を次のようにカスタマイズすると、すべての広告の呼び出しを 簡単にブロックすることができる。
```swift
SmartAd.IsShowAdFunc = { () in
    //ユーザーの状況に合わせて内容をカスタマイズすればよい。
    //以下の場合SmartAdAwardを除くすべての広告のクラスに適用した例である。
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
