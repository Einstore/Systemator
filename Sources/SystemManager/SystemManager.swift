//
//  SystemManager.swift
//  
//
//  Created by Ondrej Rafaj on 09/07/2019.
//

import ShellKit


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
    
    public func os() -> EventLoopFuture<Os> {
        return shell.run(bash: Os.command).map { output in
            return Os.parse(output)
        }
    }
    
    public func cores(os: Os) -> EventLoopFuture<SystemInfo.CPU> {
        switch os {
        case .macOs:
            return self.shell.run(bash: Sysctl.command).map { output in
                let info = Sysctl.parse(output)
                return SystemInfo.CPU(
                    physicalCpu: info.int(for: .hw_physicalcpu),
                    logicalCpu: info.int(for: .hw_logicalcpu),
                    clock: info.double(for: .hw_cpufrequency)
                )
            }
        case .linux:
            return self.shell.run(bash: Cpuinfo.command).map { output in
                let cpu = Cpuinfo.parse(output)
                return cpu
            }
        default:
            return eventLoop.makeFailedFuture(Error.unableToProvideInformation)
        }
    }
    
    public func stats(os: Os) -> EventLoopFuture<Stats> {
        switch os {
        case .macOs:
            return self.shell.run(bash: Stats.Mac.command).map { output in
                let top = Stats.Mac.parse(output)
                return top
            }
        case .linux:
            return self.shell.run(bash: Stats.Linux.command).map { output in
                let top = Stats.Linux.parse(output)
                return top
            }
        default:
            return eventLoop.makeFailedFuture(Error.unableToProvideInformation)
        }
    }
    
    public func info() -> EventLoopFuture<SystemInfo> {
        return os().flatMap { os in
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
                        physicalCpu: info.int(for: .hw_physicalcpu),
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
            return self.shell.run(bash: Cpuinfo.command).map { output in
                let cpu = Cpuinfo.parse(output)
                return SystemInfo(
                    cpu: cpu,
                    usage: stats
                )
            }
        }
    }
    
    // MARK: Private interface
    

    
}
