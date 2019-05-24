//
//  PluralsWriter.swift
//  CommandLineToolCore
//
//  Created by Mateusz Śmigowski on 21.12.18.
//

import Foundation

final class PluralsWriter: Writable {
    
    typealias DictEntity = (key: String, value: String)
    
    struct PluralTerms {
        let localizedFormat: DictEntity
        let term: [String: LocalizedTerm]
    }
    
    struct LocalizedTerm {
        let fromatSpecType: DictEntity
        let formatValueType: DictEntity
        let plurals: [DictEntity]
    }
    
    enum PluralsWriterError: Error {
        case keyNotExist
    }
    
    let templateName = "StringsTemplate.stencil"
    let outputFileName = "Plurals.string"
    let interruptSymbol = "--"
    
    func write(context: Segment, toPath path: String) throws {
        
        for case let (_, localizedName) in Set(context.keys.compactMap{ $0?.value }).enumerated() {
        
            let fileHandle = try getWritableFile(name: outputFileName, atPath: path)
            let preparedContext = try prepare(context: context, forKey: localizedName)
            let rendered = try TemplateHandler.render(context: preparedContext, withTemplateType: templateName)
            
            fileHandle.write( rendered.data(using: .utf8) ?? Data() ) // TODO: (msm) Maybe should throw error if cannot convert string to data
        }
        
    }
    
    // TODO: (msm) This class is very bad it should be rewritten 
    func prepare(context: Segment, forKey key: String? = nil) throws -> [String] {
        guard let key = key else {
            throw PluralsWriterError.keyNotExist
        }
        
        guard let startKeysColumn = (context.keys.compactMap{ $0 }.first(where: { $0.value == key })?.column) else {
            throw PluralsWriterError.keyNotExist
        }
        
        let startValuesColumn = try getNextUnicodeCharacter(for: startKeysColumn)
        
        for term in context.terms {
            
            guard var currentValue = context.values.first(where: { $0.row == term.row && $0.column == startKeysColumn }) else {
                continue
            }
            
            try process(currentValue: &currentValue, keysColumn: startKeysColumn, valuesColumn: startValuesColumn, context: context)
            
            let keysColumn = startValuesColumn
            let valuesColumn = try getNextUnicodeCharacter(for: keysColumn)
            guard let cos = context.values.first(where: { $0.row == currentValue.row && $0.column == keysColumn }) else { continue }
            currentValue = cos
            
            try process(currentValue: &currentValue, keysColumn: keysColumn, valuesColumn: valuesColumn, context: context)
        }
        
        return ["as"]
    }
    
    @discardableResult
    private func process(currentValue: inout XlsxValue, keysColumn: String, valuesColumn: String, context: Segment) throws -> [String: Any] {
        
        var result = [String: Any]()
        var keyValue = ""
        
        loop: while true {
            switch currentValue.column {
            case keysColumn:
                guard let localKeyValue = currentValue.value else { break loop }
                keyValue = localKeyValue
                
                let nextColumn = try getNextUnicodeCharacter(for: currentValue.column)
                
                guard let nextValue = context.values.first(where: { $0.row == currentValue.row && $0.column == nextColumn }) else {
                    break loop
                }
                currentValue = nextValue
            case valuesColumn:
                guard let value = currentValue.value else { break loop }
                
                let nextRow = currentValue.row + 1
                guard let nextValue = context.values.first(where: { $0.row == nextRow && $0.column == keysColumn }) else {
                    break loop
                }
                currentValue = nextValue
                
                result[keyValue] = value
            default:
                break loop
            }
        }
        
        print(result)
        return result
    }
    
    private func getNextUnicodeCharacter(for column: String) throws -> String {
        guard let keysColumnScalar = column.unicodeScalars.first?.value else {
            throw PluralsWriterError.keyNotExist
        }
        
        guard let valuesColumnScalar = UnicodeScalar(keysColumnScalar + 1) else {
            throw PluralsWriterError.keyNotExist
        }
        
        return String(Character(valuesColumnScalar))
    }
    
}
