//
//  UIFont+Extension.swift
//  NSC_iOS
//
//  Created by vishal parmar on 28/09/23.
//

import Foundation
import UIKit


enum CustomFont : String {
    
    //MARK: - Poppins Font Family
    
    case PoppinsMedium              = "Poppins-Medium"
    case PoppinsSemibol             = "Poppins-SemiBold"
    case PoppinsBold                = "Poppins-Bold"
    case PoppinsRegular             = "Poppins-Regular"
    case PoppinsLight               = "Poppins-Light"
    case PoppinsExtraBold           = "Poppins-ExtraLight"
    
    case SFProDisplayRegular = "SFProDisplay-Regular"
    
    case SFProDisplayUltralightItalic = "SFProDisplay-UltralightItalic"
    
    case SFProDisplayThinItalic = "SFProDisplay-ThinItalic"
    
    case SFProDisplayLightItalic = "SFProDisplay-LightItalic"
    
    case SFProDisplayMedium = "SFProDisplay-Medium"
    
    case SFProDisplaySemiboldItalic = "SFProDisplay-SemiboldItalic"
    
    case SFProDisplayBold = "SFProDisplay-Bold"
    
    case SFProDisplayHeavyItalic = "SFProDisplay-HeavyItalic"
    
    case SFProDisplayBlackItalic = "SFProDisplay-BlackItalic"
    
    case SFProDisplaySemibold = "SFProDisplay-Semibold"
    
}


extension UIFont {

    class func applyCustomFont(fontName : CustomFont,fontSize : CGFloat ,isAspectRasio : Bool = true)-> UIFont{
        if isAspectRasio{
            return UIFont.init(name: fontName.rawValue , size: fontSize * kFontAspectRatio)!
            
        }else{
            return UIFont.init(name: fontName.rawValue, size: fontSize)!
        }
    }
}
