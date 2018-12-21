//
//  ColorsWriter.swift
//  CommandLineToolCore
//
//  Created by Mateusz Śmigowski on 20.12.18.
//

import Foundation

public final class ColorsWriter: Writable {
    
    let templateName: String = "ColorsTemplate.stencil"
    let outputFileName: String = "Colors.xml"
    
    func write(context: [Segment], toPath path: String) throws {
        
        let fileHandle = try getWritableFile(name: outputFileName, atPath: path)
        let preparedContext = prepare(context: context)
        let rendered = try TemplateHandler.render(context: preparedContext, withTemplateType: templateName)
        
        fileHandle.write( rendered.data(using: .utf8) ?? Data() ) // TODO: (msm) Maybe should throw error if cannot convert string to data
        
    }
    
}
