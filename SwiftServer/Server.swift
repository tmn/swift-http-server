import Darwin

class Server {
    var serverSocket: Int32 = 0
    var bufferSize = 1024
    
    init() {
        serverSocket = socket(AF_INET, Int32(SOCK_STREAM), 0)
        let port : in_port_t = 8080
        
        var serverAddress: sockaddr_in = sockaddr_in(
            sin_len: __uint8_t(sizeof(sockaddr_in)),
            sin_family: sa_family_t(AF_INET),
            sin_port: htons(port),
            sin_addr: in_addr(s_addr: inet_addr("0.0.0.0")),
            sin_zero: (0, 0, 0, 0, 0, 0, 0, 0)
        )
        
        setsockopt(serverSocket, SOL_SOCKET, SO_RCVBUF, &bufferSize, socklen_t(sizeof(Int)))
        
        if bind(serverSocket, getSockaddrPointer(&serverAddress), socklen_t(UInt8(sizeof(sockaddr_in)))) == -1 {
            exit(1)
        }
        
        if listen(serverSocket, SOMAXCONN) == -1 {
            exit(1)
        }
        
        // start server
        start()
    }
    
    
    
    /*
    ------------------------------------------------------------------------------------*/
    func getSockaddrPointer(pointer: UnsafeMutablePointer<Void>) -> UnsafeMutablePointer<sockaddr> {
        return UnsafeMutablePointer<sockaddr>(pointer)
    }
    
    func htons(port: in_port_t) -> in_port_t {
        return Int(OSHostByteOrder()) == OSLittleEndian ? _OSSwapInt16(port) : port
    }
    
    func sendMessage(socket: Int32, message: String) {
        send(socket,[UInt8](message.utf8), Int(strlen(message)), 0)
    }
    
    
    
    /*
    ------------------------------------------------------------------------------------*/
    func start() {
        while (true) {
            let client = accept(serverSocket, nil, nil)
            
            sendMessage(client, message: "HTTP/1.1 200 OK\n")
            sendMessage(client, message: "Server: Swfit Web Server\n")
            sendMessage(client, message: "Content-Length: \("Hello Swift!".utf8.count)\n")
            sendMessage(client, message: "Content-Type: text-plain\n")
            sendMessage(client, message: "\r\n")
            sendMessage(client, message: "Hello Swift!")
            
            close(client)
            
        }
    }
}