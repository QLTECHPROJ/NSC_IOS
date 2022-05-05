//
//  SignUpVC.swift
//  NSC_iOS
//
//  Created by Dhruvit on 23/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import FirebaseAuth

class SignUpVC: BaseViewController {
    
    // MARK: - OUTLETS
    //UIStackView
    @IBOutlet weak var stackView: UIStackView!
    
    //UITextfield
    @IBOutlet weak var txtFName: UITextField!
    @IBOutlet weak var txtFMobileNo: UITextField!
    @IBOutlet weak var txtFEmailAdd: UITextField!
    
    // UIButton
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var btnGetSMSCode: UIButton!
    
    // UILabel
    @IBOutlet weak var lblTitleHeightConst: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblPrivacy: TTTAttributedLabel!
    @IBOutlet weak var lblSupport: TTTAttributedLabel!
    @IBOutlet weak var lblErrName: UILabel!
    @IBOutlet weak var lblErrMobileNo: UILabel!
    @IBOutlet weak var lblErrEmail: UILabel!
    
    
    // MARK: - VARIABLES
    var loginCheckVM : LoginCheckViewModel?
    
    var isFromOTP = false
    var isCountrySelected = false
    var strMobile:String?
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPrivacyLabel(lblPrivacy: lblPrivacy)
        setupSupportLabel(lblSupport: lblSupport)
        setupData()
        
        if strMobile != "" {
            txtFMobileNo.text = strMobile
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFromOTP {
            txtFMobileNo.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    
    // MARK: - FUNCTIONS
    override func setupUI() {
        lblTitle.text = Theme.strings.register_title
        lblSubTitle.attributedText = Theme.strings.register_subtitle.attributedString(alignment: .center, lineSpacing: 5)
        
        lblErrName.isHidden = true
        
        lblErrMobileNo.isHidden = true
        lblErrEmail.isHidden = true
        
        txtFName.delegate = self
        txtFMobileNo.delegate = self
        txtFEmailAdd.delegate = self
        
        buttonEnableDisable()
    }
    
    override func setupData() {
        let countryText = AppVersionDetails.countryShortName + " +" + AppVersionDetails.countryCode
        btnCountryCode.setTitle(countryText, for: .normal)
        
        buttonEnableDisable()
    }
    
    override func buttonEnableDisable() {
        let name = txtFName.text?.trim
        let mobile = txtFMobileNo.text?.trim
        let email = txtFEmailAdd.text?.trim
        
        
        if name?.count == 0 || mobile?.count == 0 || email?.count == 0 {
            btnGetSMSCode.isUserInteractionEnabled = false
            btnGetSMSCode.backgroundColor = Theme.colors.gray_7E7E7E
            btnGetSMSCode.removeGradient()
        } else {
            btnGetSMSCode.isUserInteractionEnabled = true
            btnGetSMSCode.backgroundColor = Theme.colors.theme_dark
        }
    }
    
    func checkValidation() -> Bool {
        var isValid = true
        let strMobile = txtFMobileNo.text?.trim ?? ""
        
        if txtFName.text?.trim.count == 0 {
            isValid = false
            lblErrName.isHidden = false
            lblErrName.text = Theme.strings.alert_blank_fullname_error
        }
        
        if strMobile.count == 0 {
            isValid = false
            self.lblErrMobileNo.isHidden = false
            self.lblErrMobileNo.text = Theme.strings.alert_invalid_mobile_error
        } else if strMobile.count < 8 || strMobile.count > 13 {
            isValid = false
            self.lblErrMobileNo.isHidden = false
            self.lblErrMobileNo.text = Theme.strings.alert_invalid_mobile_error
        } else if strMobile.isPhoneNumber == false {
            isValid = false
            lblErrMobileNo.isHidden = false
            lblErrMobileNo.text = Theme.strings.alert_invalid_mobile_error
        }
        
        if txtFEmailAdd.text?.trim.count == 0 {
            isValid = false
            lblErrEmail.isHidden = false
            lblErrEmail.text = Theme.strings.alert_invalid_email_error
        } else if !txtFEmailAdd.text!.isValidEmail {
            isValid = false
            lblErrEmail.isHidden = false
            lblErrEmail.text = Theme.strings.alert_invalid_email_error
        }
        
        return isValid
    }
    
    override func goNext() {
        if loginCheckVM?.loginFlag == "0" {
            sendOTP()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func sendOTP() {
        showHud()
        
        let phoneString = "+" + AppVersionDetails.countryCode + (txtFMobileNo.text ?? "")
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneString, uiDelegate: nil) { verificationID, error in
            
            hideHud()
            
            if let error = error {
                showAlertToast(message: error.localizedDescription)
                return
            }
            
            // Sign in using the verificationID and the code sent to the user
            authVerificationID = verificationID ?? ""
            
            let aVC = AppStoryBoard.main.viewController(viewControllerClass:OTPVC.self)
            aVC.strMobile = self.txtFMobileNo.text ?? ""
            aVC.strName = self.txtFName.text ?? ""
            aVC.strEmail = self.txtFEmailAdd.text ?? ""
            aVC.isFromSignUp = true
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
    
    // MARK: - ACTIONS
    @IBAction func onTappedCreateAccount(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if checkValidation() {
            lblErrName.isHidden = true
            lblErrMobileNo.isHidden = true
            lblErrEmail.isHidden = true
            isFromOTP = true
            
            let parameters = ["mobile":txtFMobileNo.text ?? "",
                              "countryCode":AppVersionDetails.countryCode]
            
            loginCheckVM = LoginCheckViewModel()
            loginCheckVM?.callLoginCheckAPI(parameters: parameters, completion: { success in
                if success {
                    self.goNext()
                }
            })
        }
    }
    
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK: - UITextFieldDelegate
extension SignUpVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lblErrName.isHidden = true
        lblErrMobileNo.isHidden = true
        lblErrEmail.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text, let textRange = Range(range, in: text) else {
            return false
        }
        
        let updatedText = text.replacingCharacters(in: textRange, with: string).trim
        
        if textField == txtFName && updatedText.count > 16 {
            return false
        } else if textField == txtFMobileNo && updatedText.count > 13 {
            return false
        }
        
        buttonEnableDisable()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        buttonEnableDisable()
    }
    
}
