//
//  ConfigLoader.swift
//  CommandLineToolCore
//
//  Created by Mateusz Śmigowski on 20.12.18.
//

import Foundation
import Yams

final class GdriveConfigLoader: ConfigLoadable {
    
    enum GdriveConfigLoaderError: Error {
        case cannotFindConfigFile
        case failedDataToStringConversion
    }
    
    static func loadConfig(fromPath path: String) throws -> GdriveConfig {
        guard let fileHandle = FileHandle(forReadingAtPath: path) else {
            throw GdriveConfigLoaderError.cannotFindConfigFile
        }
        
        guard let configString = String(data: fileHandle.readDataToEndOfFile(), encoding: .utf8) else {
            throw GdriveConfigLoaderError.failedDataToStringConversion
        }
        
        return try YAMLDecoder().decode(GdriveConfig.self, from: configString)
    }
    
}
