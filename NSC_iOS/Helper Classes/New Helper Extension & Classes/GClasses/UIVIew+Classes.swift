//
//  UIVIew+Classes.swift
//  NSC_iOS
//
//  Created by vishal parmar on 28/09/23.
//

import Foundation
import UIKit

class AppThemeBorderViewClass : UIView {
    
    
    var backgroundColorForView : UIColor = .white{
        didSet{
            self.applyStyle()
        }
    }
    
    var isDropShodow : Bool = false{
        didSet{
            self.applyStyle()
        }
    }
    
    var borderWidthForVW : CGFloat = 1.5{
        didSet{
            self.applyStyle()
        }
    }

    var borderColorForVW : UIColor = .colorAppThemeOrange{
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
    
    private func applyStyle() {
        self.layer.cornerRadius = 15
        
        self.backgroundColor = self.backgroundColorForView
        self.layer.borderWidth = self.borderWidthForVW
        self.layer.borderColor = self.borderColorForVW.cgColor
        
        if isDropShodow{
            self.dropShadow(color: .colorAppTxtFieldGray, offSet: CGSize(width: 1, height: 1))
        }
    }
}


class SemiCirleView: UIView {
    
    var semiCirleLayer: CAShapeLayer = CAShapeLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let arcCenter = CGPoint(x: bounds.size.width / 2, y: bounds.size.height)
        let circleRadius = bounds.size.width / 2
        let circlePath = UIBezierPath(arcCenter: arcCenter, radius: circleRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 2, clockwise: true)
        
        semiCirleLayer.path = circlePath.cgPath
        semiCirleLayer.fillColor = UIColor.colorAppThemeOrange.cgColor
        
        semiCirleLayer.name = "RedCircleLayer"
        
        if !(layer.sublayers?.contains(where: {$0.name == "RedCircleLayer"}) ?? false) {
            layer.addSublayer(semiCirleLayer)
        }
        
        // Make the view color transparent
        backgroundColor = UIColor.clear
        UIView.animate(withDuration: 1, delay: 1) {
            self.transform = CGAffineTransform(rotationAngle: CGFloat.pi / -1)
        }
    }
}

class ShadowNavigationView: UIView {
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.alpha = 0
        UIView.animate(withDuration: 1) {
            self.alpha = 1
        }
        
        self.backgroundColor = .white
        self.dropShadow(shadowOffSet : CGSize(width: -0, height: 10), shadowRadius : 10.0)
        self.layer.cornerRadius = 25
    }
}


class AppShadowViewClass : UIView{
    
    var cornerRadiusVW : CGFloat = 15 {
        didSet{
            self.applyViewStyle()
        }
    }
    
    var isRound : Bool = false{
        didSet{
            self.applyViewStyle()
        }
    }
    
    var shadowColorVW : CGColor = UIColor(red: 0.827, green: 0.82, blue: 0.847, alpha: 0.7).cgColor{//UIColor.colorAppTxtFieldGray.cgColor {
        didSet{
            self.applyViewStyle()
        }
    }
    
    var borderColorVW : CGColor = UIColor.colorAppTxtFieldGray.cgColor {
        didSet{
            self.applyViewStyle()
        }
    }
    
    var borderWidthVW : CGFloat = 1.5 {
        didSet{
            self.applyViewStyle()
        }
    }
    
    var isShadow : Bool = true{
        didSet{
            self.applyViewStyle()
        }
    }

    var shadowOffSetSize : CGSize = CGSize(width: 7, height: 7){//CGSize(width: 15.0, height: 15.0){
        didSet{
            self.applyViewStyle()
        }
    }
    
    var shadowRadiusSize : CGFloat = 15{//30{
        didSet{
            self.applyViewStyle()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.applyViewStyle()
    }
    
    private func applyViewStyle(){
        
        if isRound{
            self.layer.cornerRadius = self.frame.height / 2
        }
        else{
            self.layer.cornerRadius = self.cornerRadiusVW
        }
        
        if isShadow{
            self.layer.masksToBounds = false
            self.layer.shadowColor = self.shadowColorVW
            self.layer.shadowOpacity = 1
            self.layer.shadowOffset = self.shadowOffSetSize
            self.layer.shadowRadius = self.shadowRadiusSize
            self.layer.borderColor = UIColor.clear.cgColor
        }
        else{
            self.layer.borderColor = self.borderColorVW
            self.layer.borderWidth = self.borderWidthVW
        }
    }
}
