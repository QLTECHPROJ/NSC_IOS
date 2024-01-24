//
//  SignUpVC.swift
//  NSC_iOS
//
//  Created by Dhruvit on 23/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpVC: ClearNaviagtionBarVC {
    
    // MARK: - OUTLETS
    //UITextfield
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtFName: UITextField!
    @IBOutlet weak var txtLName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPromoCode: UITextField!
    
    //UILabel
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPhoneNo: UILabel!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblEmailAddress: UILabel!
    @IBOutlet weak var lblPromoCode: UILabel!
    @IBOutlet weak var lblPrivacyTermCondition: UILabel!
    
    //UIImageView
    @IBOutlet weak var imgFlag: UIImageView!
    
    //UIButton
    
    @IBOutlet weak var btnGetSMSCode: AppThemeButton!
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var btnApply: UIButton!
    
    
    // MARK: - VARIABLES
    var loginCheckVM = LoginCheckViewModel()
    
    var mobileNoDidChange : ((String?) -> Void)?
    
    var isFromOTP = false
    var isCountrySelected = false
    var strMobile:String?
    var promoCode = ""
    
    
    deinit{
        self.removeClassObservers()
    }
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFromOTP {
            txtMobile.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    
    // MARK: - FUNCTIONS
    private func setUpView(){
        self.addClassObservers()
        self.configureUI()
        self.btnEnableDisable()
    }
    
    private func configureUI(){
        self.lblTitle.applyLabelStyle(text: kSignUp, fontSize: 28.0, fontName: .SFProDisplayBold)
        
        self.lblPhoneNo.applyLabelStyle(text: kMobileNumber, fontSize: 13.0, fontName: .SFProDisplayRegular, textColor : .colorAppTxtFieldGray)
        self.lblFirstName.applyLabelStyle(text: kFirstName, fontSize: 13.0, fontName: .SFProDisplayRegular, textColor : .colorAppTxtFieldGray)
        self.lblLastName.applyLabelStyle(text: kLastName, fontSize: 13.0, fontName: .SFProDisplayRegular, textColor : .colorAppTxtFieldGray)
        self.lblEmailAddress.applyLabelStyle(text: kEmailAddress, fontSize: 13.0, fontName: .SFProDisplayRegular, textColor : .colorAppTxtFieldGray)
        self.lblPromoCode.applyLabelStyle(text: kPromoCode, fontSize: 13.0, fontName: .SFProDisplayRegular, textColor : .colorAppTxtFieldGray)
        
        self.txtCountryCode.applyStyleTextField(fontsize: 13.0, fontname: .SFProDisplayMedium)
       
        self.txtCountryCode.text = "\(JSON(AppVersionDetails.countryShortName as Any).stringValue) +\(JSON(AppVersionDetails.countryCode as Any).stringValue)"
        self.imgFlag.sd_setImage(with: JSON(AppVersionDetails.countryIcon as Any).stringValue.url(), placeholderImage: nil, context: nil)
        
        self.txtMobile.applyStyleTextField(placeholder : "", fontsize: 13.0, fontname: .SFProDisplayMedium)
        self.txtFName.applyStyleTextField(placeholder : "", fontsize: 13.0, fontname: .SFProDisplayMedium)
        self.txtLName.applyStyleTextField(placeholder : "", fontsize: 13.0, fontname: .SFProDisplayMedium)
        self.txtEmail.applyStyleTextField(placeholder : "", fontsize: 13.0, fontname: .SFProDisplayMedium)
        self.txtPromoCode.applyStyleTextField(placeholder : "", fontsize: 13.0, fontname: .SFProDisplayMedium)
        
        self.btnApply.applystyle(fontname: .SFProDisplayBold, fontsize: 11.0, titleText: kApply, titleColor: .colorAppDarkGray)
        self.btnGetSMSCode.setTitle(kGetOTP, for: .normal)
        
        let defaultFontAttribute = [NSAttributedString.Key.foregroundColor: UIColor.colorAppDarkGray ,NSAttributedString.Key.font: UIFont.applyCustomFont(fontName: .SFProDisplayRegular, fontSize: 11.0)]
        let blueFontAttribute = [NSAttributedString.Key.foregroundColor: UIColor.colorAppDarkGray,NSAttributedString.Key.font: UIFont.applyCustomFont(fontName: .SFProDisplayRegular, fontSize: 11.0),NSAttributedString.Key.underlineColor: UIColor.colorAppDarkGray, NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
    
        self.lblPrivacyTermCondition.text = kByClickingOnGetOTPYouAgreeToOurTCsPrivacyPolicy
        self.lblPrivacyTermCondition.attributedText = (self.lblPrivacyTermCondition.text)?.getAttributedText(defaultDic: defaultFontAttribute, attributeDic: blueFontAttribute, attributedStrings: [kTCs,kPrivacyPolicy])
        
        self.lblPrivacyTermCondition.lineSpacing(lineSpacing: 10.0, alignment: self.lblPrivacyTermCondition.textAlignment)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.lblTCsPrivacyPolicyTapped(_:)))
        self.lblPrivacyTermCondition.isUserInteractionEnabled = true
        self.lblPrivacyTermCondition.addGestureRecognizer(tap)
        
        if strMobile != "" {
            txtMobile.text = strMobile
        }
    }
    
    private func btnEnableDisable() {
        
        if self.txtMobile.text!.trim.isEmpty || self.txtFName.text!.trim.isEmpty || self.txtLName.text!.trim.isEmpty || self.txtEmail.text!.trim.isEmpty{
            
            self.btnGetSMSCode.isSelect = false
        }
        else{
            self.btnGetSMSCode.isSelect = true
        }
    
        if self.txtMobile.text!.trim.isEmpty{
            
            self.btnApply.setTitleColor(.colorAppDarkGray, for: .normal)
        }
        else{
            
            self.btnApply.setTitleColor(.colorAppThemeOrange, for: .normal)
        }
        
        DispatchQueue.main.async {
            if self.txtPromoCode.text?.trim.count == 0 {
                self.btnApply.isUserInteractionEnabled = false
                self.btnApply.setTitleColor(Theme.colors.gray_7E7E7E, for: .normal)
            } else {
                self.btnApply.isUserInteractionEnabled = true
                self.btnApply.setTitleColor(.colorAppThemeOrange, for: .normal)
            }
        }
    }
    
    func checkValidation() -> Bool {
        self.view.endEditing(true)
        var isValid = true
        let strMobile = txtMobile.text?.trim ?? ""
        
        if txtFName.text?.trim.count == 0 {
           
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_blank_firstname_error)
        }
        
        if txtLName.text?.trim.count == 0 {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_blank_lastname_error)
        
        }
        
        if strMobile.count == 0 {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_invalid_mobile_error)
            
        } else if strMobile.count < AppVersionDetails.mobileMinDigits || strMobile.count > AppVersionDetails.mobileMaxDigits {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_invalid_mobile_error)
            
        } else if strMobile.isPhoneNumber == false {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_invalid_mobile_error)
        }
        
        if txtEmail.text?.trim.count == 0 {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_invalid_email_error)
            
        } else if !txtEmail.text!.isValidEmail {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_invalid_email_error)
        }
        
        return isValid
    }
   
    
    func sendOTP() {
        // showHud()
        self.view.isUserInteractionEnabled = false
        
        let phoneString = "+" + AppVersionDetails.countryCode + (txtMobile.text ?? "")
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneString, uiDelegate: nil) { verificationID, error in
            
            // hideHud()
            self.view.isUserInteractionEnabled = true
            
            if let error = error {
                if error.localizedDescription.contains(string: "The format of the phone number provided is incorrect.") {
                    
                    GFunctions.shared.showSnackBar(message: Theme.strings.alert_invalid_mobile_error)
                }else {
                    
                    GFunctions.shared.showSnackBar(message: error.localizedDescription)
                }
                return
            }
        
            GFunctions.shared.showSnackBar(message: Theme.strings.sms_sent)
            
            // Sign in using the verificationID and the code sent to the user
            authVerificationID = verificationID ?? ""
            
            let aVC = AppStoryBoard.main.viewController(viewControllerClass:OTPVC.self)
            aVC.strMobile = self.txtMobile.text ?? ""
            aVC.strFName = self.txtFName.text ?? ""
            aVC.strLName = self.txtLName.text ?? ""
            aVC.strEmail = self.txtEmail.text ?? ""
            aVC.strPromoCode = self.txtPromoCode.text ?? ""
            aVC.isFromSignUp = true
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
    func checkLogin() {
        let parameters = ["mobile":txtMobile.text ?? "",
                          "countryCode":AppVersionDetails.countryCode]
        
        self.loginCheckVM.callLoginCheckAPI(parameters: parameters, completion: { success in
            if success {
                
                if self.loginCheckVM.loginFlag == "0" {
                    
                    self.sendOTP()
               
                } else {
                    if self.strMobile != self.txtMobile.text {
                        
                        self.mobileNoDidChange?(self.txtMobile.text)
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })
    }
    
    
    // MARK: - ACTIONS
    
    @objc func lblTCsPrivacyPolicyTapped(_ tapGesture : UITapGestureRecognizer) {
        self.view.endEditing(true)
        if tapGesture.didTapAttributedTextInLabel(label: self.lblPrivacyTermCondition, inRange: (self.lblPrivacyTermCondition.attributedText!.string as NSString).range(of: kTCs)) {
            
            let aVC = AppStoryBoard.main.viewController(viewControllerClass:WebViewVC.self)
            aVC.urlType = .termsNcondition
            self.navigationController?.pushViewController(aVC, animated: true)
           
        }
        
        if tapGesture.didTapAttributedTextInLabel(label: self.lblPrivacyTermCondition, inRange: (self.lblPrivacyTermCondition.attributedText!.string as NSString).range(of: kPrivacyPolicy)) {
            
            let aVC = AppStoryBoard.main.viewController(viewControllerClass:WebViewVC.self)
            aVC.urlType = .privacyPolicy
            self.navigationController?.pushViewController(aVC, animated: true)
           
        }
    }
    
    @IBAction func backClicked(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func applyClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if (txtPromoCode.text?.trim.count ?? 0) == 5 {
            let verifyReferCodeVM = VerifyReferCodeViewModel()
            verifyReferCodeVM.callVerifyReferCodeAPI(referCode: txtPromoCode.text ?? "") { success in
                if success {
                    print("promocode applied")
                    self.promoCode = self.txtPromoCode.text ?? ""
                }
            }
        } else {
        
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_invalid_promocode_error)
        }
    }
    
    @IBAction func signUpClicked(_ sender: UIButton) {
        
        if checkValidation() {
           
            isFromOTP = true
            
            if (txtPromoCode.text?.trim.count ?? 0) > 0 {
                if promoCode == txtPromoCode.text {
                    self.checkLogin()
                } else {
                    let verifyReferCodeVM = VerifyReferCodeViewModel()
                    verifyReferCodeVM.callVerifyReferCodeAPI(referCode: txtPromoCode.text ?? "") { success in
                        if success {
                            print("promocode applied")
                            self.promoCode = self.txtPromoCode.text ?? ""
                            self.checkLogin()
                        }
                    }
                }
            } else {
                self.checkLogin()
            }
        }
    }
    
}


// MARK: - UITextFieldDelegate
extension SignUpVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtFName {
            
            self.txtLName.becomeFirstResponder()
            
        } else if textField == self.txtLName {
            
            self.txtEmail.becomeFirstResponder()
        }
        else if textField == self.txtEmail {
            
            self.txtPromoCode.becomeFirstResponder()
        }
        else if textField == self.txtPromoCode {
            
            textField.resignFirstResponder()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text, let textRange = Range(range, in: text) else {
            return false
        }
        
        let updatedText = text.replacingCharacters(in: textRange, with: string)
        
        if textField == txtFName || textField == txtLName {
            if updatedText.count > 16 {
                return false
            }
        } else if textField == txtMobile {
            if !updatedText.isNumber || updatedText.count > AppVersionDetails.mobileMaxDigits {
                return false
            }
        } else if textField == txtPromoCode && updatedText.count > 5 {
            return false
        }
        
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.btnEnableDisable()
    }
    
}

//----------------------------------------------------------------------------
//MARK: - Class observers Methods
//----------------------------------------------------------------------------
extension SignUpVC{
    
    func addClassObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationGetAppVersionsDetails(notification:)), name: NSNotification.Name.appVersionDetails, object: nil)
    }
    
    func removeClassObservers() {
        NotificationCenter.default.removeObserver(NSNotification.Name.appVersionDetails)
    }
    
    @objc func notificationGetAppVersionsDetails(notification : NSNotification) {
        
        if let object = notification.object as? JSON {
            if object["isDone"].boolValue{
                
                self.txtCountryCode.text = "\(JSON(AppVersionDetails.countryShortName as Any).stringValue) +\(JSON(AppVersionDetails.countryCode as Any).stringValue)"
                self.imgFlag.sd_setImage(with: JSON(AppVersionDetails.countryIcon as Any).stringValue.url(), placeholderImage: nil, context: nil)
            }
           
        }
    }
}
