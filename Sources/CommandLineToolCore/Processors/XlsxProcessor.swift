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
    }
    
    private static var sharedString: SharedStrings?
    
    private static var terms = [XlsxValue]()
    private static var segments = [String: [XlsxValue?]]()
    
    // TODO: (msm) Change default walues
    static internal func loadSpreadsheet(path: String, sheetPath: String, keysRow: Int, termColumn: String = "B", keysFrom: String = "C", keysTo: String = "C") throws {
        guard let xlsxFile = XLSXFile(filepath: path) else {
            throw XlsxProcessorErrors.xlsxFileNotInitialized
        }
        
        sharedString = try xlsxFile.parseSharedStrings()
        let paths = try xlsxFile.parseWorksheetPaths()
        let worksheet = try xlsxFile.parseWorksheet(at: "xl/worksheets/sheet1.xml") // TODO: (msm) Problem with sheets name
        
        try worksheet.data?.rows.forEach { row in
            
            try row.cells.forEach { cell in
                
                switch cell.reference.column.value {
                case termColumn:
                    terms.append( (cell.reference.row, termColumn, try convert(cell)) )
                case keysFrom...keysTo:
                    if row.reference == keysRow, let segmentName = try convert(cell) {
                        segments[segmentName] = [XlsxValue?]()
                    } else {
                        segments[
                    }
                    print("words - \(cell)")
                default:
                    print(cell)
                }
            }
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
