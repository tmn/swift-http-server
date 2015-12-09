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
    var contentLength: Int = 0
    var rawContent: String?
    
    public var body: String = "" {
        didSet {
            contentLength = body.utf8.count
        }
    }
    
    public init() {  }
    
    func echo() {
        print("EHOC")
    }
    
    public func headers() -> String {
        var headers = [String]()
        
        headers.append("HTTP/1.1 200 OK\n")
        headers.append("Server: Swfit Web Server\n")
        headers.append("Content-Length: \(contentLength)\n")
        headers.append("Content-Type: text-plain\n")
        headers.append("\r\n")
        
        return headers.joinWithSeparator("")
    }
    
}