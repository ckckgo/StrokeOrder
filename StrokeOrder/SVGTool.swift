//
//  SVGTool.swift
//  StrokeOrder
//
//  Created by Henry on 05/12/2017.
//  Copyright © 2017 Henry. All rights reserved.
//

import UIKit

protocol PathCommand {
    func execute(to path: UIBezierPath) -> UIBezierPath
}

class MoveToCommand: PathCommand {
    var targetPoint: CGPoint
    
    init(targetPoint: CGPoint) {
        self.targetPoint = targetPoint
    }
    
    func execute(to path: UIBezierPath) -> UIBezierPath {
        path.move(to: targetPoint)
        return path
    }
}

class LineToCommand: PathCommand {
    var targetPoint: CGPoint
    
    init(targetPoint: CGPoint) {
        self.targetPoint = targetPoint
    }
    
    func execute(to path: UIBezierPath) -> UIBezierPath {
        path.addLine(to: targetPoint)
        return path
    }
}

class QuadCurveCommand: PathCommand {
    var targetPoint: CGPoint
    var controlPoint: CGPoint
    
    init(targetPoint: CGPoint, controlPoint: CGPoint) {
        self.targetPoint = targetPoint
        self.controlPoint = controlPoint
    }
    
    func execute(to path: UIBezierPath) -> UIBezierPath {
        path.addQuadCurve(to: targetPoint, controlPoint: controlPoint)
        return path
    }
}

class CloseCommand: PathCommand {
    func execute(to path: UIBezierPath) -> UIBezierPath {
        path.close()
        return path
    }
}

class CommandGenerator {
    static func generateCommnad(with path: String) -> PathCommand? {
        let prefix = (path as NSString).substring(to: 1)
        
        let regex = "-?[1-9]\\d*"
        let regular = try! NSRegularExpression.init(pattern: regex, options: NSRegularExpression.Options.caseInsensitive)
        let matches = regular.matches(in: path, options: [], range: NSRange(location: 0, length: path.lengthOfBytes(using: String.Encoding.utf8)))
        var array = Array<Double>()
        for match in matches {
            let range = match.range
            let number = (path as NSString).substring(with: range)
            array.append(Double(number)!)
        }
        
        switch prefix {
        case "M":
            return MoveToCommand(targetPoint: CGPoint(x: array[0], y: array[1]))
        case "L":
            return LineToCommand(targetPoint: CGPoint(x: array[0], y: array[1]))
        case "Q":
            return QuadCurveCommand(targetPoint: CGPoint(x: array[2], y: array[3]), controlPoint: CGPoint(x: array[0], y: array[1]))
        case "Z":
            return CloseCommand()
        default:
            return nil
        }
    }
}
    /**
     M = moveto
     L = lineto
     H = horizontal lineto
     V = vertical lineto
     C = curveto
     S = smooth curveto
     Q = quadratic Belzier curve
     T = smooth quadratic Belzier curveto
     A = elliptical Arc
     Z = closepath
     */

struct SVGTools {
    static func generatePath(with svgStroke: NSString) ->  UIBezierPath? {
        let regex = "M\\s?\\-?[1-9]\\d*\\s\\-?[1-9]\\d*|Q\\s?\\-?[1-9]\\d*\\s\\-?[1-9]\\d*\\s\\-?[1-9]\\d*\\s\\-?[1-9]\\d*|L\\s?\\-?[1-9]\\d*\\s\\-?[1-9]\\d*|Z"
//        let stroke = "M 518 382 Q 572 385 623 389 Q 758 399 900 383 Q 928 379 935 390 Q 944 405 930 419 Q 896 452 845 475 Q 829 482 798 473 Q 723 460 480 434 Q 180 409 137 408 Q 130 408 124 408 Q 108 408 106 395 Q 105 380 127 363 Q 146 348 183 334 Q 195 330 216 338 Q 232 344 306 354 Q 400 373 518 382 Z"
        
        let regular = try! NSRegularExpression.init(pattern: regex, options: NSRegularExpression.Options.caseInsensitive)
        
        let matches = regular.matches(in: svgStroke as String, options: [], range: NSRange(location: 0, length: svgStroke.length))
        
        let path = UIBezierPath()
        for match in matches {
            let range = match.range
            let matchStr = svgStroke.substring(with: range)
            let command =  CommandGenerator.generateCommnad(with: matchStr)
            command?.execute(to: path)
        }
        return path
    }
}
