#if os(Linux)
import Glibc
#else
import Darwin.C
#endif

import utils

public class Server {
    var serverSocket: Socket
    var routes = [String: Any]()
    
    public init() {
        serverSocket = Socket(serverSocket: -1)
        serverSocket.connect()
    }
    
    public func addRoute(route: String, _ callback: () -> Void) {
        routes[route] = callback
    }

    func sendMessage(socket: Int32, message: String) {
        send(socket,[UInt8](message.utf8), Int(strlen(message)), 0)
    }
    
    public func start() {
        while (true) {
            #if os(Linux)
            var sockAddr: sockaddr = sockaddr()
            #else
            var sockAddr: sockaddr = sockaddr(sa_len: 0, sa_family: 0, sa_data: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
            #endif
            
            var sockLen: socklen_t = 0
            let sockClient = accept(serverSocket.sock, &sockAddr, &sockLen)
            
            let request = Request(socket: Socket(serverSocket: sockClient))
            request.echo()
            
            sendMessage(sockClient, message: "HTTP/1.1 200 OK\n")
            sendMessage(sockClient, message: "Server: Swfit Web Server\n")
            sendMessage(sockClient, message: "Content-Length: \("Hello Swift!".utf8.count)\n")
            sendMessage(sockClient, message: "Content-Type: text-plain\n")
            sendMessage(sockClient, message: "\r\n")
            sendMessage(sockClient, message: "Hello Swift!")
            
            close(sockClient)
        }
    }
}
