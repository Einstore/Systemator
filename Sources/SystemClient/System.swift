//
//  System.swift
//  
//
//  Created by Ondrej Rafaj on 12/07/2019.
//

import Foundation
import AsyncHTTPClient
import NIO
import NIOHTTP1
import SystemModel


public class System {
    
    public enum Error: Swift.Error {
        case response(status: HTTPResponseStatus, content: Data?)
        case noData
    }
    
    let client: AsyncHTTPClient.HTTPClient
    
    let eventLoop: EventLoop
    
    /// Initializer
    public init(eventLoopGroupProvider provider: AsyncHTTPClient.HTTPClient.EventLoopGroupProvider = .createNew, proxy: AsyncHTTPClient.HTTPClient.Proxy? = nil) throws {
        eventLoop = provider.next()
        var conf = AsyncHTTPClient.HTTPClient.Configuration()
        conf.proxy = proxy
        client = AsyncHTTPClient.HTTPClient(
            eventLoopGroupProvider: provider,
            configuration: conf
        )
    }
    
    /// Initializer
    public convenience init(eventLoop: EventLoop, proxy: AsyncHTTPClient.HTTPClient.Proxy? = nil) throws {
        try self.init(eventLoopGroupProvider: .shared(eventLoop), proxy: proxy)
    }
    
    /// New instance with running on an EmbeddedEventLoop
    public static func embedded(proxy: AsyncHTTPClient.HTTPClient.Proxy? = nil) throws -> System {
        let eventLoop = EmbeddedEventLoop()
        return try System(eventLoop: eventLoop, proxy: proxy)
    }
    
    public func info(url: String) -> EventLoopFuture<SystemInfo> {
        return client.get(url: url).flatMap { response in
            let content: Data?
            if var body = response.body {
                content = Data(body.readBytes(length: body.readableBytes) ?? [])
            } else { content = nil }
            guard response.status == .ok else {
                return self.eventLoop.makeFailedFuture(Error.response(status: response.status, content: content))
            }
            guard let c = content else {
                return self.eventLoop.makeFailedFuture(Error.noData)
            }
            do {
                let info = try JSONDecoder().decode(SystemInfo.self, from: c)
                return self.eventLoop.makeSucceededFuture(info)
            } catch {
                return self.eventLoop.makeFailedFuture(error)
            }
        }
    }

}
