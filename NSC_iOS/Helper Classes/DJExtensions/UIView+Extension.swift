//
//  UIView+Extension.swift
//


import Foundation
import UIKit

enum NLInnerShadowDirection : Int {
    case none = 0
    case left = 1
    case right = 2
    case top = 3
    case bottom = 4
    case all = 5
}

// MARK: - UIView Extension -
extension UIView {
    
    func constrainCentered(_ subview: UIView) {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        let verticalContraint = NSLayoutConstraint(
            item: subview,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: 1.0,
            constant: 0)
        
        let horizontalContraint = NSLayoutConstraint(
            item: subview,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerX,
            multiplier: 1.0,
            constant: 0)
        
        let heightContraint = NSLayoutConstraint(
            item: subview,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: subview.frame.height)
        
        let widthContraint = NSLayoutConstraint(
            item: subview,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: subview.frame.width)
        
        addConstraints([
            horizontalContraint,
            verticalContraint,
            heightContraint,
            widthContraint])
        
    }
    
    func constrainToEdges(_ subview: UIView) {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        let topContraint = NSLayoutConstraint(
            item: subview,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1.0,
            constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(
            item: subview,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1.0,
            constant: 0)
        
        let leadingContraint = NSLayoutConstraint(
            item: subview,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self,
            attribute: .leading,
            multiplier: 1.0,
            constant: 0)
        
        let trailingContraint = NSLayoutConstraint(
            item: subview,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self,
            attribute: .trailing,
            multiplier: 1.0,
            constant: 0)
        
        addConstraints([
            topContraint,
            bottomConstraint,
            leadingContraint,
            trailingContraint])
    }
    
    func dropShadowLayer() {
        let shadowLayerNew = self.layer.sublayers?[0]
        
        if shadowLayerNew?.accessibilityLabel != "shadowlayer" {
            let shadowLayer = CAShapeLayer()
            shadowLayer.accessibilityLabel = "shadowlayer"
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 2
            
            layer.insertSublayer(shadowLayer, at: 0)
            //layer.insertSublayer(shadowLayer, below: nil) // also works
        }
    }
    
    func applyBorderView(cornderRadius :CGFloat = 15, backgroundColor : UIColor = .white, borderColor : UIColor = .colorAppTxtFieldGray, borderWidth : CGFloat = 1.0){
        self.layer.cornerRadius = cornderRadius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.backgroundColor = backgroundColor
    }
    
    // OUTPUT 1
    func dropShadow(shadowColor : UIColor = .colorAppTxtFieldGray.withAlphaComponent(0.5), shadowOffSet : CGSize = CGSize(width: 1, height: 1), shadowOpacity : Float = 1.0, shadowRadius : CGFloat = 3.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffSet
        self.layer.shadowRadius = shadowRadius
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        //        mask.shadowColor = UIColor.white.cgColor
        //        mask.shadowOffset = CGSize(width: 0, height: 0)
        //        mask.shadowRadius = 50
        //        mask.shadowOpacity = 1
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func removeSubviews (){
        subviews.forEach({ $0.removeFromSuperview() })
    }
    
    func setConstraintConstant(_ constant: CGFloat, forAttribute attribute: NSLayoutConstraint.Attribute) -> Bool {
        let constraint: NSLayoutConstraint? = self.constraintForAttribute(attribute)
        if constraint != nil {
            constraint!.constant = constant
            return true
        }
        else {
            self.superview!.addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: constant))
            return false
        }
    }
    
    func addDashedBorder() {
        let color = UIColor.black.withAlphaComponent(0.5).cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1.5
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.cornerRadius = 0
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 0).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func constraintConstantforAttribute(_ attribute: NSLayoutConstraint.Attribute) -> CGFloat {
        let constraint: NSLayoutConstraint? = self.constraintForAttribute(attribute)
        if constraint != nil {
            return constraint!.constant
        }
        else {
            return CGFloat(nan: CGFloat.RawSignificand.init(), signaling: true)
        }
    }
    
    func constraintForAttribute(_ attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        let predicate: NSPredicate = NSPredicate(format: "firstAttribute = %d && firstItem = %@", attribute.rawValue, self)
        let fillteredArray: [NSLayoutConstraint]? = (self.superview!.constraints as [NSObject] as NSArray).filtered(using: predicate) as? [NSLayoutConstraint]
        if fillteredArray!.count == 0 {
            return nil
        }
        else {
            return fillteredArray![0]
        }
    }
    
    class var nibName: String {
        let name = "\(self)".components(separatedBy: ".").first ?? ""
        return name
    }
    
    class var nib: UINib? {
        if let _ = Bundle.main.path(forResource: nibName, ofType: "nib") {
            return UINib(nibName: nibName, bundle: nil)
        }
        else {
            return nil
        }
    }
    
    func removeInnerShadow() {
        for view in self.subviews {
            if (view.tag == 2639) {
                view.removeFromSuperview()
                break
            }
        }
    }
    
    func addInnerShadow() {
        let c = UIColor()
        let color = c.withAlphaComponent(0.5)
        self.addInnerShadowWithRadius(3.0, color: color, inDirection: NLInnerShadowDirection.all)
    }
    
    func addInnerShadowWithRadius(_ radius: CGFloat, andAlpha: CGFloat) {
        let c = UIColor()
        let color = c.withAlphaComponent(alpha)
        
        self.addInnerShadowWithRadius(radius, color: color, inDirection: NLInnerShadowDirection.all)
    }
    
    func addInnerShadowWithRadius(_ radius: CGFloat, andColor: UIColor) {
        self.addInnerShadowWithRadius(radius, color: andColor, inDirection: NLInnerShadowDirection.all)
    }
    
    func addInnerShadowWithRadius(_ radius: CGFloat, color: UIColor, inDirection: NLInnerShadowDirection) {
        self.removeInnerShadow()
        
        let shadowView = self.createShadowViewWithRadius(radius, andColor: color, direction: inDirection)
        shadowView.isUserInteractionEnabled = false
        self.addSubview(shadowView)
    }
    
    func createShadowViewWithRadius(_ radius: CGFloat, andColor: UIColor, direction: NLInnerShadowDirection) -> UIView {
        let shadowView = UIView(frame: CGRect(x: 0,y: 0,width: self.bounds.size.width,height: self.bounds.size.height))
        shadowView.backgroundColor = UIColor.clear
        shadowView.tag = 2639
        
        let colorsArray: Array = [ andColor.cgColor, UIColor.clear.cgColor ]
        
        if direction == .top {
            let xOffset: CGFloat = 0.0
            let topWidth = self.bounds.size.width
            
            let shadow = CAGradientLayer()
            shadow.colors = colorsArray
            shadow.startPoint = CGPoint(x: 0.5,y: 0.0)
            shadow.endPoint = CGPoint(x: 0.5,y: 1.0)
            shadow.frame = CGRect(x: xOffset,y: 0,width: topWidth,height: radius)
            shadowView.layer.insertSublayer(shadow, at: 0)
        }
        
        if direction == .bottom {
            let xOffset: CGFloat = 0.0
            let bottomWidth = self.bounds.size.width
            
            let shadow = CAGradientLayer()
            shadow.colors = colorsArray
            shadow.startPoint = CGPoint(x: 0.5,y: 1.0)
            shadow.endPoint = CGPoint(x: 0.5,y: 0.0)
            shadow.frame = CGRect(x: xOffset,y: self.bounds.size.height - radius,width: bottomWidth,height: radius)
            shadowView.layer.insertSublayer(shadow, at: 0)
        }
        
        if direction == .left {
            let yOffset: CGFloat = 0.0
            let leftHeight = self.bounds.size.height
            
            let shadow = CAGradientLayer()
            shadow.colors = colorsArray
            shadow.frame = CGRect(x: 0,y: yOffset,width: radius,height: leftHeight)
            shadow.startPoint = CGPoint(x: 0.0,y: 0.5)
            shadow.endPoint = CGPoint(x: 1.0,y: 0.5)
            shadowView.layer.insertSublayer(shadow, at: 0)
        }
        
        if direction == .right {
            let yOffset: CGFloat = 0.0
            let rightHeight = self.bounds.size.height
            
            let shadow = CAGradientLayer()
            shadow.colors = colorsArray
            shadow.frame = CGRect(x: self.bounds.size.width - radius,y: yOffset,width: radius,height: rightHeight)
            shadow.startPoint = CGPoint(x: 1.0,y: 0.5)
            shadow.endPoint = CGPoint(x: 0.0,y: 0.5)
            shadowView.layer.insertSublayer(shadow, at: 0)
        }
        
        return shadowView
    }
    
    func addshadow () {
        layer.cornerRadius = 0
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0.5,height: -0.5)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
    }
    
    func takeScreenshot() -> UIImage {
        
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func screenshot() -> UIImage {
        return UIGraphicsImageRenderer(size: bounds.size).image { _ in
            drawHierarchy(in: CGRect(origin: .zero, size: bounds.size), afterScreenUpdates: true)
        }
    }
    
}

extension UIView {
    
    func applyGradient(with colours: [UIColor], locations: [NSNumber]? = nil) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.accessibilityHint = "gradient"
        self.layer.sublayers?.forEach({
            if $0.accessibilityHint == "gradient" {
                $0.removeFromSuperlayer()
            }
        })
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}
