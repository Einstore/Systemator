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
    
    func dropLine(with string: String) -> String {
        guard let line = line(with: string) else {
            return self
        }
        return replacingOccurrences(of: line, with: "")
    }
    
    func shrink() -> String {
        return components(separatedBy: CharacterSet(charactersIn: " ")).filter { !$0.isEmpty }.joined(separator: " ")
    }
    
    func dropTillFirstColon() -> String {
        return String(drop(while: { $0 != ":" }))
            .trimmingCharacters(in: CharacterSet(charactersIn: ":"))
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func drop(till string: String) -> String {
        guard let r = range(of: string) else {
            return self
        }
        var s = self
        s.removeSubrange(startIndex ..< r.upperBound)
        return s
    }
    
    func splitIntoTrimmedComponents(_ sep: Character = ",") -> [String] {
        let parts = split(separator: sep).map({ String($0).trimmingCharacters(in: .whitespacesAndNewlines) })
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

extension StringProtocol {
    
    func index(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    
    func endIndex(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    
    func indexes(of string: Self, options: String.CompareOptions = []) -> [Index] {
        var result: [Index] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...].range(of: string, options: options) {
                result.append(range.lowerBound)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    
    func ranges(of string: Self, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...].range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
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
