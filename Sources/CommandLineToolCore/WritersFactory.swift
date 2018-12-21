//
//  WritersFactory.swift
//  CommandLineToolCore
//
//  Created by Mateusz Śmigowski on 20.12.18.
//

import Foundation

final class WritersFactory {
    
    enum WritersFactoryError: Error {
        case typeDoesNotExist(String)
    }
    
    static func makeWriter(type: String) throws -> Writable {
        switch type {
        case "Colors":
            return ColorsWriter()
        case "Localizations":
            return LocalizablesWriter()
        case "NonLocalizations":
            return NonLocalizablesWriter()
        case "Permissions":
            return PermissionsWriter()
        case "Tracking":
            return TrackingWriter()
        case "Plurals":
            return PluralsWriter()
        default:
            throw WritersFactoryError.typeDoesNotExist("In function: \(#function), type: \(WritersFactory.self)")
        }
    }
    
}
