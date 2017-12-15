//
//  Word.swift
//  StrokeOrder
//
//  Created by Henry on 08/12/2017.
//  Copyright © 2017 Henry. All rights reserved.
//

import UIKit

struct Stroke {
    let outline: UIBezierPath
    let median: UIBezierPath
}

struct Word {
    let character: String
    let outline: UIBezierPath
    let strokes: Array<Stroke>
    
    public init?(character: String, strokeString: String, medianString: String) {
        
        guard let strokeJson = try? JSONSerialization.jsonObject(with: strokeString.data(using: .utf8)!, options: .allowFragments) as! Array<String> else {
            return nil
        }
        
        guard let medianJson = try? JSONSerialization.jsonObject(with: medianString.data(using: .utf8)!, options: .allowFragments) as! Array<Array<Array<CGFloat>>> else {
            return nil
        }
        
        guard let wordOutline = SVGTools.generateStrokePath(with: strokeJson) else {
            return nil
        }
        
        if strokeJson.count != medianJson.count {
            return nil
        }
        var wordStrokes = Array<Stroke>()
        for index in 0..<strokeJson.count {
            guard let tmpOutline = SVGTools.generateStrokePath(with: strokeJson[index]),
                let tmpMedian = SVGTools.generateMedianPath(with: medianJson[index]) else {
                    return nil
            }
            wordStrokes.append(Stroke(outline: tmpOutline, median: tmpMedian))
        }
        
        self.character = character
        outline = wordOutline
        strokes = wordStrokes
    }
    
    public init?(jsonStr: String) {
        let jsonData = jsonStr.data(using: .utf8)!
        guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] else {
            return nil
        }
        
        guard let wordCharacter = json?["character"] as? String,
            let jsonStrokes = json?["strokes"] as? Array<String>,
            let jsonMedians = json?["medians"] as? Array<Array<Array<CGFloat>>> else {
            return nil
        }
        
        guard let wordOutline = SVGTools.generateStrokePath(with: jsonStrokes) else {
            return nil
        }
        
        if jsonStrokes.count != jsonMedians.count {
            return nil
        }
        var wordStrokes = Array<Stroke>()
        for index in 0..<jsonStrokes.count {
            guard let tmpOutline = SVGTools.generateStrokePath(with: jsonStrokes[index]),
                let tmpMedian = SVGTools.generateMedianPath(with: jsonMedians[index]) else {
                return nil
            }
            wordStrokes.append(Stroke(outline: tmpOutline, median: tmpMedian))
        }
        
        character = wordCharacter
        outline = wordOutline
        strokes = wordStrokes
    }
}
