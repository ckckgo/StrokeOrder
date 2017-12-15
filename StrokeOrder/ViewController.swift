//
//  ViewController.swift
//  StrokeOrder
//
//  Created by Henry on 05/12/2017.
//  Copyright © 2017 Henry. All rights reserved.
//

import UIKit
import SQLite3


class ViewController: UIViewController {
    
    @IBOutlet weak var drawView: WordView!
    private var animation: CABasicAnimation!
    private var word: Word!
    private var index = 0
    
    
    func openDataBase() -> OpaquePointer? {
        var db: OpaquePointer? = nil
        let path = Bundle.main.path(forResource: "strokes", ofType: "db")!
        if sqlite3_open(path, &db) == SQLITE_OK {
            print("Successfully opened connect to database at \(path)")
            return db!
        } else {
            print("Unable to  opened database!")
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let db = openDataBase()
        let sql = "select * from t_stroke where code=31119"
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, sql, -1, &queryStatement, nil) == SQLITE_OK {
            print("query success")
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                let character = String(cString: queryResultCol1!)
                let stroke = String(cString: sqlite3_column_text(queryStatement, 3)!)
                let median = String(cString: sqlite3_column_text(queryStatement, 4)!)
                
                let strokePath = SVGTools.generateStrokePath(with: stroke)
                
                
                let word1 = Word.init(character: character, strokeString: stroke, medianString: median)
                
                self.drawView.drawWord(word1!)
                
            } else {
                print("nothing to find")
            }
        } else {
            print("query failed")
        }
        
        
    }
}

