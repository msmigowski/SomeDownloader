//
//  GdriveConfig.swift
//  CommandLineToolCore
//
//  Created by Mateusz Śmigowski on 20.12.18.
//

import Foundation

struct GdriveConfig: Decodable {
    let platform: String
    let file: String
    let sheets: [GdriveSheetConfig]
}

struct GdriveSheetConfig: Decodable, Config {
    let name: String
    let keysRow: Int
    let termColumn: String
    let fromColumn: String
    let toColumn: String
    let toPath: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case keysRow = "keys_row"
        case termColumn = "term_column"
        case fromColumn = "from_column"
        case toColumn = "to_column"
        case toPath = "to_path"
    }
}
