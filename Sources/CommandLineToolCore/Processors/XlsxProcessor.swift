//
//  XlsxProcessor.swift
//  CommandLineTool
//
//  Created by Mateusz Śmigowski on 18.12.18.
//

import Foundation
import CoreXLSX

public typealias XlsxValue = (row: UInt, column: String, value: String?)

public final class XlsxProcessor {
    
    public enum XlsxProcessorErrors: Error {
        case xlsxFileNotInitialized
        case emptySharedStrings
        case wrongReferenceStringId
        case emptyData
    }
    
    private static var sharedString: SharedStrings?
    
    private static var terms = [XlsxValue]()
    private static var keys = [XlsxValue]()
    private static var content = [XlsxValue]()
    
    // TODO: (msm) Change default walues
    static internal func loadSpreadsheet(path: String, sheetPath: String, keysRow: Int, termColumn: String = "B", keysFrom: String = "C", keysTo: String = "C") throws {
        guard let xlsxFile = XLSXFile(filepath: path) else {
            throw XlsxProcessorErrors.xlsxFileNotInitialized
        }
        
        sharedString = try xlsxFile.parseSharedStrings()
//        let paths = try xlsxFile.parseWorksheetPaths()s
        let worksheet = try xlsxFile.parseWorksheet(at: "xl/worksheets/sheet1.xml") // TODO: (msm) Problem with sheets name
        
        guard let rows = worksheet.data?.rows else {
            throw XlsxProcessorErrors.emptyData
        }
        
        // This implementation needs to be disscused, maybe there is
        // better solution to structurize model (terms, keys, content)
        for row in rows {
            
            for cell in row.cells {
                
                let column = cell.reference.column.value
                let convertedCell = try convert(cell)
                
                switch column {
                case termColumn:
                    terms.append( (row.reference, column, convertedCell) )
                case keysFrom...keysTo:
                    if row.reference == keysRow {
                        keys.append( (row.reference, column, convertedCell) )
                    } else {
                        content.append( (row.reference, column, convertedCell) )
                    }
                default:
                    break
                }
                
            }
            
        }
        
        
    }
    
    static private func concise(keys: [XlsxValue], andContent content: [XlsxValue]) {
        var dict = [String: [XlsxValue]]()
        
        for key in keys {
            guard let keyValue = key.value else { continue }
            
            dict[keyValue] = [XlsxValue]()
        }
    }
    
    static private func convert(_ cell: Cell) throws -> String? {
        guard cell.type == "s" else {
            return cell.value
        }
        guard let stringIndex = cell.value, let index = Int(stringIndex) else {
            throw XlsxProcessorErrors.wrongReferenceStringId
        }
        guard let sharedString = sharedString else {
            throw XlsxProcessorErrors.emptySharedStrings
        }
        
        return sharedString.items[index].text
    }
}
