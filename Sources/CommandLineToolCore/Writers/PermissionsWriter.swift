//
//  PermissionsWriter.swift
//  CommandLineToolCore
//
//  Created by Mateusz Śmigowski on 21.12.18.
//

import Foundation

final class PermissionsWriter: Writable {
    
    let templateName = "StringsTemplate.stencil"
    let outputFileName = "InfoPlist.string"
    
    func write(context: [Segment], toPath path: String) throws {
        
        for case let (_, localizedName) in Set(context.map{ $0.key }).enumerated() {
            
            guard let key = localizedName else { continue }
            let fileHandle = try getWritableFile(name: outputFileName, atPath: path + "\(key)/")
            let preparedContext = prepare(context: context, forKey: key)
            let rendered = try TemplateHandler.render(context: preparedContext, withTemplateType: templateName)
            
            fileHandle.write( rendered.data(using: .utf8) ?? Data() ) // TODO: (msm) Maybe should throw error if cannot convert string to data
        }
        
    }
}
