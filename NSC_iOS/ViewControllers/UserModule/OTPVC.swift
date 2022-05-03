//
//  OTPVC.swift
//  NSC_iOS
//
//  Created by Mac Mini on 22/06/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class OTPVC: BaseViewController {
    
    // MARK: - OUTLETS
    // Textfield
    @IBOutlet weak var txtFPin1: BackspaceTextField!
    @IBOutlet weak var txtFPin2: BackspaceTextField!
    @IBOutlet weak var txtFPin3: BackspaceTextField!
    @IBOutlet weak var txtFPin4: BackspaceTextField!
    
    // Label
    @IBOutlet weak var lblLine1: UILabel!
    @IBOutlet weak var lblLine2: UILabel!
    @IBOutlet weak var lblLine3: UILabel!
    @IBOutlet weak var lblLine4: UILabel!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblSupport: TTTAttributedLabel!
    
    // UIView
    @IBOutlet weak var viewCard1: CardView!
    @IBOutlet weak var viewCard2: CardView!
    @IBOutlet weak var viewCard3: CardView!
    @IBOutlet weak var viewCard4: CardView!
    
    // UIButton
    @IBOutlet weak var btnDone: UIButton!
    
    // MARK: - VARIABLES
    var textFields: [BackspaceTextField] {
        return [txtFPin1, txtFPin2, txtFPin3, txtFPin4]
    }
    
    var bottomLabels: [UILabel] {
        return [lblLine1, lblLine2, lblLine3, lblLine4]
    }
    var signUpFlag = ""
    var strName = ""
    //var selectedCountry = CountrylistDataModel()
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
        lblSubTitle.attributedText = Theme.strings.otp_subtitle.attributedString(alignment: .center, lineSpacing: 5)
        
        //let strSMSSent = "We've sent SMS with a 4-digit code to +\(selectedCountry.Code)\(strMobile)."
      //  lblSMSSent.attributedText = strSMSSent.attributedString(alignment: .center, lineSpacing: 5)
        
        if signUpFlag == "0" {
            btnDone.setTitle("LOGIN", for: .normal)
        } else {
            btnDone.setTitle("CREATE ACCOUNT", for: .normal)
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
            txtFPin3.text?.trim.count == 0 || txtFPin4.text?.trim.count == 0 {
            btnDone.isUserInteractionEnabled = false
            btnDone.backgroundColor = Theme.colors.gray_7E7E7E
            btnDone.removeGradient()
        } else {
            btnDone.isUserInteractionEnabled = true
            btnDone.backgroundColor = Theme.colors.theme_dark
        }
    }
    

    func checkValidation() -> Bool {
        let strOTP = txtFPin1.text! + txtFPin2.text! + txtFPin3.text! + txtFPin4.text!
        
        if strOTP.count < 4 {
            self.lblError.text = Theme.strings.alert_invalid_otp
            return false
        }
        
        return true
    }
    
    func isStringContainsOnlyNumbers(string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    func autoVerifyOTP() {
        if checkValidation() {
            lblLine1.isHidden = true
            lblLine2.isHidden = true
            lblLine3.isHidden = true
            lblLine4.isHidden = true
            let aVC = AppStoryBoard.main.viewController(viewControllerClass:SignUpVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
            //let strOTP = txtFPin1.text! + txtFPin2.text! + txtFPin3.text! + txtFPin4.text!
           // callAuthOTPAPI(otp: strOTP)
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
        lblError.isHidden = true
        buttonEnableDisable()
        
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
        
        if textField == txtFPin1 {
            lblLine1.isHidden = false
            lblLine2.isHidden = true
            lblLine3.isHidden = true
            lblLine4.isHidden = true
        } else if textField == txtFPin2 {
            lblLine1.isHidden = true
            lblLine2.isHidden = false
            lblLine3.isHidden = true
            lblLine4.isHidden = true
        } else  if textField == txtFPin3 {
            lblLine1.isHidden = true
            lblLine2.isHidden = true
            lblLine3.isHidden = false
            lblLine4.isHidden = true
        } else if textField == txtFPin4 {
            lblLine1.isHidden = true
            lblLine2.isHidden = true
            lblLine3.isHidden = true
            lblLine4.isHidden = false
        }
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
                txtFPin4.resignFirstResponder()
                self.autoVerifyOTP()
            default:
                break
            }
            
            return false
        } else if updatedText.count == 0 {
            
            switch textField {
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
        }
        
        buttonEnableDisable()
    }
    
}

