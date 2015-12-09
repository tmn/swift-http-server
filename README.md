AWesome piece of Swift


## Example server

```swift
import HTTP
import libc

var server = Server()

server.get("/") { req, res in
    res.body = "This is root!"

    return .Send(res)
}

server.start()
```

## Building and running

Build the project from within the project directory using `swift build`. Run the project using `./.build/debug/SwiftServer`

## Run using vagrant + VirtualBox

Set up vagrant using `vagrant up --provider virtualbox`. This will innitialize an Ubuntu 14.04 system with Swift. Working files are located at `/vagrant/`.
