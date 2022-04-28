//
//  SignUpVC.swift
//  NSC_iOS
//
//  Created by Dhruvit on 23/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var lblTitleHeightConst: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    // Textfield
    @IBOutlet weak var txtFName: UITextField!
    @IBOutlet weak var txtFMobileNo: UITextField!
    @IBOutlet weak var txtFEmailAdd: UITextField!
    
    // Button
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var btnGetSMSCode: UIButton!
    
    // Label
    @IBOutlet weak var lblPrivacy: UILabel!
    @IBOutlet weak var lblSupport: UILabel!
    
    @IBOutlet weak var lblErrName: UILabel!
    @IBOutlet weak var lblErrMobileNo: UILabel!
    @IBOutlet weak var lblErrEmail: UILabel!
    
    
    // MARK: - VARIABLES
   
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
    
   
    // MARK: - FUNCTIONS
   
    
   
    
    
    // MARK: - ACTIONS
    @IBAction func onTappedCreateAccount(_ sender: UIButton) {
       
    }
    
    @IBAction func onTappedCountryCode(_ sender: UIButton) {
       
    }
    
    @IBAction func onTappedBack(_ sender: UIButton) {
        
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
    
   
   
    
}

