import HTTP
import libc

var server = Server()

server.get("/") { req, res in
    res.body = "Tri er best!"
    
    return .Send(res)
}

server.get("/test") { req, res in
    res.body = "Dette er /test"
    
    return .Send(res)
}

server.start()