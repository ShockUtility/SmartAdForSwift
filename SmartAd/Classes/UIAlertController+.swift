//
//  UIAlertController+ex.swift
//  RSSAgent
//
//  Created by shock on 2017. 4. 14..
//  Copyright © 2017년 shock. All rights reserved.
//

import Foundation
import UIKit

public extension UIAlertController {    
    // 로딩 얼럿
    @discardableResult
    class func ad_loading(_ controller: UIViewController,
                       loadingStyle: UIActivityIndicatorViewStyle,
                       title: String? = NSLocalizedString("Loading", comment: ""),
                       completed: ((_ alert: UIAlertController) -> Void)?) -> UIAlertController
    {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addLoadingView(loadingStyle: loadingStyle)
        
        controller.present(alert, animated: true) {
            if completed != nil {
                completed!(alert)
            }
        }
        
        return alert
    }
    
    // 로딩 뷰를 추가해 준다
    fileprivate func addLoadingView(loadingStyle: UIActivityIndicatorViewStyle, viewHeight:CGFloat = 100, yPositon:CGFloat = 1.4) {
        // 얼럿 높이 수정
        let height: NSLayoutConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.height,
                                                            relatedBy: NSLayoutRelation.equal,
                                                            toItem: nil, attribute: NSLayoutAttribute.notAnAttribute,
                                                            multiplier: 1, constant: viewHeight)
        self.view.addConstraint(height)
        
        // 인디케이터 추가
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: loadingStyle)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.tag = 999
        self.view.addSubview(activityIndicator)
        
        let xConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal,
                                             toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal,
                                             toItem: self.view, attribute: .centerY, multiplier: yPositon, constant: 0)
        NSLayoutConstraint.activate([ xConstraint, yConstraint])
        activityIndicator.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }
}




