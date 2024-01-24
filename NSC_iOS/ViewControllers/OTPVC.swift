//
//  OTPVC.swift
//  NSC_iOS
//
//  Created by Mac Mini on 22/06/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import FirebaseAuth

class OTPVC: ClearNaviagtionBarVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblOTP: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    @IBOutlet weak var txtOTP: UITextField!
    @IBOutlet weak var btnContinue: AppThemeButton!
    
    @IBOutlet weak var btnResend: UIButton!
    
    
    // MARK: - VARIABLES
    var isFromSignUp = false
    var strFName = ""
    var strLName = ""
    var strMobile = ""
    var strEmail = ""
    var strPromoCode = ""
    
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    
    // MARK: - FUNCTIONS
    
    private func setUpView(){
        
        self.configureUI()
        self.buttonEnable()
    }
    private func configureUI(){
        
        self.lblTitle.applyLabelStyle(text: kOTPVerification, fontSize: 28.0, fontName: .SFProDisplayBold)
        
        self.lblOTP.applyLabelStyle(text: kOTP, fontSize: 13.0, fontName: .SFProDisplayRegular, textColor : .colorAppTxtFieldGray)
        self.btnResend.applystyle(fontname: .SFProDisplayBold, fontsize: 11.0, titleText: kResendOTP, titleColor: .colorAppThemeOrange)
        
        let defaultFontAttributePhone = [NSAttributedString.Key.foregroundColor: UIColor.colorAppDarkGray ,NSAttributedString.Key.font: UIFont.applyCustomFont(fontName: .SFProDisplayRegular, fontSize: 11.0)]
        let blueFontAttributePhone = [NSAttributedString.Key.foregroundColor: UIColor.colorAppThemeOrange,NSAttributedString.Key.font: UIFont.applyCustomFont(fontName: .SFProDisplayBold, fontSize: 11.0)] as [NSAttributedString.Key : Any]
    
        self.lblSubTitle.text = "\(kEnterTheOTPYouReceivecTo) +\(AppVersionDetails.countryCode)\(strMobile)"
        self.lblSubTitle.attributedText = (self.lblSubTitle.text)?.getAttributedText(defaultDic: defaultFontAttributePhone, attributeDic: blueFontAttributePhone, attributedStrings: ["+\(AppVersionDetails.countryCode)\(strMobile)"])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.lblEditPhoneNumberTapped(_:)))
        self.lblSubTitle.isUserInteractionEnabled = true
        self.lblSubTitle.addGestureRecognizer(tap)
        
        self.lblSubTitle.lineSpacing(lineSpacing: 5.0, alignment: self.lblSubTitle.textAlignment)
                
        self.txtOTP.applyStyleTextField(placeholder : "",fontsize: 16, fontname: .SFProDisplayMedium)
        self.txtOTP.addTarget(self, action: #selector(textFieldEdidtingDidChange(_ :)), for: .editingChanged)
        
        if #available(iOS 12.0, *) {
            txtOTP.textContentType = .oneTimeCode
        } else {
            // Fallback on earlier versions
        }

    }
    
    @objc func lblEditPhoneNumberTapped(_ tapGesture : UITapGestureRecognizer) {
        self.view.endEditing(true)
        if tapGesture.didTapAttributedTextInLabel(label: self.lblSubTitle, inRange: (self.lblSubTitle.attributedText!.string as NSString).range(of: "+\(AppVersionDetails.countryCode)\(strMobile)")) {
            
            debugPrint("+\(AppVersionDetails.countryCode)\(strMobile)")
            self.navigationController?.popViewController(animated: true)
           
        }
    }
    
    private func buttonEnable(){
        if (txtOTP.text?.trim.count ?? 0) < 6 {
            self.btnContinue.isSelect = false
        }
        else{
            self.btnContinue.isSelect = true
        }
    }
    
    
    @objc func textFieldEdidtingDidChange(_ textField :UITextField) {
        let attributedString = NSMutableAttributedString(string: textField.text!)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(8.0), range: NSRange(location: 0, length: attributedString.length))
        textField.attributedText = attributedString
    }
    
    func checkValidation() -> Bool {
        
        self.view.endEditing(true)
        
        if (txtOTP.text?.trim.count ?? 0) < 6 {

            GFunctions.shared.showSnackBar(message: Theme.strings.alert_invalid_otp)
            return false
        }
        
        return true
    }
    
    func isStringContainsOnlyNumbers(string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    func sendOTP() {
        showHud()
        
        let phoneString = "+" + AppVersionDetails.countryCode + strMobile
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneString, uiDelegate: nil) { verificationID, error in
            
            hideHud()
            
            if let error = error {
                
                GFunctions.shared.showSnackBar(message: error.localizedDescription)
                
                return
            }
            
            GFunctions.shared.showSnackBar(message: Theme.strings.sms_sent)
            
            // Sign in using the verificationID and the code sent to the user
            authVerificationID = verificationID ?? ""
        }
    }
    
    func autoVerifyOTP() {
        
        if checkValidation() {
            let strOTP = txtOTP.text ?? ""
            verifyOTP(verificationCode: strOTP)
        }
    }
    
    func verifyOTP(verificationCode : String) {
        showHud()
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: authVerificationID, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { authResult, error in
            
            hideHud()
            
            if let error = error {
                if error.localizedDescription == Theme.strings.invalid_otp_firebase {
                    
                    GFunctions.shared.showSnackBar(message: Theme.strings.alert_invalid_otp)
                    
                } else {
                    
                    GFunctions.shared.showSnackBar(message: error.localizedDescription)
                }
                return
            }
            
            // OTP Verification Successful
            self.goNext()
        }
    }
    
    private func goNext() {
        if isFromSignUp {
            handleSignUp()
        } else {
            handleLogin()
        }
    }
    
    func handleSignUp() {
        // Call Coach Register API
        let parameters = ["fname":strFName,
                          "lname":strLName,
                          "countryCode":AppVersionDetails.countryCode,
                          "mobile":strMobile,
                          "email":strEmail,
                          "referCode":strPromoCode,
                          "deviceType":APP_TYPE,
                          "deviceId":DEVICE_UUID,
                          "deviceToken":FCM_TOKEN]
        
        let signUpVM = SignUpViewModel()
        signUpVM.callCoachRegisterAPI(parameters: parameters) { success in
            if success {
                GFunctions.shared.showSnackBar(message: Theme.strings.welcome_message)
                self.handleLoginUserRedirection()
            }
        }
    }
    
    func handleLogin() {
        // Call Coach Login API
        let parameters = ["mobile":strMobile,
                          "countryCode":AppVersionDetails.countryCode,
                          "deviceType":APP_TYPE,
                          "deviceId":DEVICE_UUID,
                          "deviceToken":FCM_TOKEN]
        
        let loginVM = LoginViewModel()
        loginVM.callLoginAPI(parameters: parameters) { success in
            if success {
                GFunctions.shared.showSnackBar(message: Theme.strings.welcome_message)
                self.handleLoginUserRedirection()
            }
        }
    }
    
    
    // MARK: - ACTIONS
    @IBAction func backClicked(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createAccountClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.autoVerifyOTP()
    }
    
    @IBAction func resendSMSClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        self.txtOTP.text = ""
        
        buttonEnable()
        
        self.sendOTP()
    }
    
    @IBAction func editNumberClicked(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK: - UITextFieldDelegate, BackspaceTextFieldDelegate
extension OTPVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if isStringContainsOnlyNumbers(string: string) == false {
            return false
        }
        
        let text = textField.text
        let textRange = Range(range, in:text!)
        let updatedText = text!.replacingCharacters(in: textRange!, with: string).trim
        
        if updatedText.count < 6 {
            return true
        } else if updatedText.count > 6 {
            return false
        }
        
        let attributedString = NSMutableAttributedString(string: updatedText)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(8.0), range: NSRange(location: 0, length: attributedString.length))
        textField.attributedText = attributedString
        
        // textField.text = updatedText
        buttonEnable()
        self.autoVerifyOTP()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        buttonEnable()
    }
    
}

