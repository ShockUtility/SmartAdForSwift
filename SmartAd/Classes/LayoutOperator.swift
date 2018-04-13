//
//  AutoLayoutOperator.swift
//  Pods
//
//  Created by shock on 2017. 5. 10..
//
//

import UIKit

precedencegroup LayoutPrecedence {
    associativity: left
    higherThan: BitwiseShiftPrecedence
}

// 좌측 뷰에 우측 뷰를 넣어주고 페이딩을 적용시킨다
infix operator <<== : LayoutPrecedence

public func <<==(superView: UIView, subView: UIView) {
    superView <<== (subView, 0, 0, 0, 0)
}

public func <<==(superView: UIView, rhs:(UIView, CGFloat)) {
    superView <<== (rhs.0, rhs.1, rhs.1, rhs.1, rhs.1)
}

public func <<==(superView: UIView, rhs:(UIView, CGFloat, CGFloat, CGFloat, CGFloat)) { // left, right, top, bottom
    superView.addSubview(rhs.0)
    rhs.0 |-| (left:rhs.1, right:rhs.2, top:rhs.3, bottom:rhs.4)
}

// 뷰애 페이딩을 적용시킨다
infix operator |-| : LayoutPrecedence

public func |-|(view: UIView, rhs:(CGFloat, CGFloat, CGFloat, CGFloat)) {
    view |-| (left: rhs.0, right: rhs.1)
    view |-| (top: rhs.2, bottom: rhs.3)
}

public func |-|(view: UIView, rhs:(left:CGFloat, right:CGFloat)) {
    if let superView = view.superview {
        superView |-| (format: "H:|-\(rhs.left)-[view0]-\(rhs.right)-|", views: [view])
    }
}

public func |-|(view: UIView, rhs:(top:CGFloat, bottom:CGFloat)) {
    if let superView = view.superview {
        superView |-| (format: "V:|-\(rhs.top)-[view0]-\(rhs.bottom)-|", views: [view])
    }
}

public func |-|(view: UIView, rhs:(format:String, views:[Any])) {
    let views = rhs.views.reduce([String: Any]()) { (arr, view) in
        if let v = view as? UIView {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        var totalMutable = arr
        totalMutable.updateValue(view, forKey: "view"+String(arr.count))
        return totalMutable
    }
    
    view.addConstraints(NSLayoutConstraint.constraints(
        withVisualFormat: rhs.format,
        options: NSLayoutFormatOptions(rawValue: 0),
        metrics: nil,
        views: views))
}

