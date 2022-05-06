//
//  BankDetailsVC.swift
//  NSC_iOS
//
//  Created by Dhruvit on 06/05/22.
//

import UIKit

class BankDetailsVC: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var txtBankName: UITextField!
    @IBOutlet weak var txtAccountNumber: UITextField!
    @IBOutlet weak var txtAccountName: UITextField!
    @IBOutlet weak var txtIFSCCode: UITextField!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    
    
    // MARK: - VARIABLES
    var isFromEdit = false
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        btnBack.isHidden = !isFromEdit
    }
    
    
    // MARK: - ACTIONS
    @IBAction func confirmClicked(_ sender: UIButton) {
        
    }
    
}
