//
//  EmptyViewClass.swift
//  Neebu
//
//  Created by hyperlink on 01/12/21.
//  Copyright © 2021 hyperlink. All rights reserved.
//

import Foundation

class EmptyViewClass: UIView {

    
    @IBOutlet weak var lblEmptyViewTitle : UILabel!
    @IBOutlet weak var btnActionButton : AppThemeBorderButton!
    
    static let shared : EmptyViewClass = EmptyViewClass()
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.lblEmptyViewTitle.applyLabelStyle(fontSize: 13.0, fontName: .SFProDisplayRegular)
        self.btnActionButton.isHidden = true
    }
        
    func showEmptyView(title : String = "",actionButtonTitle : String) ->UIView{
        
        let emptyView : EmptyViewClass = UIView.fromNib()
        
        emptyView.lblEmptyViewTitle.text = title
        
        emptyView.btnActionButton!.setTitle(actionButtonTitle, for: .normal)
        
//        emptyView.btnActionButton.handleTapToAction {
//
//            let updatedData : JSON = [
//                "action" : true
//            ]
//
//            NotificationCenter.default.post(name: NSNotification.Name.emptyViewReturnAction, object: updatedData)
//        }
        return emptyView
    }
    
    @IBAction func btnActionTapped(_ sender : UIButton){
     
        debugPrint("Tapped..!")
    }
}
