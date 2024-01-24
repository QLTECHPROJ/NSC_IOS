//
//  LoginVC.swift
//  NSC_iOS
//
//  Created by Dhruvit on 23/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import FirebaseAuth

class LoginVC: ClearNaviagtionBarVC {
    
    // MARK: - OUTLETS
    //UILabel
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPhoneNo: UILabel!
    
    @IBOutlet weak var imgFlag: UIImageView!

    @IBOutlet weak var lblPrivacyTermCondition: UILabel!
    
    //UIButton
    
    @IBOutlet weak var btnGetSMSCode: AppThemeButton!
    
    //UITextfield
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    
    
    
    // MARK: - VARIABLES
    var loginCheckVM : LoginCheckViewModel?
    var isFromOTP = false

    
    deinit{
        self.removeClassObservers()
    }

    
    // MARK: - FUNCTIONS
    private func setUpView(){
        self.addClassObservers()
        self.configureUI()
    }
    
    private func configureUI(){
        self.view.backgroundColor = .colorAppThemeBGWhite
        self.lblTitle.applyLabelStyle(text: kLogIn, fontSize: 28.0, fontName: .SFProDisplayBold)
        
        self.lblPhoneNo.applyLabelStyle(text: kMobileNumber, fontSize: 13.0, fontName: .SFProDisplayRegular, textColor : .colorAppTxtFieldGray)
        self.txtCountryCode.applyStyleTextField(fontsize: 13.0, fontname: .SFProDisplayMedium)
        
        self.txtCountryCode.text = "\(JSON(AppVersionDetails.countryShortName as Any).stringValue) +\(JSON(AppVersionDetails.countryCode as Any).stringValue)"
        self.imgFlag.sd_setImage(with: JSON(AppVersionDetails.countryIcon as Any).stringValue.url(), placeholderImage: nil, context: nil)
        
        self.txtMobile.applyStyleTextField(placeholder : "", fontsize: 13.0, fontname: .SFProDisplayMedium)
        
        //        let countryText = AppVersionDetails.countryShortName + " " + "+" + AppVersionDetails.countryCode
        
        self.btnGetSMSCode.setTitle(kGetOTP, for: .normal)
        self.buttonEnableDisable()
        
        let defaultFontAttribute = [NSAttributedString.Key.foregroundColor: UIColor.colorAppDarkGray ,NSAttributedString.Key.font: UIFont.applyCustomFont(fontName: .SFProDisplayRegular, fontSize: 11.0)]
        let blueFontAttribute = [NSAttributedString.Key.foregroundColor: UIColor.colorAppDarkGray,NSAttributedString.Key.font: UIFont.applyCustomFont(fontName: .SFProDisplayRegular, fontSize: 11.0),NSAttributedString.Key.underlineColor: UIColor.colorAppDarkGray, NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
    
        self.lblPrivacyTermCondition.text = kByClickingOnGetOTPYouAgreeToOurTCsPrivacyPolicy
        self.lblPrivacyTermCondition.attributedText = (self.lblPrivacyTermCondition.text)?.getAttributedText(defaultDic: defaultFontAttribute, attributeDic: blueFontAttribute, attributedStrings: [kTCs,kPrivacyPolicy])
        
        self.lblPrivacyTermCondition.lineSpacing(lineSpacing: 10.0, alignment: self.lblPrivacyTermCondition.textAlignment)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.lblTCsPrivacyPolicyTapped(_:)))
        self.lblPrivacyTermCondition.isUserInteractionEnabled = true
        self.lblPrivacyTermCondition.addGestureRecognizer(tap)
    }

    
    private func buttonEnableDisable() {
        
        self.btnGetSMSCode.isSelect = !self.txtMobile.text!.trim.isEmpty
    }
    
    func checkValidation() -> Bool {
        
        self.view.endEditing(true)
        
        var isValid = true
        let strMobile = txtMobile.text?.trim ?? ""
        
        if strMobile.count == 0 {
            
            isValid = false
            
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_invalid_mobile_error)
            
        } else if strMobile.count < AppVersionDetails.mobileMinDigits || strMobile.count > AppVersionDetails.mobileMaxDigits {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_invalid_mobile_error)
        }
        return isValid
    }
    
    func goNext() {
        if loginCheckVM?.loginFlag == "0" {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: SignUpVC.self)
            aVC.strMobile = txtMobile.text ?? ""
            aVC.mobileNoDidChange = { mobileNo in
                self.txtMobile.text = mobileNo
            }
            self.navigationController?.pushViewController(aVC, animated: true)
        } else {
            sendOTP()
        }
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
            self.navigationController?.pushViewController(aVC, animated: true)
        }
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
    
    @IBAction func loginClicked(_ sender: UIButton) {
        
        if checkValidation() {
            
            isFromOTP = true
            
            let parameters = ["mobile":txtMobile.text ?? "",
                              "countryCode":AppVersionDetails.countryCode]
            
            loginCheckVM = LoginCheckViewModel()
            loginCheckVM?.callLoginCheckAPI(parameters: parameters, completion: { success in
                if success {
                    self.goNext()
                }
            })
        }
    }
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFromOTP {
            txtMobile.becomeFirstResponder()
        } else {
            txtMobile.text = ""
        }
        
        self.buttonEnableDisable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
}


// MARK: - UITextFieldDelegate
extension LoginVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.buttonEnableDisable()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string).trim
            if !updatedText.isNumber || updatedText.count > AppVersionDetails.mobileMaxDigits {
                return false
            }
        }
        
        let inValidCharacterSet = NSCharacterSet.whitespaces
        guard let firstChar = string.unicodeScalars.first else {
            return true
        }
        
        return !inValidCharacterSet.contains(firstChar)
    }
    
}


//----------------------------------------------------------------------------
//MARK: - Class observers Methods
//----------------------------------------------------------------------------
extension LoginVC{
    
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
