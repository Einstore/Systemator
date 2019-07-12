//
//  SystemInfo.swift
//  
//
//  Created by Ondrej Rafaj on 12/07/2019.
//

import Foundation


/// System information
public struct SystemInfo: Codable {
    
    /// CPU information
    public struct CPU: Codable {
        
        /// CPU model
        public let model: String
        
        /// CPU manufacturer
        public let vendor: String
        
        /// Hypervisor / VM
        public let hypervisor: String?
        
        /// Number of cores
        public let cores: Int
        
        /// Number of logical cores
        public let logicalCpu: Int?
        
        /// CPU Clock
        public let clock: Double
        
        /// Initializer
        public init(model: String, vendor: String, hypervisor: String?, cores: Int, logicalCpu: Int?, clock: Double) {
            self.model = model
            self.vendor = vendor
            self.hypervisor = hypervisor
            self.cores = cores
            self.logicalCpu = logicalCpu
            self.clock = clock
        }
        
    }
    
    /// Current usage stats
    public struct Stats: Codable {
        
        /// CPU stats
        public struct CPU: Codable {
            
            /// User processes
            public let user: Double
            
            /// System processes
            public let system: Double
            
            /// Idle
            public let idle: Double
            
            /// Initializer
            public init(user: Double, system: Double, idle: Double) {
                self.user = user
                self.system = system
                self.idle = idle
            }
            
        }
        
        /// Memory stats
        public struct Memory: Codable {
            
            /// Total memory available
            public let total: Int
            
            /// Free memory
            public let free: Int
            
            /// Used memory
            public let used: Int
            
            /// Initializer
            public init(total: Int, free: Int, used: Int) {
                self.total = total
                self.free = free
                self.used = used
            }
            
        }
        
        /// Process
        public struct Process: Codable {
            
            /// Process PID
            public let pid: String
            
            /// User
            public let user: String
            
            /// Utilisation
            public let utilisation: Double
            
            /// Launch arguments
            public let args: String
            
            /// Initializer
            public init(pid: String, user: String, utilisation: Double, args: String) {
                self.pid = pid
                self.user = user
                self.utilisation = utilisation
                self.args = args
            }
            
        }
        
        /// HDD usage
        public struct Hdd: Codable {
            
            /// Filesystem type
            public let filesystem: String
            
            /// Total size
            public let size: Double
            
            /// Used capacity
            public let used: Double
            
            /// Available capacity
            public let available: Double
            
            /// Percentual usage
            public let use: Double
            
            /// Mounted as
            public let mounted: String
            
            /// Initializer
            public init(filesystem: String, size: Double, used: Double, available: Double, use: Double, mounted: String) {
                self.filesystem = filesystem
                self.size = size
                self.used = used
                self.available = available
                self.use = use
                self.mounted = mounted
            }
            
        }
        
        /// CPU stats
        public let cpu: CPU
        
        /// Memory usage
        public let memory: Memory
        
        /// Running processes with most significant impact
        public let processes: [Process]
        
        /// HDD usage
        public let hdd: [Hdd]
        
        /// Initializer
        public init(cpu: CPU, memory: Memory, processes: [Process], hdd: [Hdd]) {
            self.cpu = cpu
            self.memory = memory
            self.processes = processes
            self.hdd = hdd
        }
        
    }
    
    /// CPU info
    public let cpu: CPU
    
    /// Current usage stats
    public let usage: Stats
    
    /// Initializer
    public init(cpu: CPU, usage: Stats) {
        self.cpu = cpu
        self.usage = usage
    }
    
}
