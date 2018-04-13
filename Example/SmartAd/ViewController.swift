//
//  ViewController.swift
//  SmartAd
//
//  Created by ShockUtility on 04/14/2018.
//  Copyright (c) 2018 ShockUtility. All rights reserved.
//

import UIKit
import SmartAd
import GoogleMobileAds

let AD_G_INTERSTITIAL_ID = "ca-app-pub-3940256099942544/4411468910"
let AD_G_AWARD_ID        = "ca-app-pub-3940256099942544/1712485313"
let AD_G_ALERT_ID        = "ca-app-pub-3940256099942544/2934735716"

let AD_FACEBOOK_ID       = "YOUR_PLACEMENT_ID"

class ViewController: UITableViewController {
    
    @IBOutlet weak var swEnableAd: UISwitch!
    @IBOutlet weak var sgAdOrder: UISegmentedControl!
    
    var interstitialAd: SmartAdInterstitial?
    var awardAd: SmartAdAward?
    
    var adOrder: SmartAdOrder {
        return SmartAdOrder(rawValue: sgAdOrder.selectedSegmentIndex) ?? .random
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting Test Device
        SmartAd.addTestDevice(type: .google, ids: [kGADSimulatorID, "8ad81dda0c1e608aad8eddf174ea98b4"])
        SmartAd.addTestDevice(type: .facebook, ids: [])
        
        // Setting Validation Function
        SmartAd.IsShowAdFunc = { () in
            let isShowAd = self.swEnableAd.isOn
            return ([SmartAdBanner.self, SmartAdInterstitial.self, SmartAdAward.self, SmartAdAlertController.self], isShowAd)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 2: // Full Screen
            if indexPath.row == 0 {
                showInterstitial()
            } else if indexPath.row == 1 {
                showAward()
            }
            break
        case 3: // Dialogs
            if indexPath.row == 0 {
                showAlert()
            } else if indexPath.row == 1 {
                showConfirm()
            } else if indexPath.row == 2 {
                showSelect()
            }
            break
        default: break
        }
    }
}

// SmartAdInterstitial

extension ViewController: SmartAdInterstitialDelegate {
    func showInterstitial() {
        interstitialAd = SmartAdInterstitial(self, adOrder: adOrder, googleID: AD_G_INTERSTITIAL_ID, facebookID: AD_FACEBOOK_ID)
        interstitialAd?.loadAd()
    }
    
    func smartAdInterstitialDone() {
        print("smartAdInterstitialDone :")
    }
    
    func smartAdInterstitialFail(_ error: Error?) {
        print("smartAdInterstitialFail :", error ?? "")
    }
}

// SmartAdAward

extension ViewController: SmartAdAwardDelegate {
    func showAward() {
        awardAd = SmartAdAward.init(self, adOrder: adOrder, googleID: AD_G_AWARD_ID, facebookID: AD_FACEBOOK_ID)
        awardAd?.showAd()
    }
    
    func smartAdAwardDone(_ isGoogle: Bool, _ isAwardShow: Bool, _ isAwardClick: Bool) {
        print("smartAdAwardDone : isGoogle =", isGoogle, "isAwardShow =", isAwardShow, "isAwardClick =", isAwardClick)
    }
    
    func smartAdAwardFail(_ error: Error?) {
        print("smartAdAwardFail :", error ?? "")
    }
}

// SmartAdAlertController

extension ViewController {
    func showAlert() {
        SmartAdAlertController.alert(self, adOrder: adOrder, googleID: AD_G_ALERT_ID, facebookID: AD_FACEBOOK_ID,
                                     title: "Alert") { (_) in
            print("Complated : SmartAdAlertController.alert")
        }
    }
    
    func showConfirm() {
        SmartAdAlertController.confirm(self, adOrder: adOrder, googleID: AD_G_ALERT_ID, facebookID: AD_FACEBOOK_ID,
                                       title: "Confirm") { (isOK) in
            if isOK {
                print("Complated : SmartAdAlertController.confirm [OK]")
            } else {
                print("Complated : SmartAdAlertController.confirm [Cancel]")
            }
        }
    }
    
    func showSelect() {
        SmartAdAlertController.select(self, adOrder: adOrder, googleID: AD_G_ALERT_ID, facebookID: AD_FACEBOOK_ID,
                                      title: "Select", titleOK: "Yes", titleCancel: "No") { (isOK) in
            if isOK {
                print("Complated : SmartAdAlertController.select [Yes]")
            } else {
                print("Complated : SmartAdAlertController.select [No]")
            }
        }
    }
}




