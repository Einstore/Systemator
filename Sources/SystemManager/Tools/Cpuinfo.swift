//
//  Cpuinfo.swift
//  
//
//  Created by Ondrej Rafaj on 10/07/2019.
//

import Foundation


public struct Cpuinfo: Command {
    
    public static var command: String {
        return "lscpu"
    }
    
    public static func parse(_ string: String) -> SystemInfo.CPU {
        let cores = string.line(with: "CPU(s):")?.intOnly() ?? 0
        let clock = string.line(with: "CPU MHz:")?.doubleOnly() ?? 0.0
        
        return SystemInfo.CPU(
            physicalCpu: cores,
            logicalCpu: nil,
            clock: (clock * 1_000_000)
        )
    }
    
}
