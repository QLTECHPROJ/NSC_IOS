//
//  OTPVC.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 22/06/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit


class OTPVC: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblSupport: UILabel!
    
    @IBOutlet weak var btnDone: UIButton!
    
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
    
    @IBOutlet weak var lblSMSSent: UILabel!
    @IBOutlet weak var lblError: UILabel!
    
    // UIView
    @IBOutlet weak var viewCard1: CardView!
    @IBOutlet weak var viewCard2: CardView!
    @IBOutlet weak var viewCard3: CardView!
    @IBOutlet weak var viewCard4: CardView!
    
    
    // MARK: - VARIABLES
    var textFields: [BackspaceTextField] {
        return [txtFPin1, txtFPin2, txtFPin3, txtFPin4]
    }
    
    var bottomLabels: [UILabel] {
        return [lblLine1, lblLine2, lblLine3, lblLine4]
    }
    
   
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }
    
   
    func shadow(view:UIView) {
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 3
    }
    
    func shadowRemove(view:UIView) {
        view.layer.shadowColor = UIColor.clear.cgColor
        view.layer.shadowOpacity = 0
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 0
    }
    
    func isStringContainsOnlyNumbers(string: String) -> Bool {
        return string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    // MARK: - ACTIONS
    @IBAction func backClicked(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createAccountClicked(_ sender: UIButton) {
        
        
        
    }
    
    @IBAction func resendSMSClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        txtFPin1.text = ""
        txtFPin2.text = ""
        txtFPin3.text = ""
        txtFPin4.text = ""
        lblError.isHidden = true
       
        
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
       
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == txtFPin1 {
            lblLine1.isHidden = false
            lblLine2.isHidden = true
            lblLine3.isHidden = true
            lblLine4.isHidden = true
            shadow(view:viewCard1)
            shadowRemove(view: viewCard2)
            shadowRemove(view: viewCard3)
            shadowRemove(view: viewCard4)
        } else if textField == txtFPin2 {
            lblLine1.isHidden = true
            lblLine2.isHidden = false
            lblLine3.isHidden = true
            lblLine4.isHidden = true
            shadow(view:viewCard2)
            shadowRemove(view: viewCard1)
            shadowRemove(view: viewCard3)
            shadowRemove(view: viewCard4)
        } else  if textField == txtFPin3 {
            lblLine1.isHidden = true
            lblLine2.isHidden = true
            lblLine3.isHidden = false
            lblLine4.isHidden = true
            shadow(view:viewCard3)
            shadowRemove(view: viewCard2)
            shadowRemove(view: viewCard1)
            shadowRemove(view: viewCard4)
        } else if textField == txtFPin4 {
            lblLine1.isHidden = true
            lblLine2.isHidden = true
            lblLine3.isHidden = true
            lblLine4.isHidden = false
            shadow(view:viewCard4)
            shadowRemove(view: viewCard2)
            shadowRemove(view: viewCard3)
            shadowRemove(view: viewCard1)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == txtFPin1 {
            lblLine1.isHidden = true
            shadowRemove(view:viewCard1)
        } else if textField == txtFPin2 {
            lblLine2.isHidden = true
            shadowRemove(view:viewCard2)
        } else  if textField == txtFPin3 {
            lblLine3.isHidden = true
            shadowRemove(view:viewCard3)
        } else if textField == txtFPin4 {
            lblLine4.isHidden = true
            shadowRemove(view:viewCard4)
        }
        
       
    }
    
}

