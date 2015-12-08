import HTTP
import libc

var server = Server()

server.addRoute("/test") {
    print("This is route!")
}

server.start()