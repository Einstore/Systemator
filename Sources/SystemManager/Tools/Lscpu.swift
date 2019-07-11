//
//  Lscpu.swift
//  
//
//  Created by Ondrej Rafaj on 10/07/2019.
//

import Foundation


public struct Lscpu: Command {
    
    public static var command: String {
        return "lscpu"
    }
    
    public static func parse(_ string: String) -> Lscpu {
        let vendor = string.line(with: "Vendor ID:")?.dropTillFirstColon() ?? "n/a"
        let model = string.line(with: "Model name:")?.dropTillFirstColon() ?? "n/a"
        let hypervisor = string.line(with: "Hypervisor vendor:")?.dropTillFirstColon() ?? "n/a"
        let sockets = string.line(with: "Socket(s):")?.intOnly() ?? 0
        let cores = string.line(with: "CPU(s):")?.intOnly() ?? 0
        let clock = string.line(with: "CPU MHz:")?.doubleOnly() ?? 0.0
        
        return Lscpu(
            vendor: vendor,
            model: model,
            hypervisor: hypervisor,
            sockets: sockets,
            cores: cores,
            clock: (clock * 1_000_000)
        )
    }
    
    public let vendor: String
    public let model: String
    public let hypervisor: String?
    public let sockets: Int?
    public let cores: Int
    public let clock: Double
    
}
