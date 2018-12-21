//
//  CommandLineTool.swift
//  CommandLineTool
//
//  Created by Mateusz Śmigowski on 17.12.18.
//

import Foundation
import CoreXLSX
import Stencil

public final class CommandLineTool {

    private let arguments: [String]
    private let configFileName = "GdriveConfig.yaml"
    
    public init(arguments: [String] = CommandLine.arguments) {
        self.arguments = arguments
    }
    
    public func run() {
        do {
            let gdriveConfig = try GdriveConfigLoader.loadConfig(fromPath: configFileName)
            
            for sheetConfig in gdriveConfig.sheets {
                
                let segments = try XlsxProcessor.processSpreadsheet(config: sheetConfig, filePath: gdriveConfig.file)
                
                let writer = try WritersFactory.makeWriter(type: sheetConfig.name)
                try writer.write(context: segments, toPath: sheetConfig.toPath)
                
            }
            
        } catch {
            print(error)
        }
    }
}
