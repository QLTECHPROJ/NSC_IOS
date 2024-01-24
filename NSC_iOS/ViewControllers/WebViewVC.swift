//
//  WebViewVC.swift
//  NSC_iOS
//
//  Created by vishal parmar on 21/10/23.
//

import UIKit
import WebKit

enum AppUrls {
    
    case termsNcondition
    case privacyPolicy
}

class WebViewVC: ClearNaviagtionBarVC {
    
    //----------------------------------------------------------------------------
    //MARK: - UIControl's Outlets
    //----------------------------------------------------------------------------
  
    @IBOutlet weak var navView : ShadowNavigationView!
    
   
    
    //----------------------------------------------------------------------------
    //MARK: - Class Variables
    //----------------------------------------------------------------------------
    
    var urlType : AppUrls?
    var webKitView : WKWebView = WKWebView()

    
    //----------------------------------------------------------------------------
    //MARK: - Memory management
    //----------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
       
    }
    
    //----------------------------------------------------------------------------
    //MARK: - Custome Methods
    //----------------------------------------------------------------------------
    //Desc:- Centre method to call Of View Config.
    func setUpView(){
        
        var titleText : String = ""
        var loadUrl = "https://www.google.de/"
        
        if self.urlType == .termsNcondition {
            titleText = kTermsCondition
            loadUrl = APIURL.shared.getAppUrls().termCondition
        }
        else if self.urlType == .privacyPolicy{
            titleText = kPrivacyPolicy
            loadUrl = APIURL.shared.getAppUrls().privacyPolicy
        }
        self.title = titleText
        self.webKitView.load(URLRequest(url: loadUrl.url()))
    }
    

    //----------------------------------------------------------------------------
    //MARK: - Action Methods
    //----------------------------------------------------------------------------
    
    @IBAction func btnBackTapped(_ sender : Any){
        self.navigationController?.popViewController(animated: true)
    }
 
    
    //----------------------------------------------------------------------------
    //MARK: - View life cycle
    //----------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.webKitView.navigationDelegate = self
        self.webKitView.backgroundColor = .clear
        self.webKitView.frame = CGRect(x: 0, y: self.navView.bounds.height + 30, width: kScreenWidth, height: kScreenHeight - (kScreenHeight > ScreenHeightResolution.height667.rawValue ? 100 : 60))
        self.view.addSubview(self.webKitView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

}
