//
//  Controller.swift
//  
//
//  Created by Ondrej Rafaj on 09/07/2019.
//

import Vapor
import SystemManager


public class Controller {
    
    public init() { }
    
    public func routes(_ r: Routes, _ c: Container) throws {
        r.get("info") { req -> EventLoopFuture<SystemInfo> in
            let manager = try SystemManager(.local, on: c.eventLoop)
            return manager.info()
        }
        
        r.post("info") { req -> EventLoopFuture<SystemInfo> in
            let connection = try req.content.decode(Connection.self)
            let manager = try SystemManager(
                .ssh(
                    host: connection.host,
                    port: connection.port ?? 22,
                    username: connection.login,
                    password: connection.password ?? ""
                ),
                on: c.eventLoop
            )
            return manager.info()
        }
    }
    
}
