//
//  Writable.swift
//  CommandLineToolCore
//
//  Created by Mateusz Śmigowski on 20.12.18.
//

import Foundation

fileprivate enum WritableErrors: Error {
    case cannotCreateFile
    case cannotFindFileAtPath(String)
}

protocol Writable {
    
    var templateName: String { get }
    var outputFileName: String { get }
    
    // TODO: (msm) Find better name to this method
    /// For every key (column) generates new files
    func write(context: Segment, toPath: String) throws
    
}

extension Writable {
    
    /// - Parameter name: must be with extension (example.string)
    func getWritableFile(name: String, atPath path: String) throws -> FileHandle {
        let filePath = "\(path)\(name)"
        
        try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        guard FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil) else {
            throw WritableErrors.cannotCreateFile
        }
        guard let fileHandle = FileHandle(forWritingAtPath: filePath) else {
            throw WritableErrors.cannotFindFileAtPath(filePath)
        }
        return fileHandle
    }
    
    // TODO: (msm) Change "terms" to some more generic thing or other way
    func prepare(context: Segment, forKey key: String? = nil) -> [TemplateHandler.Term] {
        
        var segments = [(term: String, key: String?, value: String)]()
        
        // TODO: (msm) Maybe too many calculations
        for term in context.terms {
            
            for key in context.keys {
                
                guard let key = key else { continue }
                let cell = context.values.first(where: { $0.column == key.column && $0.row == term.row })
                
                guard let contentValue = cell?.value, let termValue = term.value else { continue }
                
                segments.append(( termValue, key.value, contentValue ))
            }
        }
        
        if let key = key {
            return segments.filter{ $0.key == key }.map{ TemplateHandler.Term(name: $0.term, value: $0.value) }
        } else {
            return segments.map{ TemplateHandler.Term(name: $0.term, value: $0.value) }
        }
    }
    
}
