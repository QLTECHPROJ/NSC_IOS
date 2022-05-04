//
//  SplashVC.swift
//  NSC_iOS
//
//  Created by Dhruvit on 26/04/22.
//

import UIKit

class SplashVC: UIViewController {
    
    // MARK: - VARIABLES
    let appVersionVM = AppVersionViewModel()
    
    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        appVersionVM.callAppVersionAPI(completion: { success in
            if success {
                self.handleAppUpdatePopup()
            }
        })
    }
    
    // MARK: - FUNCTIONS
    func handleAppUpdatePopup() {
        if appVersionVM.appVersionData?.IsForce == "1" {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: AlertPopUpVC.self)
            aVC.titleText = Theme.strings.force_update_title
            aVC.detailText = Theme.strings.force_update_subtitle
            aVC.firstButtonTitle = Theme.strings.update
            aVC.hideSecondButton = true
            aVC.modalPresentationStyle = .overFullScreen
            aVC.delegate = self
            self.present(aVC, animated: false, completion: nil)
        } else if appVersionVM.appVersionData?.IsForce == "0" {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: AlertPopUpVC.self)
            aVC.titleText = Theme.strings.normal_update_title
            aVC.detailText = Theme.strings.normal_update_subtitle
            aVC.firstButtonTitle = Theme.strings.update
            aVC.secondButtonTitle = Theme.strings.not_now
            aVC.modalPresentationStyle = .overFullScreen
            aVC.delegate = self
            self.present(aVC, animated: false, completion: nil)
        } else {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: LoginVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
}


// MARK: - AlertPopUpVCDelegate
extension SplashVC : AlertPopUpVCDelegate {
    
    func handleAction(sender: UIButton, popUpTag: Int) {
        if sender.tag == 0 {
            if appVersionVM.appVersionData?.IsForce == "1" {
                self.openUrl(urlString: APP_APPSTORE_URL)
            } else {
                self.openUrl(urlString: APP_APPSTORE_URL)
                let aVC = AppStoryBoard.main.viewController(viewControllerClass: LoginVC.self)
                self.navigationController?.pushViewController(aVC, animated: true)
            }
        } else {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: LoginVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
}
