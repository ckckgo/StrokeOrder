//
//  SVGTool.swift
//  StrokeOrder
//
//  Created by Henry on 05/12/2017.
//  Copyright © 2017 Henry. All rights reserved.
//

import UIKit

protocol PathCommand {
    func execute(to path: UIBezierPath) -> Void
}

class MoveToCommand: PathCommand {
    var targetPoint: CGPoint
    
    init(targetPoint: CGPoint) {
        self.targetPoint = targetPoint
    }
    
    func execute(to path: UIBezierPath) -> Void {
        path.move(to: targetPoint)
    }
}

class LineToCommand: PathCommand {
    var targetPoint: CGPoint
    
    init(targetPoint: CGPoint) {
        self.targetPoint = targetPoint
    }
    
    func execute(to path: UIBezierPath) -> Void {
        path.addLine(to: targetPoint)
    }
}

class QuadCurveCommand: PathCommand {
    var targetPoint: CGPoint
    var controlPoint: CGPoint
    
    init(targetPoint: CGPoint, controlPoint: CGPoint) {
        self.targetPoint = targetPoint
        self.controlPoint = controlPoint
    }
    
    func execute(to path: UIBezierPath) -> Void {
        path.addQuadCurve(to: targetPoint, controlPoint: controlPoint)
    }
}

class CloseCommand: PathCommand {
    func execute(to path: UIBezierPath) -> Void {
        path.close()
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

    static func generateMedianPath(with medianArray: Array<Array<CGFloat>>) -> UIBezierPath? {
        let medianPath = UIBezierPath()
        medianPath.move(to: CGPoint(x: medianArray[0][0], y: medianArray[0][1]))
        
        for index in 1..<medianArray.count {
            medianPath.addLine(to: CGPoint(x: medianArray[index][0], y: medianArray[index][1]))
        }
        return medianPath
    }
    
    
    static func generateStrokePath(with strokeArray: Array<String>) -> UIBezierPath? {
        var str = String()
        for index in 0..<strokeArray.count {
            str.append(strokeArray[index])
        }
        return generateStrokePath(with: str)
    }
    
    static func generateStrokePath(with strokeStr: String) -> UIBezierPath? {
        let regex = "M\\s?\\-?[1-9]\\d*\\s\\-?[1-9]\\d*|Q\\s?\\-?[1-9]\\d*\\s\\-?[1-9]\\d*\\s\\-?[1-9]\\d*\\s\\-?[1-9]\\d*|L\\s?\\-?[1-9]\\d*\\s\\-?[1-9]\\d*|Z"
        guard let regular = try? NSRegularExpression.init(pattern: regex, options: .caseInsensitive) else {
            return nil
        }
        
        let matches = regular.matches(in: strokeStr, options: [], range: NSRange(location: 0, length: (strokeStr as NSString).length))
        
        let path = UIBezierPath()
        for match in matches {
            let range = match.range
            let matchStr = (strokeStr as NSString).substring(with: range)
            let command =  CommandGenerator.generateCommnad(with: matchStr)
            command?.execute(to: path)
        }
        return path
    }
    
}
