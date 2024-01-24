//
//  UIImageView+Classes.swift
//  NSC_iOS
//
//  Created by vishal parmar on 30/09/23.
//

import Foundation
import UIKit

class ProfileImageViewWithBorder : UIImageView{
    
    var borderWidthImg : CGFloat = 5.0{
        didSet{
            self.applyStyle()
        }
    }
    
    var borderColorImg : UIColor = .white{
        didSet{
            self.applyStyle()
        }
    }
    
    var isRound : Bool = true {
        didSet{
            self.applyStyle()
        }
    }
    
    var corderRadiusImg : CGFloat = 10{
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
        
        if self.isRound{
            self.layer.cornerRadius = self.frame.size.height / 2
        }
        else{
            self.layer.cornerRadius = self.corderRadiusImg
        }
        
        
        self.layer.borderWidth = self.borderWidthImg
        self.layer.borderColor = self.borderColorImg.cgColor
        
//        if isDropShodow{
//            self.dropShadow(color: .colorAppTxtFieldGray, offSet: CGSize(width: 1, height: 1))
//        }
    }
 }

class ProfileRoundImageViewClass : UIImageView{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyStyle()
    }
    
    private func applyStyle() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}
