//
//  ReferVC.swift
//  NSC_iOS
//
//  Created by Mac Mini on 13/05/22.
//

import UIKit

class ReferVC: ClearNaviagtionBarVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblReferralCode: UILabel!
    
    @IBOutlet weak var btnRefer: AppThemeButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    // MARK: - VARIABLES

    var referDataVM = ReferDataViewModel()
    var referCode = ""
    var referLink = ""
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setUpView()
    }
    
    
    // MARK: - FUNCTIONS
    private func setUpView(){
        self.configureUI()
        
        self.apiCallReferData()
    }
    
    private func configureUI(){
        self.scrollView.alpha = 0
        self.title = kReferACoach
        self.lblTitle.applyLabelStyle(fontSize: 18.0, fontName: .SFProDisplaySemibold)
        self.lblSubTitle.applyLabelStyle(fontSize: 12.0, fontName: .SFProDisplayRegular, textColor: .colorAppTxtFieldGray)
        self.lblReferralCode.applyLabelStyle(fontSize: 13.0, fontName: .SFProDisplayBold, textColor: .colorAppThemeOrange)
        
        self.btnRefer.setTitle(kReferACoach, for: .normal)
        
        self.referCode = LoginDataModel.currentUser?.Refer_Code ?? ""
        self.referLink = LoginDataModel.currentUser?.referLink ?? ""
    }
    
    private func setReferData(_ data : JSON) {
        
        debugPrint(data)
        
        self.referCode = data["ReferCode"].stringValue
        self.referLink = data["ReferLink"].stringValue
        
        self.lblReferralCode.text = data["ReferCode"].stringValue
        
        self.lblTitle.attributedText = data["Title"].stringValue.attributedString(alignment: .center, lineSpacing: 5)
        self.lblSubTitle.attributedText = data["Subtitle"].stringValue.attributedString(alignment: .center, lineSpacing: 5)
        

        if self.referCode.trim.count > 0 && self.referLink.trim.count > 0 {
        
            self.btnRefer.isSelect = true
        
        } else {
            
            self.btnRefer.isSelect = false
        }
        
        UIView.animate(withDuration: 1) {
            self.scrollView.alpha = 1
        }
    }

    
    // MARK: - ACTION
    @IBAction func backClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func copyCodeClicked(_ sender: UIButton) {
        if referCode.trim.count == 0 {
        
            GFunctions.shared.showSnackBar(message: kNotAvailableReferAtMoment)
            return
        }
        
        let pasteboard = UIPasteboard.general
        pasteboard.string = referCode
        
        GFunctions.shared.showSnackBar(message: Theme.strings.alert_promo_code_copied)
    }
    
    @IBAction func referClicked(_ sender: UIButton) {
        if referCode.trim.count == 0 || referLink.trim.count == 0 {
    
            GFunctions.shared.showSnackBar(message: kNotAvailableReferAtMoment)
            return
        }
        
        let aVC = AppStoryBoard.main.viewController(viewControllerClass: ContactVC.self)
        aVC.referCode = self.referCode
        aVC.referLink = self.referLink
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
}

//--------------------------------------------------------------------------------
// MARK: - API Calling Methods
//--------------------------------------------------------------------------------
extension ReferVC{
    
    private func apiCallReferData(){
        
        self.referDataVM.callReferDataAPI(completionBlock: { responseJson, statusCode , message , completion in
            if completion, let data = responseJson{
                self.setReferData(data["ResponseData"])
            }
        })
    }
}
