//
//  Command.swift
//  
//
//  Created by Ondrej Rafaj on 09/07/2019.
//

import Foundation


public protocol Command: Codable {
    
    associatedtype Result
    
    static func parse(_ string: String) -> Result
    static var command: String { get }
    
}
