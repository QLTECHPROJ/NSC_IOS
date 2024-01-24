//
//  SplashVC.swift
//  NSC_iOS
//
//  Created by Dhruvit on 26/04/22.
//

import UIKit

class SplashVC: BaseViewController {
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Wait 2 Seconds for FCM Token
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let appVersionVM = AppVersionViewModel()
            appVersionVM.callAppVersionAPI(completion: { success in
                if success {
                    self.handleAppUpdatePopup()
                }
            })
        }
    }
    
    
    // MARK: - FUNCTIONS
    func handleAppUpdatePopup() {
        if AppVersionDetails.IsForce == "1" {
            
            let vc = AppStoryBoard.main.viewController(viewControllerClass: AlertPopUpVC.self)
            vc.alertType = .forceUpadte
            vc.modalPresentationStyle = .overFullScreen
            
            UIApplication.topViewController()?.present(vc, animated: false, completion :{
                vc.openPopUpVisiable()
            })
            vc.completionBlock = { completion , type in
                
                if completion , type == .forceUpadte{
                    self.openUrl(urlString: APP_APPSTORE_URL)
                }
            }
        } else if AppVersionDetails.IsForce == "0" {
            
            let vc = AppStoryBoard.main.viewController(viewControllerClass: AlertPopUpVC.self)
            vc.alertType = .normalUpdate
            vc.modalPresentationStyle = .overFullScreen
            
            UIApplication.topViewController()?.present(vc, animated: false, completion :{
                vc.openPopUpVisiable()
            })
            vc.completionBlock = { completion , type in
                
                if completion , type == .normalUpdate{
                    
                    self.openUrl(urlString: APP_APPSTORE_URL)
                    let aVC = AppStoryBoard.main.viewController(viewControllerClass: LoginVC.self)
                    self.navigationController?.pushViewController(aVC, animated: true)
                }
            }
            
        } else {
            self.handleRedirection()
        }
    }
    
    func handleRedirection() {
        if LoginDataModel.currentUser != nil {
            if checkInternet() {
                let coachDetailVM = CoachDetailViewModel()
                coachDetailVM.callCoachDetailsAPI { success in
                    if success {
                        self.handleLoginUserRedirection()
                    } else {
                        APPDELEGATE.logout()
                    }
                }
            }
        } else {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: LoginVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
}
