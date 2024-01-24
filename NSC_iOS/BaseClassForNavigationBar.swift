//
//  BaseClassForNavigationBar.swift
//  NSC_iOS
//
//  Created by vishal parmar on 21/10/23.
//

import Foundation
import UIKit

class ClearNaviagtionBarVC: UIViewController {
    //MARK: - Outlet
    
    //------------------------------------------------------
    //MARK: - Class Variable
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.colorAppThemeOrange
        return refreshControl
    }()
    
    //------------------------------------------------------
    //MARK: - Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
    }
    
    //------------------------------------------------------
    
    //MARK: - Custom Method
    
    func fetchCoachDetails(completion : (() -> Void)? = nil) {
        let coachDetailVM = CoachDetailViewModel()
        coachDetailVM.callCoachDetailsAPI { success in
            
            completion?()
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
    }
    /**
     Redirect Logged In User
    */
    func handleLoginUserRedirection() {
        // Redirect Logged In User
        guard let userData = LoginDataModel.currentUser else {
            return
        }
        
        if userData.PersonalDetailFilled == "0" {
            
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: PersonalDetailsVC.self)
            UIApplication.topViewController()?.navigationController?.pushViewController(aVC, animated: true)
            
        } else if userData.BankDetailFilled == "0" {
            
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: BankDetailsVC.self)
            UIApplication.topViewController()?.navigationController?.pushViewController(aVC, animated: true)
            
        } else if userData.Status == CoachStatus.Pending.rawValue || userData.Status == CoachStatus.Rejected.rawValue {
            
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: ProfileStatusVC.self)
            UIApplication.topViewController()?.navigationController?.pushViewController(aVC, animated: true)
            
        } else {
            //            let aVC = AppStoryBoard.main.viewController(viewControllerClass: CampListVC.self)
//                        aVC.makeRootController()
            
            let homeNav = AUTHENTICATION.instantiateViewController(withIdentifier: "navHome") as! UINavigationController
            UIApplication.shared.windows.first?.rootViewController = homeNav
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
    
    //------------------------------------------------------
    
    //MARK: - Action Method
    
    
    //------------------------------------------------------
    
    //MARK: - Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.view.backgroundColor = .colorAppThemeBGWhite
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.isNavigationBarHidden = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var titleColor : UIColor = UIColor.colorAppTextBlack
        
        self.navigationController?.navigationBar.barStyle = .default
        
        //        self.navigationController?.navigationBar.setBackgroundImage(UIImage().withColor(.clear), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
//
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor,NSAttributedString.Key.font:UIFont.applyCustomFont(fontName: .SFProDisplayBold, fontSize: 18.0)]
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}

class ClearWhiteNaviagtionBarVC: UIViewController {
    //MARK: - Outlet
    
    //------------------------------------------------------
    //MARK: - Class Variable
    
    //------------------------------------------------------
    //MARK: - Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
    }
    
    //------------------------------------------------------
    
    //MARK: - Custom Method
    
    func fetchCoachDetails(completion : (() -> Void)? = nil) {
        let coachDetailVM = CoachDetailViewModel()
        coachDetailVM.callCoachDetailsAPI { success in
            
            completion?()
        }
    }
    
    /**
     Redirect Logged In User
    */
    func handleLoginUserRedirection() {
        // Redirect Logged In User
        guard let userData = LoginDataModel.currentUser else {
            return
        }
        
        if userData.PersonalDetailFilled == "0" {
            
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: PersonalDetailsVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
            
        } else if userData.BankDetailFilled == "0" {
            
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: BankDetailsVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
            
        } else if userData.Status == CoachStatus.Pending.rawValue || userData.Status == CoachStatus.Rejected.rawValue {
            
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: ProfileStatusVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
            
        } else {
//            let aVC = AppStoryBoard.main.viewController(viewControllerClass: CampListVC.self)
//            aVC.makeRootController()
            
            let homeNav = AUTHENTICATION.instantiateViewController(withIdentifier: "navHome") as! UINavigationController
            UIApplication.shared.windows.first?.rootViewController = homeNav
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
    
    
    //------------------------------------------------------
    
    //MARK: - Action Method
    
    
    //------------------------------------------------------
    
    //MARK: - Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var titleColor : UIColor = UIColor.white
        
        self.navigationController?.navigationBar.barStyle = .black
        
        //        self.navigationController?.navigationBar.setBackgroundImage(UIImage().withColor(.clear), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
//
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor,NSAttributedString.Key.font:UIFont.applyCustomFont(fontName: .SFProDisplayBold, fontSize: 18.0)]
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}
