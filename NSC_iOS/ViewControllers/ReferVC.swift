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
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var btnRefer: UIButton!
    @IBOutlet weak var viewRefer: UIView!
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewRefer.addDashedBorder()
    }
    
    
    // MARK: - ACTION
    @IBAction func backClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func copyCodeClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func referClicked(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass: ContactVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
}
