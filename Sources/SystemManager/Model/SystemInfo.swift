//
//  SystemInfo.swift
//  
//
//  Created by Ondrej Rafaj on 09/07/2019.
//

import Foundation


public struct SystemInfo: Codable {
    
    public struct CPU: Codable {
        public let model: String
        public let vendor: String
        public let hypervisor: String?
        public let cores: Int
        public let logicalCpu: Int?
        public let clock: Double
    }
    
    /// Number of cores
    public let cpu: CPU
    
    /// Current usage stats
    public let usage: Stats
    
}
