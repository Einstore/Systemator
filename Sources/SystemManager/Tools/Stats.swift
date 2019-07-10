//
//  Stats.swift
//  
//
//  Created by Ondrej Rafaj on 10/07/2019.
//

import Foundation


public struct Stats: Codable {
    
    public struct Mac: Command {
        
        public static var command: String {
            return "top -l 1 -n 30 ; vm_stat ; sysctl hw.memsize ; echo '!Processor stats:' ; ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10 ; echo '!Hdd stats:' ; \(Hdd.Mac.command)"
        }
        
        public static func parse(_ string: String) -> Stats {
            let cpuLine = string.line(with: "CPU usage:")?.dropTillFirstColon()
            let cpuComponents = cpuLine?.splitIntoTrimmedComponents()
            let cpuUser = Double(cpuComponents?.find(andTrim: "% user") ?? "0.0") ?? 0.0
            let cpuSystem = Double(cpuComponents?.find(andTrim: "% sys") ?? "0.0") ?? 0.0
            let cpuIdle = Double(cpuComponents?.find(andTrim: "% idle") ?? "0.0") ?? 0.0
            
            let size = string.line(with: "page size of")?.intOnly() ?? 4096
            func sz(value: Int) -> Int {
                return value * size / 1048576
            }
            
            let memTotal = sz(value: string.line(with: "hw.memsize:")?.intOnly() ?? 0)
            let memFree = sz(value: string.line(with: "Pages free:")?.intOnly() ?? 0)
            
            let df = string.drop(till: "!Hdd stats:").trimmingCharacters(in: .whitespacesAndNewlines)
            let hdds = Hdd.Mac.parse(df)
            
            return Stats(
                cpu: Stats.CPU(
                    user: cpuUser,
                    system: cpuSystem,
                    idle: cpuIdle
                ),
                memory: Stats.Memory(
                    total: memTotal,
                    free: memFree,
                    used: (memTotal - memFree)
                ),
                processes: [],
                hdd: hdds
            )
        }
        
    }
    
    public struct Linux: Command {
        
        public static var command: String {
            return "top -b -n1 ; echo '!Processor stats:' ; ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10 ; echo '!Hdd stats:' ; \(Hdd.Linux.command)"
        }
        
        public static func parse(_ string: String) -> Stats {
            let cpuLine = string.line(with: "%Cpu(s):")?.dropTillFirstColon()
            let cpuComponents = cpuLine?.splitIntoTrimmedComponents()
            let cpuUser = Double(cpuComponents?.find(andTrim: " us") ?? "0.0") ?? 0.0
            let cpuSystem = Double(cpuComponents?.find(andTrim: " sy") ?? "0.0") ?? 0.0
            let cpuIdle = Double(cpuComponents?.find(andTrim: " id") ?? "0.0") ?? 0.0
            
            let memLine = string.line(with: "KiB Mem")
            let memComponents = memLine?.splitIntoTrimmedComponents()
            let memTotal = memComponents?.find(andTrim: " total")?.intOnly() ?? 0
            let memFree = memComponents?.find(andTrim: " free")?.intOnly() ?? 0
            let memUsed = memComponents?.find(andTrim: " used")?.intOnly() ?? 0
            
            let df = string.drop(till: "!Hdd stats:").trimmingCharacters(in: .whitespacesAndNewlines)
            let hdds = Hdd.Linux.parse(df)
            
            return Stats(
                cpu: Stats.CPU(
                    user: cpuUser,
                    system: cpuSystem,
                    idle: cpuIdle
                ),
                memory: Stats.Memory(
                    total: (memTotal * 1024),
                    free: (memFree * 1024),
                    used: (memUsed * 1024)
                ),
                processes: [],
                hdd: hdds
            )
        }
        
    }
    
    public struct CPU: Codable {
        
        public let user: Double
        public let system: Double
        public let idle: Double
        
    }
    
    public struct Memory: Codable {
        
        public let total: Int
        
        public let free: Int
        
        public let used: Int
        
    }
    
    public struct Process: Codable {
        
        public let pid: String
        
        public let user: String
        
        public let utilisation: Double
        
        public let args: String
        
    }
    
    public let cpu: CPU
    
    public let memory: Memory
    
    public let processes: [Process]
    
    public let hdd: [Hdd]
    
}
