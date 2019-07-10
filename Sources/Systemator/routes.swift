import Vapor
import SystemController

/// Register your application's routes here.
public func routes(_ r: Routes, _ c: Container) throws {
    try Controller().routes(r, c)
}
