//
//  AttributedString+Extension.swift
//  NSC_iOS
//
//  Created by vishal parmar on 03/10/23.
//

import Foundation


extension NSMutableAttributedString {
    
    func setAttributes(color: UIColor? = nil, forText stringValue: String,font : CGFloat,fontname : CustomFont) {
        
        var textFontStyle  : UIFont!
        var textColor : UIColor!
        var textFont : CGFloat!
        if color != nil{
            
            textColor = color
            
        }else{
            textColor = UIColor.black
        }
        
        if font == 0.0{
            
            textFont = CGFloat(kMediumFontSize)
        }else{
            
            textFont = CGFloat(font)
        }
        
        textFontStyle = UIFont.applyCustomFont(fontName: fontname, fontSize: textFont)
        
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttributes([NSAttributedString.Key.foregroundColor : textColor ,NSAttributedString.Key.font : textFontStyle], range:range)
    }
}
