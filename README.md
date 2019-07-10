# Systemator

System information and monitoring for local and remote macOS and Ubuntu servers

### Overview

Systemator is made of three separate components

- [x] a lower level code API which will allow you to integrate monitoring to any of your `NIO` apps called `SystemManager`
- [x] a higher level `SystemController` which is built on the top of Vapor framework and gives you two ready to go endpoints
- [x] a launchable app called `Run` which will launch a full Vapor app and makes it's API's available

### Run whole monitoring app on it's own!

* Compile `Systemator` and run!
* Default address is `http://127.0.0.1:8080`

### Integrate endpoints in an Vapor 4 app

Integrate `SystemController.Controller` in your routes method

```swift
import Vapor
import SystemController

/// Register your application's routes here.
public func routes(_ r: Routes, _ c: Container) throws {
    try Controller().routes(r, c)
}
```

### Endpoints

`SystemController` will give you two endpoints

* `[GET]  /info` - for a local system monitoring
* `[POST] /info` - for a remote system monitoring

The output should look somehow like this:
```json
{
    "cpu": {
        "clock": 2900000000,
        "physicalCpu": 4,
        "logicalCpu": 8
    },
    "usage": {
        "cpu": {
            "system": 14.18,
            "user": 7.9299999999999997,
            "idle": 77.879999999999995
        },
        "processes": [],
        "memory": {
            "total": 67108864,
            "free": 95,
            "used": 67108769
        }
    }
}
```
> All data should be in units, bytes or percentages where it makes sense

For remote connection you will need to `POST` connection details in the body of the request and make sure the `Content-Type` is set to `application/json`
```json
{
	"host": "172.16.217.131",
	"port": 22,
	"login": "pro",
	"password": "aaaaaa"
}
```
> Please don't connect to the IP, it's a real server!!!

### Swift level API

Through `SystemManager` library you can access monitoring from any Swift server side app that can support Apple `NIO` version 2

The basic usage is:

```swift
let eventLoop = EmbeddedEventLoop()
let manager = try SystemManager(
    .ssh(
        host: "ippppp",
        port: 22,
        username: "root",
        password: "sup3rS3cr3t"
    ),
    on: eventLoop
)
let output = try manager.info().wait()
```

### Author

Ondrej Rafaj - @rafiki270
*Did your try to connect to my server?!?! :D*


### License

MIT; Copyright 2019 - Einstore
