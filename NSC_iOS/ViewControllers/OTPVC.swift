//
//  OTPVC.swift
//  NSC_iOS
//
//  Created by Mac Mini on 22/06/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import FirebaseAuth

class OTPVC: BaseViewController {
    
    // MARK: - OUTLETS
    // Textfield
    @IBOutlet weak var txtFPin1: BackspaceTextField!
    @IBOutlet weak var txtFPin2: BackspaceTextField!
    @IBOutlet weak var txtFPin3: BackspaceTextField!
    @IBOutlet weak var txtFPin4: BackspaceTextField!
    @IBOutlet weak var txtFPin5: BackspaceTextField!
    @IBOutlet weak var txtFPin6: BackspaceTextField!
    
    // Label
    @IBOutlet weak var lblLine1: UILabel!
    @IBOutlet weak var lblLine2: UILabel!
    @IBOutlet weak var lblLine3: UILabel!
    @IBOutlet weak var lblLine4: UILabel!
    @IBOutlet weak var lblLine5: UILabel!
    @IBOutlet weak var lblLine6: UILabel!
    
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblSupport: TTTAttributedLabel!
    
    // UIView
    @IBOutlet weak var viewCard1: CardView!
    @IBOutlet weak var viewCard2: CardView!
    @IBOutlet weak var viewCard3: CardView!
    @IBOutlet weak var viewCard4: CardView!
    @IBOutlet weak var viewCard5: CardView!
    @IBOutlet weak var viewCard6: CardView!
    
    // UIButton
    @IBOutlet weak var btnDone: UIButton!
    
    
    // MARK: - VARIABLES
    var textFields: [BackspaceTextField] {
        return [txtFPin1, txtFPin2, txtFPin3, txtFPin4, txtFPin5, txtFPin6]
    }
    
    var bottomLabels: [UILabel] {
        return [lblLine1, lblLine2, lblLine3, lblLine4, lblLine5, lblLine6]
    }
    
    var isFromSignUp = false
    var strName = ""
    var strMobile = ""
    var strEmail = ""
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSupportLabel(lblSupport: lblSupport)
        self.txtFPin1.becomeFirstResponder()
    }
    
    
    // MARK: - FUNCTIONS
    override func setupUI() {
        let strSMSSent = "We've sent SMS with a 6-digit code to \n+\(AppVersionDetails.countryCode)\(strMobile)."
        lblSubTitle.attributedText = strSMSSent.attributedString(alignment: .center, lineSpacing: 5)
        
        if isFromSignUp == true {
            btnDone.setTitle("CREATE ACCOUNT", for: .normal)
        } else {
            btnDone.setTitle("LOGIN", for: .normal)
        }
        
        for textfield in textFields {
            textfield.tintColor = UIColor.clear
            textfield.delegate = self
            textfield.backspaceTextFieldDelegate = self
            
            if #available(iOS 12.0, *) {
                textfield.textContentType = .oneTimeCode
            } else {
                // Fallback on earlier versions
            }
        }
        
        for label in bottomLabels {
            label.isHidden = true
        }
        
        buttonEnableDisable()
    }
    
    override func buttonEnableDisable() {
        if txtFPin1.text?.trim.count == 0 || txtFPin2.text?.trim.count == 0 ||
            txtFPin3.text?.trim.count == 0 || txtFPin4.text?.trim.count == 0 ||
            txtFPin5.text?.trim.count == 0 || txtFPin6.text?.trim.count == 0 {
            btnDone.isUserInteractionEnabled = false
            btnDone.backgroundColor = Theme.colors.gray_7E7E7E
            btnDone.removeGradient()
        } else {
            btnDone.isUserInteractionEnabled = true
            btnDone.backgroundColor = Theme.colors.theme_dark
        }
    }
    
    func checkValidation() -> Bool {
        let strOTP = txtFPin1.text! + txtFPin2.text! + txtFPin3.text! + txtFPin4.text! + txtFPin5.text! + txtFPin6.text!
        
        if strOTP.count < 4 {
            self.lblError.text = Theme.strings.alert_invalid_otp
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
                showAlertToast(message: error.localizedDescription)
                return
            }
            
            // Sign in using the verificationID and the code sent to the user
            authVerificationID = verificationID ?? ""
        }
    }
    
    func autoVerifyOTP() {
        if checkValidation() {
            lblLine1.isHidden = true
            lblLine2.isHidden = true
            lblLine3.isHidden = true
            lblLine4.isHidden = true
            lblLine5.isHidden = true
            lblLine6.isHidden = true
            
            let strOTP = txtFPin1.text! + txtFPin2.text! + txtFPin3.text! + txtFPin4.text! + txtFPin5.text! + txtFPin6.text!
            verifyOTP(verificationCode: strOTP)
        }
    }
    
    func verifyOTP(verificationCode : String) {
        showHud()
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: authVerificationID, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { authResult, error in
            
            hideHud()
            
            if let error = error {
                showAlertToast(message: error.localizedDescription)
                return
            }
            
            // OTP Verification Successful
            self.goNext()
        }
    }
    
    override func goNext() {
        if isFromSignUp {
            handleSignUp()
        } else {
            handleLogin()
        }
    }
    
    func handleSignUp() {
        // Call Coach Register API
        let parameters = ["mobile":strMobile,
                          "countryCode":AppVersionDetails.countryCode,
                          "deviceType":APP_TYPE,
                          "deviceToken":FCM_TOKEN]
        
        let signUpVM = SignUpViewModel()
        signUpVM.callCoachRegisterAPI(parameters: parameters) { success in
            if success {
                self.handleLoginUserRedirection()
            }
        }
    }
    
    func handleLogin() {
        // Call Coach Login API
        let parameters = ["mobile":strMobile,
                          "countryCode":AppVersionDetails.countryCode,
                          "deviceType":APP_TYPE,
                          "deviceToken":FCM_TOKEN]
        
        let loginVM = LoginViewModel()
        loginVM.callLoginAPI(parameters: parameters) { success in
            if success {
                self.handleLoginUserRedirection()
            }
        }
    }
    
    override func handleLoginUserRedirection() {
        guard let userData = LoginDataModel.currentUser else {
            return
        }
        
        if userData.Status == CoachStatus.Hired.rawValue {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: CampListVC.self)
            let navVC = UINavigationController(rootViewController: aVC)
            navVC.navigationBar.isHidden = true
            APPDELEGATE.window?.rootViewController = navVC
        } else {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: ProfileStatusVC.self)
            let navVC = UINavigationController(rootViewController: aVC)
            navVC.navigationBar.isHidden = true
            APPDELEGATE.window?.rootViewController = navVC
        }
    }
    
    // MARK: - ACTIONS
    @IBAction func backClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createAccountClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.autoVerifyOTP()
    }
    
    @IBAction func resendSMSClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        txtFPin1.text = ""
        txtFPin2.text = ""
        txtFPin3.text = ""
        txtFPin4.text = ""
        txtFPin5.text = ""
        txtFPin6.text = ""
        
        lblError.isHidden = true
        
        buttonEnableDisable()
        
        self.sendOTP()
    }
    
    @IBAction func editNumberClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK: - UITextFieldDelegate, BackspaceTextFieldDelegate
extension OTPVC : UITextFieldDelegate, BackspaceTextFieldDelegate {
    
    func textFieldDidEnterBackspace(_ textField: BackspaceTextField) {
        switch textField {
        case txtFPin6:
            txtFPin5.becomeFirstResponder()
        case txtFPin5:
            txtFPin4.becomeFirstResponder()
        case txtFPin4:
            txtFPin3.becomeFirstResponder()
        case txtFPin3:
            txtFPin2.becomeFirstResponder()
        case txtFPin2:
            txtFPin1.becomeFirstResponder()
        case txtFPin1:
            break
        default:
            break
        }
        textField.text = ""
        buttonEnableDisable()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        lblLine1.isHidden = !(textField == txtFPin1)
        lblLine2.isHidden = !(textField == txtFPin2)
        lblLine3.isHidden = !(textField == txtFPin3)
        lblLine4.isHidden = !(textField == txtFPin4)
        lblLine5.isHidden = !(textField == txtFPin5)
        lblLine6.isHidden = !(textField == txtFPin6)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if isStringContainsOnlyNumbers(string: string) == false {
            return false
        }
        
        let text = textField.text
        let textRange = Range(range, in:text!)
        let updatedText = text!.replacingCharacters(in: textRange!, with: string).trim
        
        if updatedText.count >= 1 {
            textField.text = string
            buttonEnableDisable()
            
            switch textField {
            case txtFPin1:
                txtFPin2.becomeFirstResponder()
            case txtFPin2:
                txtFPin3.becomeFirstResponder()
            case txtFPin3:
                txtFPin4.becomeFirstResponder()
            case txtFPin4:
                txtFPin5.becomeFirstResponder()
            case txtFPin5:
                txtFPin6.becomeFirstResponder()
            case txtFPin6:
                txtFPin6.resignFirstResponder()
                self.autoVerifyOTP()
            default:
                break
            }
            
            return false
        } else if updatedText.count == 0 {
            
            switch textField {
            case txtFPin6:
                txtFPin5.becomeFirstResponder()
            case txtFPin5:
                txtFPin4.becomeFirstResponder()
            case txtFPin4:
                txtFPin3.becomeFirstResponder()
            case txtFPin3:
                txtFPin2.becomeFirstResponder()
            case txtFPin2:
                txtFPin1.becomeFirstResponder()
            case txtFPin1:
                break
            default:
                break
            }
            
            textField.text = ""
            buttonEnableDisable()
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == txtFPin1 {
            lblLine1.isHidden = true
        } else if textField == txtFPin2 {
            lblLine2.isHidden = true
        } else  if textField == txtFPin3 {
            lblLine3.isHidden = true
        } else if textField == txtFPin4 {
            lblLine4.isHidden = true
        } else if textField == txtFPin5 {
            lblLine5.isHidden = true
        } else if textField == txtFPin6 {
            lblLine6.isHidden = true
        }
        
        buttonEnableDisable()
    }
    
}

