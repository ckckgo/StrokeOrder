//
//  WordView.swift
//  StrokeOrder
//
//  Created by Henry on 05/12/2017.
//  Copyright © 2017 Henry. All rights reserved.
//

import UIKit

class WordView: UIImageView {
    
    private struct Constants {
        static let bgLineColor: UIColor = .red
        static let bgBorderLineWidth: CGFloat = 3
        static let bgDashLineWidth: CGFloat = 1
    }

    var word: Word? = nil
    var strokeIndex: Int = 0
    
    lazy var bgImage: UIImage = createBgImage(self.bounds.size)
    lazy var animation:CABasicAnimation = createAnimation()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.image = bgImage
    }
    
    public func drawWord(_ word: Word) -> Void {
        self.word = word
        
        drawOrganic()
        
        strokeIndex = 0
        drawStroke()
    }
    
    private func drawOrganic() -> Void {
        let organicLayer = CAShapeLayer()
        organicLayer.fillColor = UIColor.lightGray.cgColor
        organicLayer.path = word!.outline.cgPath
        organicLayer.setAffineTransform(CGAffineTransform.init(scaleX: frame.width/1024, y: -frame.height/1024).translatedBy(x: 0, y: -900))
        layer.addSublayer(organicLayer)
    }
    
    private func drawStroke() -> Void {
        let stroke = word!.strokes[strokeIndex]
        let strokeOutline = stroke.outline
        let strokeMedian = stroke.median
        
        
        let clipLayer = CAShapeLayer()
        clipLayer.fillColor = UIColor.lightGray.cgColor
        clipLayer.path = strokeOutline.cgPath
        
        let drawLayer = CAShapeLayer()
        drawLayer.strokeColor = UIColor.red.cgColor
        drawLayer.fillColor = UIColor.clear.cgColor
        drawLayer.path = strokeMedian.cgPath
        drawLayer.lineWidth = 128
        drawLayer.lineJoin = kCALineJoinRound
        drawLayer.lineCap = kCALineCapRound
        drawLayer.setAffineTransform(CGAffineTransform.init(scaleX: frame.width/1024, y: -frame.height/1024).translatedBy(x: 0, y: -900))
        drawLayer.add(animation, forKey: "path")
        drawLayer.mask = clipLayer
        layer.addSublayer(drawLayer)
    }
}

extension WordView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if strokeIndex < word!.strokes.count-1 {
            strokeIndex = strokeIndex + 1
            drawStroke()
        }
    }
}

extension WordView {
    
    func createAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation.init(keyPath: "strokeEnd")
        animation.duration = 3.0
        animation.fromValue = 0
        animation.toValue = 1.0
        animation.delegate = self
        return animation
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
