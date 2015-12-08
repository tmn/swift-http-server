import libc

public class Socket {
    public var sock: Int32
    var bufferSize: Int
    
    public init(serverSocket: Int32) {
        sock = serverSocket
        bufferSize = 1024
    }
    
    public func connect(port: in_port_t = 8080) {
        #if os(Linux)
        sock = socket(AF_INET, Int32(SOCK_STREAM.rawValue), 0)
            
        var serverAddress: sockaddr_in = sockaddr_in(
            sin_family: sa_family_t(AF_INET),
            sin_port: htons(port),
            sin_addr: in_addr(s_addr: inet_addr("0.0.0.0")),
            sin_zero: (0, 0, 0, 0, 0, 0, 0, 0)
        )
        #else
        sock = socket(AF_INET, Int32(SOCK_STREAM), 0)
        
        var serverAddress: sockaddr_in = sockaddr_in(
            sin_len: __uint8_t(sizeof(sockaddr_in)),
            sin_family: sa_family_t(AF_INET),
            sin_port: htons(port),
            sin_addr: in_addr(s_addr: inet_addr("0.0.0.0")),
            sin_zero: (0, 0, 0, 0, 0, 0, 0, 0)
        )
        #endif
        
        setsockopt(sock, SOL_SOCKET, SO_RCVBUF, &bufferSize, socklen_t(sizeof(Int)))
        
        if bind(sock, sockaddrPointer(&serverAddress), socklen_t(UInt8(sizeof(sockaddr_in)))) == -1 {
            exit(1)
        }
        
        if listen(sock, SOMAXCONN) == -1 {
            exit(1)
        }
    }
    
    public func socketMessage() -> Int {
        var buffer = [UInt8](count: 1, repeatedValue: 0)
        let socketMessage = recv(sock, &buffer, buffer.count, 0)
        
        if socketMessage <= 0 {
            return socketMessage
        }
        
        return Int(buffer[0])
    }
    
    public func bufferedLine() -> String {
        var returnString: String = ""
        var keyCode: Int
        
        repeat {
            keyCode = socketMessage()
            if keyCode > 13 {
                returnString.append(UnicodeScalar(keyCode))
            }
        } while keyCode > 0 && keyCode != 10
        
        return returnString
    }
    
    func sockaddrPointer(pointer: UnsafeMutablePointer<Void>) -> UnsafeMutablePointer<sockaddr> {
        return UnsafeMutablePointer<sockaddr>(pointer)
    }
    
    func htons(port: in_port_t) -> in_port_t {
    #if os(Linux)
        // TODO: check edians
        return (port << 8) + (port >> 8)
    #else
        return Int(OSHostByteOrder()) == OSLittleEndian ? _OSSwapInt16(port) : port
    #endif
    }
}
