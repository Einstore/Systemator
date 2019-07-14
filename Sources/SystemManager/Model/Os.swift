//
//  Os.swift
//  
//
//  Created by Ondrej Rafaj on 09/07/2019.
//

import CommandKit


extension Cmd.Os: Command {
    
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
    
    public static func deserialize(_ string: String) -> Cmd.Os {
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
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        self = Cmd.Os.deserialize(string)
    }
    
    public init(from string: String) {
        self = Cmd.Os.deserialize(string)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(serialize())
    }
    
}
