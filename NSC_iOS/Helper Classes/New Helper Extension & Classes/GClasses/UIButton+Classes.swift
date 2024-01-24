//
//  UIButton+Classes.swift
//  NSC_iOS
//
//  Created by vishal parmar on 28/09/23.
//

import Foundation
import UIKit

class AppThemeButton : UIButton {
    
    var isSelect : Bool = false {
        didSet{
            self.applyStyle()
        }
    }
   
    
    var fontStyle : CustomFont = .SFProDisplayBold {
        didSet{
            self.applyStyle()
        }
    }
    
    var cornerRadiusSize : CGFloat = 15 {
        didSet{
            self.applyStyle()
        }
    }
    
    var fontSize : CGFloat = 13 {
        didSet{
            self.applyStyle()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyStyle()
    }
    
    func applyStyle() {
        self.applystyle(isAdjustToFont : true ,cornerRadius: self.cornerRadiusSize, fontname: fontStyle, fontsize: fontSize, bgcolor: isSelect ? UIColor.colorAppThemeOrange : UIColor.colorAppTxtFieldGray, titleColor: .white)
        
        self.dropShadow(color: .colorAppTxtFieldGray, offSet: CGSize(width: 1, height: 1))
        
        self.isUserInteractionEnabled = isSelect
    }
}

class AppThemeBorderButton : UIButton {
    
    var borderWidthForBtn : CGFloat = 1.5{
        didSet{
            self.applyStyle()
        }
    }

    var borderColorForBtn : UIColor = .colorAppThemeOrange{
        didSet{
            self.applyStyle()
        }
    }
    
    var fontStyle : CustomFont = .SFProDisplayBold {
        didSet{
            self.applyStyle()
        }
    }
    
    var cornerRadiusSize : CGFloat = 15 {
        didSet{
            self.applyStyle()
        }
    }
    
    var fontSize : CGFloat = 13 {
        didSet{
            self.applyStyle()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyStyle()
    }
    
    func applyStyle() {
        self.applystyle(isAdjustToFont : true ,cornerRadius: self.cornerRadiusSize, fontname: fontStyle, fontsize: fontSize, bgcolor: .white, titleColor: .colorAppThemeOrange,borderColor: self.borderColorForBtn,borderWidth: self.borderWidthForBtn)
        
    }
}

