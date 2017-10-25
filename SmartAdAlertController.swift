//
//  SmartAdAlertController.swift
//  SmartAd
//
//  Created by shock on 2017. 10. 23..
//  Copyright © 2017년 shock. All rights reserved.
//

import UIKit

open class SmartAdAlertController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var smartAdBanner: SmartAdBanner!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var vwLoading: UIActivityIndicatorView!
    @IBOutlet weak var widthOK: NSLayoutConstraint!
    
    
    fileprivate var completedCallback: ((_ isOK: Bool) -> Void)?
    fileprivate var adHeight: CGFloat = 250.0
    fileprivate var alertButtonDelayMilliseconds: Double = 3.0
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        lblTitle.text = self.title
        
        if SmartAd.IsShowAd(self) {
            self.vwLoading.isHidden = false
            var hasConstraintHeight = false
            if let constraint = (smartAdBanner.constraints.filter{$0.firstAttribute == .height}.first) {
                hasConstraintHeight = true
                constraint.constant = adHeight
            }
            if !hasConstraintHeight { // Auto Layout 에 Height 값이 없다면
                let r = smartAdBanner.frame
                smartAdBanner.frame = CGRect(x:r.origin.x , y: r.origin.y, width: r.width, height: adHeight)
            }
            
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
    
    open func setAlertButtonDelayMilliseconds(_ milliseconds: Double) {
        alertButtonDelayMilliseconds = milliseconds
    }
    
    class func alert(_ controller: UIViewController,
                     title: String,
                     googleID: String?, facebookID: String?,
                     isGoogleFirst: Bool = true,
                     completed: @escaping (_ isOK: Bool) -> Void)
    {
        let alert = SmartAdAlertController()
        alert.title = title
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        
        controller.present(alert, animated: true) {
            alert.widthOK.constant = 300
            alert.btnOK.setTitle("OK".localized, for: .normal)
            alert.btnOK.isHidden = false
            
            if SmartAd.IsShowAd(self) {
                alert.smartAdBanner.isRandomAD   = true
                alert.smartAdBanner.googleAdID   = googleID
                alert.smartAdBanner.facebookAdID = facebookID
                alert.smartAdBanner.showAd()
            } else {
                alert.btnOK.isEnabled = true
            }
        }
        
        alert.completedCallback = completed
    }
    
    class func confirm(_ controller: UIViewController,
                       title: String,
                       googleID: String?, facebookID: String?,
                       isGoogleFirst: Bool = true,
                       completed: @escaping (_ isOK: Bool) -> Void)
    {
        let alert = SmartAdAlertController()
        alert.title = title
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        
        controller.present(alert, animated: true) {
            alert.btnOK.setTitle("OK".localized, for: .normal)
            alert.btnCancel.setTitle("Cancel".localized, for: .normal)
            alert.btnOK.isHidden = false
            alert.btnCancel.isHidden = false
            
            if SmartAd.IsShowAd(self) {
                alert.smartAdBanner.isRandomAD   = true
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
    
    class func select(_ controller: UIViewController,
                      title: String,
                      titleOK: String, titleCancel: String,
                      googleID: String?, facebookID: String?,
                      isGoogleFirst: Bool = true,
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
                alert.smartAdBanner.isRandomAD   = true
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
        btnOK.isEnabled = true
        btnCancel.isEnabled = true
        vwLoading.isHidden = true
    }
}





