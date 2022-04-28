//
//  LoginVC.swift
//  NSC_iOS
//
//  Created by Dhruvit on 23/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblErrMobileNo: UILabel!
    
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var btnGetSMSCode: UIButton!
    
    @IBOutlet weak var txtFMobileNo: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var lblPrivacy: UILabel!
    @IBOutlet weak var lblSupport: UILabel!
    
    
    // MARK: - VARIABLES
   
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
    
   
    // MARK: - ACTIONS
    @IBAction func countryCodeClicked(_ sender: UIButton) {
       
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
       
       
    }
    
}


// MARK: - UITextFieldDelegate
extension LoginVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.lblErrMobileNo.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
}

