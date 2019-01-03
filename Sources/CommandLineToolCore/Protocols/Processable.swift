//
//  Processable.swift
//  CommandLineToolCore
//
//  Created by Mateusz Śmigowski on 20.12.18.
//

import Foundation

protocol Processable {
    associatedtype ReturnType
    
    static func processSpreadsheet(config: Config, filePath path: String) throws -> ReturnType
}
