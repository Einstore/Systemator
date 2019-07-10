//
//  String+Tools.swift
//  
//
//  Created by Ondrej Rafaj on 10/07/2019.
//

import Foundation


extension String {
    
    var lines: [String] {
        return components(separatedBy: "\n")
    }
    
    func line(with string: String) -> String? {
        for line in lines {
            if line.contains(string) {
                return line
            }
        }
        return nil
    }
    
    func dropTillFirstColon() -> String {
        return String(drop(while: { $0 != ":" }))
            .trimmingCharacters(in: CharacterSet(charactersIn: ":"))
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func splitIntoTrimmedComponents() -> [String] {
        let parts = split(separator: ",").map({ String($0).trimmingCharacters(in: .whitespacesAndNewlines) })
        return parts
    }
    
    func numbersOnly() -> String {
        return trimmingCharacters(in: CharacterSet(charactersIn: "0123456789").inverted)
    }
    
    func intOnly() -> Int {
        return Int(numbersOnly()) ?? 0
    }
    
    func doubleOnly() -> Double {
        return Double(numbersOnly()) ?? 0.0
    }
    
}


extension Array where Element == String {
    
    func find(andTrim string: String) -> String? {
        for s in self {
            if s.contains(string) {
                return s.replacingOccurrences(of: string, with: "").trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        return nil
    }
    
}
