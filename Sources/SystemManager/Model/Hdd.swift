//
//  Hdd.swift
//  
//
//  Created by Ondrej Rafaj on 10/07/2019.
//

import Foundation


public struct Hdd: Codable {
    
    public struct Mac: Codable {
        
        public static var command: String {
            return "df -P"
        }
        
        public static func parse(_ string: String) -> [Hdd] {
            let blocks = string.line(with: "Mounted on")?.doubleOnly() ?? 512.0
            let string = string.dropLine(with: "Mounted on")
            let lines = string.lines()
            
            var hdds: [Hdd] = []
            lines.forEach { line in
                let parts = line.splitIntoTrimmedComponents(" ")
                guard parts.count == 6 else {
                    return
                }
                hdds.append(
                    Hdd(
                        filesystem: parts[0],
                        size: (parts[1].doubleOnly() * blocks),
                        used: (parts[2].doubleOnly() * blocks),
                        available: (parts[3].doubleOnly() * blocks),
                        use: parts[4].doubleOnly(),
                        mounted: parts[5]
                    )
                )
            }
            return hdds
        }
        
    }
    
    public struct Linux: Codable {
        
        public static var command: String {
            return "df -B 1024"
        }
        
        public static func parse(_ string: String) -> [Hdd] {
            let blocks = 1024.0
            let string = string.dropLine(with: "Mounted on")
            let lines = string.lines()
            
            var hdds: [Hdd] = []
            lines.forEach { line in
                let parts = line.splitIntoTrimmedComponents(" ")
                guard parts.count == 6 else {
                    return
                }
                hdds.append(
                    Hdd(
                        filesystem: parts[0],
                        size: (parts[1].doubleOnly() * blocks),
                        used: (parts[2].doubleOnly() * blocks),
                        available: (parts[3].doubleOnly() * blocks),
                        use: parts[4].doubleOnly(),
                        mounted: parts[5]
                    )
                )
            }
            return hdds
        }
        
    }
    
    public let filesystem: String
    public let size: Double
    public let used: Double
    public let available: Double
    public let use: Double
    public let mounted: String
    
}


