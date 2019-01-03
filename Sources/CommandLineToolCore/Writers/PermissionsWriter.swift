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
    
    func write(context: Segment, toPath path: String) throws {

        for case let (_, localizedName) in Set(context.keys.compactMap{ $0?.value }).enumerated() {
            
            let fileHandle = try getWritableFile(name: outputFileName, atPath: path + "\(localizedName)/")
            let preparedContext = prepare(context: context, forKey: localizedName)
            let rendered = try TemplateHandler.render(context: preparedContext, withTemplateType: templateName)
            
            fileHandle.write( rendered.data(using: .utf8) ?? Data() ) // TODO: (msm) Maybe should throw error if cannot convert string to data
        }
        
    }
}
