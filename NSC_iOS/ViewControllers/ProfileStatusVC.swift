//
//  ProfileStatusVC.swift
//  NSC_iOS
//
//  Created by Mac Mini on 29/04/22.
//

import UIKit

class ProfileStatusVC: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- ACTION
   
    @IBAction func onTappedContinue(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:CampListVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
}
