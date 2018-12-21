//
//  ConfigLoadable.swift
//  CommandLineToolCore
//
//  Created by Mateusz Śmigowski on 20.12.18.
//

import Foundation

protocol ConfigLoadable {
    associatedtype Config
    
    static func loadConfig(fromPath path: String) throws -> Config
}

protocol Config {
    var name: String { get }
    var keysRow: Int { get }
    var termColumn: String { get }
    var fromColumn: String { get }
    var toColumn: String { get }
    var toPath: String { get }
}
