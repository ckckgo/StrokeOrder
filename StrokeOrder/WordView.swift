//
//  WordView.swift
//  StrokeOrder
//
//  Created by Henry on 05/12/2017.
//  Copyright © 2017 Henry. All rights reserved.
//

import UIKit

class WordView: UIImageView {

    lazy var bgImage: UIImage = self.createBgImage(self.bounds.size)
    
    private struct Constants {
        static let bgLineColor: UIColor = .red
        static let bgBorderLineWidth: CGFloat = 3
        static let bgDashLineWidth: CGFloat = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        self.image = bgImage
    }
    
    func createBgImage(_ size: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        context.setStrokeColor(Constants.bgLineColor.cgColor)
        
        let dashPath = UIBezierPath()
        dashPath.move(to: CGPoint(x: 0, y: 0))
        dashPath.addLine(to: CGPoint(x: size.width, y: size.height))
        dashPath.move(to: CGPoint(x: size.width, y: 0))
        dashPath.addLine(to: CGPoint(x:0, y: size.height))
        dashPath.move(to: CGPoint(x: 0, y: size.height/2))
        dashPath.addLine(to: CGPoint(x: size.width, y: size.height/2))
        dashPath.move(to: CGPoint(x: size.width/2, y: 0))
        dashPath.addLine(to: CGPoint(x: size.width/2, y: size.height))
        context.saveGState()
        context.setLineDash(phase: 3, lengths: [3])
        dashPath.lineWidth = Constants.bgDashLineWidth
        dashPath.stroke()
        context.restoreGState()
        
        let borderPath = UIBezierPath.init(rect: CGRect(x: Constants.bgBorderLineWidth / 2,
                                                        y: Constants.bgBorderLineWidth/2,
                                                        width: size.width-Constants.bgBorderLineWidth,
                                                        height: size.height-Constants.bgBorderLineWidth));
        borderPath.lineWidth = Constants.bgBorderLineWidth
        borderPath.stroke()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

}
