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
    func write(context: [Segment], toPath: String) throws
    
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
    func prepare(context: [Segment], forKey key: String? = nil) -> Terms {
        
        if let key = key {
            return ["terms": context.filter{ $0.key == key }.map{ TemplateHandler.Term(name: $0.term, value: $0.value) }]
        } else {
            return ["terms": context.map{ TemplateHandler.Term(name: $0.term, value: $0.value) }]
        }
    }
}
