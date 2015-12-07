import HTTP

var server = Server()

server.addRoute("/test") {
    print("This is route!")
}

server.start()
