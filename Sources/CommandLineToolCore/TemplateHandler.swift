//
//  TemplateHandler.swift
//  CommandLineToolCore
//
//  Created by Mateusz Śmigowski on 19.12.18.
//

import Foundation
import Stencil
import PathKit

//typealias Terms = [String: [TemplateHandler.Term]]

public final class TemplateHandler {
    
    struct Term {
        let name: String
        let value: String
    }
    
    enum TemplateHandlerError: Error {
        case cannotRenderTemplate
        case bundleDoesNotExist
    }
    
    static func render<Terms>(context: Terms, withTemplateType name: String) throws -> String {
        guard let resourcePath = Bundle(for: TemplateHandler.self).resourcePath else {
            throw TemplateHandlerError.bundleDoesNotExist
        }
        
        let path = Path(resourcePath)
        let enviroment = Environment(loader: FileSystemLoader(paths: [path]))
        
        return try enviroment.renderTemplate(name: name, context: ["terms": context])
    }
}
