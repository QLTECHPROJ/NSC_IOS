//
//  PersonalDetailsVC.swift
//  NSC_iOS
//
//  Created by Dhruvit on 06/05/22.
//

import UIKit

class PersonalDetailsVC: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtPostCode: UITextField!
    @IBOutlet weak var txtCamps: UITextField!
    @IBOutlet weak var txtRole: UITextField!
    @IBOutlet weak var txtVaccinated: UITextField!
    
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
