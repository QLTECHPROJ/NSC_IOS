//
//  ReferVC.swift
//  NSC_iOS
//
//  Created by Mac Mini on 13/05/22.
//

import UIKit

class ReferVC: BaseViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblReferralCode: UILabel!
    
    @IBOutlet weak var btnRefer: UIButton!
    @IBOutlet weak var viewRefer: UIView!
    
    
    // MARK: - VARIABLES
    var referCode = ""
    var referLink = ""
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        referCode = LoginDataModel.currentUser?.Refer_Code ?? ""
        referLink = LoginDataModel.currentUser?.referLink ?? ""
        
        setupUI()
    }
    
    override func setupUI() {
        lblReferralCode.text = referCode
        
        if referCode.trim.count > 0 && referLink.trim.count > 0 {
            btnRefer.isUserInteractionEnabled = true
            btnRefer.backgroundColor = Theme.colors.theme_dark
        } else {
            btnRefer.isUserInteractionEnabled = false
            btnRefer.backgroundColor = Theme.colors.gray_7E7E7E
        }
        
        viewRefer.addDashedBorder()
    }
    
    // MARK: - ACTION
    @IBAction func backClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func copyCodeClicked(_ sender: UIButton) {
        if referCode.trim.count == 0 {
            showAlertToast(message: "Not available at the moment. Please contact support.")
            return
        }
        
        let pasteboard = UIPasteboard.general
        pasteboard.string = referCode
        showAlertToast(message: "Referral code copied")
    }
    
    @IBAction func referClicked(_ sender: UIButton) {
        if referCode.trim.count == 0 || referLink.trim.count == 0 {
            showAlertToast(message: "Not available at the moment. Please contact support.")
            return
        }
        
        let aVC = AppStoryBoard.main.viewController(viewControllerClass: ContactVC.self)
        aVC.referCode = self.referCode
        aVC.referLink = self.referLink
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
}
