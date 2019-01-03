//
//  XlsxProcessor.swift
//  CommandLineTool
//
//  Created by Mateusz Śmigowski on 18.12.18.
//

import Foundation
import CoreXLSX


typealias XlsxValue = (row: UInt, column: String, value: String?)

/// - term - row name
/// - key - column name
/// - value - content of cell
//public typealias Segment = (term: String, key: String?, value: String)
typealias Segment = (terms: [XlsxValue], keys: [XlsxValue?], values: [XlsxValue])

public final class XlsxProcessor: Processable {
    
    public enum XlsxProcessorErrors: Error {
        case xlsxFileNotInitialized
        case emptySharedStrings
        case wrongReferenceStringId
        case emptyData
        case noSuchSheetName
    }
    
//    static func processSpreadsheet(config: Config, filePath path: String) throws -> [Segment] {
    static func processSpreadsheet(config: Config, filePath path: String) throws -> Segment {
        guard let xlsxFile = XLSXFile(filepath: path) else {
            throw XlsxProcessorErrors.xlsxFileNotInitialized
        }
        
        var terms = [XlsxValue]()
        var keys = [XlsxValue]()
        var content = [XlsxValue]()
        
        let sharedStrings = try xlsxFile.parseSharedStrings()
        let worksheet = try getSheet(withName: config.name, spreadsheet: xlsxFile)

        guard let rows = worksheet.data?.rows else {
            throw XlsxProcessorErrors.emptyData
        }
        
        // This implementation needs to be disscused, maybe there is
        // better solution to structurize model (terms, keys, content)
        for row in rows where row.reference >= config.keysRow {
            
            for cell in row.cells {
                
                let column = cell.reference.column.value
                let convertedCell = try convert(cell, withSharedStrings: sharedStrings)
                
                switch column {
                case config.termColumn:
                    terms.append( (row.reference, column, convertedCell) )
                case config.fromColumn...config.toColumn:
                    if row.reference == config.keysRow {
                        keys.append( (row.reference, column, convertedCell) )
                    } else {
                        content.append( (row.reference, column, convertedCell) )
                    }
                default:
                    break
                }
                
            }
            
        }
        
        return (terms, keys, content)
    }
    
    static private func convert(_ cell: Cell, withSharedStrings sharedStrings: SharedStrings) throws -> String? {
        guard cell.type == "s" else {
            return cell.value
        }
        guard let stringIndex = cell.value, let index = Int(stringIndex) else {
            throw XlsxProcessorErrors.wrongReferenceStringId
        }
        
        return sharedStrings.items[index].text
    }
    
    static private func getSheet(withName name: String, spreadsheet: XLSXFile) throws -> Worksheet {
        guard let relationshipId = try spreadsheet.parseWorkbooks().first?.sheets.items.first(where: { $0.name == name })?.relationship else {
            throw XlsxProcessorErrors.noSuchSheetName
        }
        guard let target = try spreadsheet.parseDocumentRelationships().first?.1.items.first(where: { $0.id == relationshipId })?.target else {
            throw XlsxProcessorErrors.noSuchSheetName
        }
        guard let path = try spreadsheet.parseWorksheetPaths().first(where: { $0.contains(target) }) else {
            throw XlsxProcessorErrors.noSuchSheetName
        }
        
        return try spreadsheet.parseWorksheet(at: path)
    }
}
