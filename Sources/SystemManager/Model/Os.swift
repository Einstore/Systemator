//
//  Os.swift
//  
//
//  Created by Ondrej Rafaj on 09/07/2019.
//

import Foundation


public enum Os: Command {
    
    case macOs
    
    case linux
    
    case cygwin
    
    case minGW
    
    case other(String)
    
    public static var command: String {
        return "uname -s"
    }
    
    public func serialize() -> String {
        switch self {
        case .macOs:
            return "macOs"
        case .linux:
            return "linux"
        case .cygwin:
            return "cygwin"
        case .minGW:
            return "minGW"
        case .other(let os):
            return "other:\(os)"
        }
    }
    
    public static func deserialize(_ string: String) -> Os {
        switch true {
        case string == "macOs":
            return .macOs
        case string == "linux":
            return .linux
        case string == "cygwin":
            return .cygwin
        case string == "minGW":
            return .minGW
        case string.prefix(8) == "other:":
            return .other(String(string.dropFirst(8)))
        default:
            return .other(string)
        }
    }
    
    public static func parse(_ string: String) -> Os {
        let string = string.trimmingCharacters(in: .whitespacesAndNewlines)
        switch true {
        case string == "Darwin":
            return .macOs
        case string == "Linux":
            return .linux
        case string == "CYGWIN":
            return .cygwin
        case string == "MINGW":
            return .minGW
        default:
            return .other(string)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        self = Os.deserialize(string)
    }
    
    public init(from string: String) {
        self = Os.deserialize(string)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(serialize())
    }
    
}
