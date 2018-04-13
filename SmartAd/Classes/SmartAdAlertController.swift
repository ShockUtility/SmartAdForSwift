//
//  SmartAdAlertController.swift
//  SmartAd
//
//  Created by shock on 2017. 10. 23..
//  Copyright © 2017년 shock. All rights reserved.
//

import UIKit

public class SmartAdAlertController: UIViewController {
    
    @IBOutlet weak var vwRoot: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var smartAdBanner: SmartAdBanner!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var vwLoading: UIActivityIndicatorView!
    @IBOutlet weak var widthOK: NSLayoutConstraint!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    
    var completedCallback: ((_ isOK: Bool) -> Void)?
    var alertButtonDelayMilliseconds: Double = 3.0
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        let path = Bundle(for: SmartAdAlertController.self).path(forResource: "SmartAd", ofType: "bundle") // 팟에 있는 번들 읽어 들이려면 피곤...
        super.init(nibName: "SmartAdAlertController", bundle: Bundle(path: path!))
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        vwRoot.layer.masksToBounds = true
        vwRoot.layer.cornerRadius = 7.0
        
        lblTitle.text = self.title
        
        if SmartAd.IsShowAd(self) {
            self.vwLoading.isHidden = false
            bannerHeight.constant = 250
            
            // 로딩이 길어지거나 에러가 캐치되지 않을 경우 일정 시간 후 버튼을 활성화 시킨다.
            DispatchQueue.main.asyncAfter(deadline: .now() + alertButtonDelayMilliseconds) {
                self.btnOK.isEnabled = true
                self.btnCancel.isEnabled = true
            }
        }
    }
    
    @IBAction func onClickOK(_ sender: Any) {
        dismiss(animated: true) {
            self.completedCallback?(true)
        }
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        dismiss(animated: true) {
            self.completedCallback?(false)
        }
    }
    
    public func setAlertButtonDelayMilliseconds(_ milliseconds: Double) {
        alertButtonDelayMilliseconds = milliseconds
    }
    
    public class func alert(_ controller: UIViewController,
                            adOrder: SmartAdOrder,
                            googleID: String?, facebookID: String?,
                            title: String,
                            completed: @escaping (_ isOK: Bool) -> Void)
    {
        let alert = SmartAdAlertController()
        alert.title = title
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        
        controller.present(alert, animated: true) {
            alert.widthOK.constant = 300
            alert.btnOK.setTitle(NSLocalizedString("OK", comment: ""), for: .normal)
            alert.btnOK.isHidden = false
            
            if SmartAd.IsShowAd(self) {
                alert.smartAdBanner.adType       = adOrder.adType
                alert.smartAdBanner.googleAdID   = googleID
                alert.smartAdBanner.facebookAdID = facebookID
                alert.smartAdBanner.showAd()
            } else {
                alert.btnOK.isEnabled = true
            }
        }
        
        alert.completedCallback = completed
    }
    
    public class func confirm(_ controller: UIViewController,
                              adOrder: SmartAdOrder,
                              googleID: String?, facebookID: String?,
                              title: String,
                              completed: @escaping (_ isOK: Bool) -> Void)
    {
        let alert = SmartAdAlertController()
        alert.title = title
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        
        controller.present(alert, animated: true) {
            alert.btnOK.setTitle(NSLocalizedString("OK", comment: ""), for: .normal)
            alert.btnCancel.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
            alert.btnOK.isHidden = false
            alert.btnCancel.isHidden = false
            
            if SmartAd.IsShowAd(self) {
                alert.smartAdBanner.adType       = adOrder.adType
                alert.smartAdBanner.googleAdID   = googleID
                alert.smartAdBanner.facebookAdID = facebookID
                alert.smartAdBanner.showAd()
            } else {
                alert.btnOK.isEnabled = true
                alert.btnCancel.isEnabled = true
            }
        }
        
        alert.completedCallback = completed
    }
    
    public class func select(_ controller: UIViewController,
                             adOrder: SmartAdOrder,
                             googleID: String?, facebookID: String?,
                             title: String,
                             titleOK: String, titleCancel: String,
                             completed: @escaping (_ isOK: Bool) -> Void)
    {
        let alert = SmartAdAlertController()
        alert.title = title
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        
        controller.present(alert, animated: true) {
            alert.btnOK.setTitle(titleOK, for: .normal)
            alert.btnCancel.setTitle(titleCancel, for: .normal)
            alert.btnOK.isHidden = false
            alert.btnCancel.isHidden = false
            
            if SmartAd.IsShowAd(self) {
                alert.smartAdBanner.adType       = adOrder.adType
                alert.smartAdBanner.googleAdID   = googleID
                alert.smartAdBanner.facebookAdID = facebookID
                alert.smartAdBanner.showAd()
            } else {
                alert.btnOK.isEnabled = true
                alert.btnCancel.isEnabled = true
            }
        }
        
        alert.completedCallback = completed
    }
}

extension SmartAdAlertController: SmartAdBannerDelegate {
    public func smartAdBannerDone(_ view: SmartAdBanner) {
        btnOK.isEnabled = true
        btnCancel.isEnabled = true
        vwLoading.isHidden = true
    }
    
    public func smartAdBannerFail(_ error: Error?) {
        bannerHeight.constant = 0
        btnOK.isEnabled = true
        btnCancel.isEnabled = true
        vwLoading.isHidden = true
    }
}





