//
//  Word.swift
//  StrokeOrder
//
//  Created by Henry on 06/12/2017.
//  Copyright © 2017 Henry. All rights reserved.
//

import UIKit

struct Stroke {
    let outline: UIBezierPath
    let median: UIBezierPath
}

struct Word {
    let word: String
    let code: Int
    let strokes: Array<Stroke>
}
