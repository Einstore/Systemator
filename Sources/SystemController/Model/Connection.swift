//
//  File.swift
//  
//
//  Created by Ondrej Rafaj on 10/07/2019.
//

import Foundation


public struct Connection: Codable {
    
    public let host: String
    public let port: Int?
    public let login: String
    public let password: String?
    
}
