//
//  CommandLineTool.swift
//  CommandLineTool
//
//  Created by Mateusz Śmigowski on 17.12.18.
//

import Foundation
import CoreXLSX
import Stencil

public final class CommandLineTool {
    private let arguments: [String]
    
    public init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
        
        
    }
    
    public func run() throws {
        print("Hello world")

        do {
            try XlsxProcessor.loadSpreadsheet(path: "./example.xlsx", sheetPath: "Colors", keysRow: 2)
        } catch {
            print(error)
        }
        
//        guard let file = XLSXFile(filepath: "./example.xlsx") else {
//            fatalError("Cannot load file") // TODO: (msm) Change it to exception raise
//        }
//
//        let sharedStrings = try? file.parseSharedStrings()
//
//        for path in try file.parseWorksheetPaths() {
//            let ws = try file.parseWorksheet(at: path)
//            for row in ws.sheetData.rows {
//                for c in row.cells {
//                    if c.type == "s", let strIndex = c.value, let index = Int(strIndex) {
//                        print(sharedStrings?.items[index].text )
//                    }
//                    print(c)
//                }
//            }
//        }
    }
}
