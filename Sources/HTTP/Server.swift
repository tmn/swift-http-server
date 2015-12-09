import func libc.accept
import func libc.close
import func libc.send
import func libc.strlen
import struct libc.sockaddr
import struct libc.socklen_t

import class utils.Socket

public enum Action {
    case Send(Response)
}

extension Action {
    func response() -> Response {
        switch self {
        case .Send(let res):
            return res
        }
    }
}

public class Server {
    var serverSocket: Socket
    var routes = [String: Any]()
    var router = Router()
    
    public typealias Handler = (Request, Response) -> Action
    
    public init() {
        serverSocket = Socket(serverSocket: -1)
        serverSocket.connect()
    }
    
    public func addRoute(route: String, _ callback: () -> Void) {
        routes[route] = callback
    }
    
    public func start() {
        while true {
            #if os(Linux)
            var sockAddr: sockaddr = sockaddr()
            #else
            var sockAddr: sockaddr = sockaddr(sa_len: 0, sa_family: 0, sa_data: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))
            #endif
            
            var sockLen: socklen_t = 0
            
            let sockClient = accept(serverSocket.sock, &sockAddr, &sockLen)
            let request = Request(socket: Socket(serverSocket: sockClient))
            
            handleRequest(sockClient, request: request)
            
            close(sockClient)
        }
    }
    
    private func handleRequest(socket: Int32, request: Request) {
        print("Path: \(request.path), method: \(request.method)")
        
        if let route = router.findRoute(request.path, method: request.method) {
            let res: Response = route.handler( ( request, Response() ) ).response()
            
            sendMessage(socket, message: res.headers())
            sendMessage(socket, message: res.body)
        }
    }
    
    func sendMessage(socket: Int32, message: String) {
        send(socket,[UInt8](message.utf8), Int(strlen(message)), 0)
    }
    
    
    
    public func post(path: String, _ handler: Handler) {
        router.addRoute(Route(method: HTTPMethod.POST, path: path, handler: handler))
    }
    
    public func get(path: String, _ handler: Handler) {
        router.addRoute(Route(method: HTTPMethod.GET, path: path, handler: handler))
    }
}
