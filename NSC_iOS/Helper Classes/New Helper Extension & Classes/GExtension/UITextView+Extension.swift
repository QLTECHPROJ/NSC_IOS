//
//  UITextView+Extension.swift
//  NSC_iOS
//
//  Created by vishal parmar on 03/10/23.
//

import Foundation
import UIKit

extension UITextView{
    
    open override func awakeFromNib() {
        super.awakeFromNib()

        self.keyboardAppearance = .dark
        if #available(iOS 10.0, *) {
            self.adjustsFontForContentSizeCategory = true
        }
    }
    
    func applyTextViewStyle(fontSize : CGFloat? = kMediumFontSize,fontName : CustomFont,textColor : UIColor = .colorAppTextBlack){
        
        self.textColor = textColor
        self.font = UIFont.applyCustomFont(fontName: fontName, fontSize: fontSize!)
    }
}
