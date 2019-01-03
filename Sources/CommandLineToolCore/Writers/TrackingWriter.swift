//
//  TrackingWriter.swift
//  CommandLineToolCore
//
//  Created by Mateusz Śmigowski on 21.12.18.
//

import Foundation

final class TrackingWriter: Writable {
    
    let templateName = "StringsTemplate.stencil"
    let outputFileName = "Tracking.string"
    
    func write(context: Segment, toPath path: String) throws {
        
        let fileHandle = try getWritableFile(name: outputFileName, atPath: path)
        let preparedContext = prepare(context: context)
        let rendered = try TemplateHandler.render(context: preparedContext, withTemplateType: templateName)
        
        fileHandle.write( rendered.data(using: .utf8) ?? Data() ) // TODO: (msm) Maybe should throw error if cannot convert string to data
        
    }
}
