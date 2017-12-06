//
//  ViewController.swift
//  StrokeOrder
//
//  Created by Henry on 05/12/2017.
//  Copyright © 2017 Henry. All rights reserved.
//

import UIKit

/**
 {"character":"一","strokes":["M 518 382 Q 572 385 623 389 Q 758 399 900 383 Q 928 379 935 390 Q 944 405 930 419 Q 896 452 845 475 Q 829 482 798 473 Q 723 460 480 434 Q 180 409 137 408 Q 130 408 124 408 Q 108 408 106 395 Q 105 380 127 363 Q 146 348 183 334 Q 195 330 216 338 Q 232 344 306 354 Q 400 373 518 382 Z"],"medians":[[[121,393],[193,372],[417,402],[827,434],[920,401]]]}
 
 
 758 399 900 383 Q 928 379    Q     Q     Q     Q     Q     Q     Q     Q     Q     Q     Q     Q     Z"],"medians":[[[121,393],[193,372],[417,402],[827,434],[920,401]]]}
 */

class ViewController: UIViewController {
    
    @IBOutlet weak var drawView: WordView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let organicPath = UIBezierPath()
        organicPath.move(to: CGPoint(x: 518, y: 382))
        organicPath.addQuadCurve(to: CGPoint(x: 623, y: 389), controlPoint: CGPoint(x: 572, y: 385))
        organicPath.addQuadCurve(to: CGPoint(x: 900, y: 383), controlPoint: CGPoint(x: 758, y: 399))
        organicPath.addQuadCurve(to: CGPoint(x: 935, y: 390), controlPoint: CGPoint(x: 928, y: 379))
        organicPath.addQuadCurve(to: CGPoint(x: 930, y: 419), controlPoint: CGPoint(x: 944, y: 405))
        organicPath.addQuadCurve(to: CGPoint(x: 845, y: 475), controlPoint: CGPoint(x: 896, y: 452))
        organicPath.addQuadCurve(to: CGPoint(x: 798, y: 473), controlPoint: CGPoint(x: 829, y: 482))
        organicPath.addQuadCurve(to: CGPoint(x: 480, y: 434), controlPoint: CGPoint(x: 723, y: 460))
        organicPath.addQuadCurve(to: CGPoint(x: 137, y: 408), controlPoint: CGPoint(x: 180, y: 409))
        organicPath.addQuadCurve(to: CGPoint(x: 124, y: 408), controlPoint: CGPoint(x: 130, y: 408))
        organicPath.addQuadCurve(to: CGPoint(x: 106, y: 395), controlPoint: CGPoint(x: 108, y: 408))
        organicPath.addQuadCurve(to: CGPoint(x: 127, y: 363), controlPoint: CGPoint(x: 105, y: 380))
        organicPath.addQuadCurve(to: CGPoint(x: 183, y: 334), controlPoint: CGPoint(x: 146, y: 348))
        organicPath.addQuadCurve(to: CGPoint(x: 216, y: 338), controlPoint: CGPoint(x: 195, y: 330))
        organicPath.addQuadCurve(to: CGPoint(x: 306, y: 354), controlPoint: CGPoint(x: 232, y: 344))
        organicPath.addQuadCurve(to: CGPoint(x: 518, y: 382), controlPoint: CGPoint(x: 400, y: 373))
        organicPath.close()
        
        let organicLayer = CAShapeLayer()
        organicLayer.fillColor = UIColor.lightGray.cgColor
        organicLayer.path = organicPath.cgPath
        organicLayer.setAffineTransform(CGAffineTransform.init(scaleX: drawView.frame.width/1024, y: -drawView.frame.height/1024).translatedBy(x: 0, y: -900))
        drawView.layer.addSublayer(organicLayer)
        
        let drawPath = UIBezierPath()
        drawPath.move(to: CGPoint(x: 121, y: 393))
        drawPath.addLine(to: CGPoint(x: 193, y: 372))
        drawPath.addLine(to: CGPoint(x: 417, y: 402))
        drawPath.addLine(to: CGPoint(x: 827, y: 434))
        drawPath.addLine(to: CGPoint(x: 920, y: 401))

        let drawLayer = CAShapeLayer()
        drawLayer.strokeColor = UIColor.red.cgColor
        drawLayer.fillColor = UIColor.clear.cgColor
        drawLayer.path = drawPath.cgPath
        drawLayer.lineWidth = 128
        drawLayer.lineJoin = kCALineJoinRound
        drawLayer.lineCap = kCALineCapRound
        drawLayer.setAffineTransform(CGAffineTransform.init(scaleX: drawView.frame.width/1024, y: -drawView.frame.height/1024).translatedBy(x: 0, y: -900))
        drawView.layer.addSublayer(drawLayer)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = organicPath.cgPath
        drawLayer.mask = maskLayer

        let animation = CABasicAnimation.init(keyPath: "strokeEnd")
        animation.duration = 5.0
        animation.fromValue = 0
        animation.toValue = 1.0
        drawLayer.add(animation, forKey: "path")
        
    }
    
}

