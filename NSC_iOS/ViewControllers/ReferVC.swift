//
//  ReferVC.swift
//  NSC_iOS
//
//  Created by Mac Mini on 13/05/22.
//

import UIKit

class ReferVC: BaseViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var imgViewStatus: UIImageView!
    @IBOutlet weak var btnRefer: UIButton!
    @IBOutlet weak var viewRefer: UIView!
    
    // MARK: - VARIABLES
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewRefer.addDashedBorder()
    }
    
    
    // MARK: - ACTION
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTappedRefer(_ sender: Any) {
    }
}
