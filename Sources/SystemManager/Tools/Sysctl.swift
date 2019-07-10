//
//  File.swift
//  
//
//  Created by Ondrej Rafaj on 09/07/2019.
//

import Foundation


/// macOS system info command
public class Sysctl: Command {
    
    public enum Value: String, Codable {
        case hw_ncpu = "hw.ncpu" // 8
        case hw_byteorder = "hw.byteorder" // 1234
        case hw_memsize = "hw.memsize" // 17179869184
        case hw_activecpu = "hw.activecpu" // 8
        case hw_physicalcpu = "hw.physicalcpu" // 4
        case hw_physicalcpu_max = "hw.physicalcpu_max" // 4
        case hw_logicalcpu = "hw.logicalcpu" // 8
        case hw_logicalcpu_max = "hw.logicalcpu_max" // 8
        case hw_cputype = "hw.cputype" // 7
        case hw_cpusubtype = "hw.cpusubtype" // 8
        case hw_cpu64bit_capable = "hw.cpu64bit_capable" // 1
        case hw_cpufamily = "hw.cpufamily" // 939270559
        case hw_cacheconfig = "hw.cacheconfig" // 8 2 2 8 0 0 0 0 0 0
        case hw_cachesize = "hw.cachesize" // 17179869184 32768 262144 8388608 0 0 0 0 0 0
        case hw_pagesize = "hw.pagesize" // 4096
        case hw_pagesize32 = "hw.pagesize32" // 4096
        case hw_busfrequency = "hw.busfrequency" // 100000000
        case hw_busfrequency_min = "hw.busfrequency_min" // 100000000
        case hw_busfrequency_max = "hw.busfrequency_max" // 100000000
        case hw_cpufrequency = "hw.cpufrequency" // 2900000000
        case hw_cpufrequency_min = "hw.cpufrequency_min" // 2900000000
        case hw_cpufrequency_max = "hw.cpufrequency_max" // 2900000000
        case hw_cachelinesize = "hw.cachelinesize" // 64
        case hw_l1icachesize = "hw.l1icachesize" // 32768
        case hw_l1dcachesize = "hw.l1dcachesize" // 32768
        case hw_l2cachesize = "hw.l2cachesize" // 262144
        case hw_l3cachesize = "hw.l3cachesize" // 8388608
        case hw_tbfrequency = "hw.tbfrequency" // 1000000000
        case hw_packages = "hw.packages" // 1
        case hw_optional_floatingpoint = "hw.optional.floatingpoint" // 1
        case hw_optional_mmx = "hw.optional.mmx" // 1
        case hw_optional_sse = "hw.optional.sse" // 1
        case hw_optional_sse2 = "hw.optional.sse2" // 1
        case hw_optional_sse3 = "hw.optional.sse3" // 1
        case hw_optional_supplementalsse3 = "hw.optional.supplementalsse3" // 1
        case hw_optional_sse4_1 = "hw.optional.sse4_1" // 1
        case hw_optional_sse4_2 = "hw.optional.sse4_2" // 1
        case hw_optional_x86_64 = "hw.optional.x86_64" // 1
        case hw_optional_aes = "hw.optional.aes" // 1
        case hw_optional_avx1_0 = "hw.optional.avx1_0" // 1
        case hw_optional_rdrand = "hw.optional.rdrand" // 1
        case hw_optional_f16c = "hw.optional.f16c" // 1
        case hw_optional_enfstrg = "hw.optional.enfstrg" // 1
        case hw_optional_fma = "hw.optional.fma" // 1
        case hw_optional_avx2_0 = "hw.optional.avx2_0" // 1
        case hw_optional_bmi1 = "hw.optional.bmi1" // 1
        case hw_optional_bmi2 = "hw.optional.bmi2" // 1
        case hw_optional_rtm = "hw.optional.rtm" // 0
        case hw_optional_hle = "hw.optional.hle" // 0
        case hw_optional_adx = "hw.optional.adx" // 1
        case hw_optional_mpx = "hw.optional.mpx" // 0
        case hw_optional_sgx = "hw.optional.sgx" // 0
        case hw_optional_avx512f = "hw.optional.avx512f" // 0
        case hw_optional_avx512cd = "hw.optional.avx512cd" // 0
        case hw_optional_avx512dq = "hw.optional.avx512dq" // 0
        case hw_optional_avx512bw = "hw.optional.avx512bw" // 0
        case hw_optional_avx512vl = "hw.optional.avx512vl" // 0
        case hw_optional_avx512ifma = "hw.optional.avx512ifma" // 0
        case hw_optional_avx512vbmi = "hw.optional.avx512vbmi" // 0
        case hw_targettype = "hw.targettype" // Mac
        case hw_cputhreadtype = "hw.cputhreadtype" // 1
    }
    
    public static var command: String {
        return "sysctl hw"
    }
    
    public static func parse(_ string: String) -> [Value: String] {
        let lines = string.split(separator: "\n")
        var values: [Value: String] = [:]
        lines.forEach { sub in
            let parts = sub.split(separator: ":").map({ $0.trimmingCharacters(in: .whitespacesAndNewlines )})
            guard let key = parts.first, let option = Value(rawValue: key), let valueString = parts.last else {
                return
            }
            values[option] = valueString
        }
        return values
    }
    
}


extension Dictionary where Key == Sysctl.Value, Value == String {
    
    public func int(for key: Sysctl.Value) -> Int {
        return Int(self[key] ?? "0") ?? 0
    }
    
    public func double(for key: Sysctl.Value) -> Double {
        return Double(self[key] ?? "0.0") ?? 0.0
    }
    
    public func string(for key: Sysctl.Value) -> String {
        return self[key] ?? "n/a"
    }
    
}
