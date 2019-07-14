//
//  SystemManager.swift
//  
//
//  Created by Ondrej Rafaj on 09/07/2019.
//

import CommandKit
import SystemModel


public class SystemManager {
    
    public enum Error: Swift.Error {
        case unableToProvideInformation
    }
    
    let eventLoop: EventLoop
    let shell: Shell
    
    // MARK: Public interface
    
    public init(_ conn: Shell.Connection, on eventLoop: EventLoop) throws {
        self.eventLoop = eventLoop
        shell = try Shell(conn, on: eventLoop)
    }
    
    public func cores(os: Cmd.Os) -> EventLoopFuture<SystemInfo.CPU> {
        switch os {
        case .macOs:
            return self.shell.run(bash: Sysctl.command).map { output in
                let info = Sysctl.parse(output)
                return SystemInfo.CPU(
                    model: info.string(for: .machdep_cpu_brand_string),
                    vendor: info.string(for: .machdep_cpu_vendor),
                    hypervisor: nil,
                    cores: info.int(for: .hw_physicalcpu),
                    logicalCpu: info.int(for: .hw_logicalcpu),
                    clock: info.double(for: .hw_cpufrequency)
                )
            }
        case .linux:
            return self.shell.run(bash: Lscpu.command).map { output in
                let cpu = Lscpu.parse(output)
                return SystemInfo.CPU(
                    model: cpu.model,
                    vendor:  cpu.vendor,
                    hypervisor: cpu.hypervisor,
                    cores: cpu.cores,
                    logicalCpu: nil,
                    clock: cpu.clock
                )
            }
        default:
            return eventLoop.makeFailedFuture(Error.unableToProvideInformation)
        }
    }
    
    public func stats(os: Cmd.Os) -> EventLoopFuture<SystemInfo.Stats> {
        switch os {
        case .macOs:
            return self.shell.run(bash: SystemInfo.Stats.Mac.command).map { output in
                let top = SystemInfo.Stats.Mac.parse(output)
                return top
            }
        case .linux:
            return self.shell.run(bash: SystemInfo.Stats.Linux.command).map { output in
                let top = SystemInfo.Stats.Linux.parse(output)
                return top
            }
        default:
            return eventLoop.makeFailedFuture(Error.unableToProvideInformation)
        }
    }
    
    public func info() -> EventLoopFuture<SystemInfo> {
        return shell.cmd.os().flatMap { os in
            switch os {
            case .macOs:
                return self.macOsInfo()
            case .linux:
                return self.linuxInfo()
            default:
                return self.eventLoop.makeFailedFuture(Error.unableToProvideInformation)
            }
        }
    }
    
    public func macOsInfo() -> EventLoopFuture<SystemInfo> {
        return stats(os: .macOs).flatMap { stats in
            return self.shell.run(bash: Sysctl.command).map { output in
                let info = Sysctl.parse(output)
                return SystemInfo(
                    cpu: SystemInfo.CPU(
                        model: info.string(for: .machdep_cpu_brand_string),
                        vendor: info.string(for: .machdep_cpu_vendor),
                        hypervisor: nil,
                        cores: info.int(for: .hw_physicalcpu),
                        logicalCpu: info.int(for: .hw_logicalcpu),
                        clock: info.double(for: .hw_cpufrequency)
                    ),
                    usage: stats
                )
            }
        }
    }
    
    public func linuxInfo() -> EventLoopFuture<SystemInfo> {
        return stats(os: .linux).flatMap { stats in
            return self.shell.run(bash: Lscpu.command).map { output in
                let cpu = Lscpu.parse(output)
                return SystemInfo(
                    cpu: SystemInfo.CPU(
                        model: cpu.model,
                        vendor:  cpu.vendor,
                        hypervisor: cpu.hypervisor,
                        cores: cpu.cores,
                        logicalCpu: nil,
                        clock: cpu.clock
                    ),
                    usage: stats
                )
            }
        }
    }
    
    // MARK: Private interface
    

    
}
