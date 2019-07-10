//
//  SystemInfo.swift
//  
//
//  Created by Ondrej Rafaj on 09/07/2019.
//

import Foundation


public struct SystemInfo: Codable {
    
    public struct CPU: Codable {
        let physicalCpu: Int
        let logicalCpu: Int?
        let clock: Double
    }
    
    /// Number of cores
    public let cpu: CPU
    
    /// Current usage stats
    public let usage: Stats
    
}
