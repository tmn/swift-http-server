import func libc.send
import func libc.strlen
import class utils.Socket

public enum HTTPCode {
    case Success
    case Redirection
    case ClientError
    case ServerError
}

extension HTTPCode {
    
}

public class Response {
    public init(_ path: String, _ headers: [String: String]) {
        
    }
    
    public init(_ path: String, _ headers: [String: String], _ body: String) {
        
    }
    
    func sendMessage(socket: Int32, message: String) {
        send(socket,[UInt8](message.utf8), Int(strlen(message)), 0)
    }
    
    public func sendHeader(socket: Int32, length: Int) {
        sendMessage(socket, message: "HTTP/1.1 200 OK\n")
        sendMessage(socket, message: "Server: Swfit Web Server\n")
        sendMessage(socket, message: "Content-Length: \(length)\n")
        sendMessage(socket, message: "Content-Type: text-plain\n")
        sendMessage(socket, message: "\r\n")
    }
}