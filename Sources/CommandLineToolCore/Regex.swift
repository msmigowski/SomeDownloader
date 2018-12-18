//
//  Regex.swift
//  CommandLineTool
//
//  Created by Mateusz Śmigowski on 18.12.18.
//

import Foundation

//from NSHipster - http://nshipster.com/swift-literal-convertible/
struct Regex {
    let pattern: String
    let options: NSRegularExpression.Options
    
    private var matcher: NSRegularExpression? {
        return try? NSRegularExpression(pattern: self.pattern, options: self.options)
    }
    
    init(pattern: String, options: NSRegularExpression.Options) {
        self.pattern = pattern
        self.options = options
    }
    
    func match(string: String, options: NSRegularExpression.MatchingOptions) -> Bool {
        return matcher?.numberOfMatches(in: string, options: options, range: NSRange(location: 0, length: string.utf8.count)) != 0
    }
}

protocol RegularExpresionMatchable {
    func match(regex: Regex) -> Bool
}

extension String: RegularExpresionMatchable {
    func match(regex: Regex) -> Bool {
        return regex.match(string: self, options: .init(rawValue: 0))
    }
}

func ~=<T: RegularExpresionMatchable>(pattern: Regex, matchable: T) -> Bool {
    return matchable.match(regex: pattern)
}
