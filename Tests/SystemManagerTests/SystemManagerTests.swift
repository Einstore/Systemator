//
//  SystemManagerTests.swift
//  
//
//  Created by Ondrej Rafaj on 10/07/2019.
//

import XCTest
import SystemManager
import NIO


final class SystemManagerTests: XCTestCase {
    
    var eventLoop: EventLoop!
    
    override func setUp() {
        super.setUp()
        
        eventLoop = EmbeddedEventLoop()
    }
    
    func testMacSystemInfo() {
        #if os(macOS)
        let local = try! SystemManager(.local, on: eventLoop)
        let info = try! local.info().wait()
        print(info)
        #endif
    }
    
    func testLinuxVMSystemInfo() {
        #if os(macOS)
        let local = try! SystemManager(.ssh(host: "172.16.217.131", username: "pro", password: "aaaaaa"), on: eventLoop)
        let info = try! local.info().wait()
        print(info)
        #endif
    }
    
    static let allTests = [
        ("testMacSystemInfo", testMacSystemInfo),
        ("testMacSystemInfo", testMacSystemInfo),
    ]
    
}
