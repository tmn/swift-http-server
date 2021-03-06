import utils
import func libc.exit

public enum HTTPMethod: String {
    case POST
    case GET
}

extension HTTPMethod {
    func req(path: String, _ headers: [String: String], _ body: String = "") -> Response {
        switch self {
        case .POST:
            print("POST")
            return Response()
            
        case .GET:
            print("GET")
            return Response()
        }
    }
}

public class Request {
    private var sock: Socket
    
    public var response: Response!
    public let method: HTTPMethod
    public let path: String
    public var params: [(String, String)]!
    public var headers: [String: String]!
    public var body: String?
    
    init(socket: Socket) {
        sock = socket
        
        let buffer: String = socket.bufferedLine()
        let bufferTokens: [String] = buffer.characters.split{ $0 == " " }.map(String.init)
        
        guard bufferTokens.count > 2 else {
            exit(1)
        }
        
        method = HTTPMethod(rawValue: bufferTokens[0].uppercaseString)!
        path = bufferTokens[1]
        params = self.parseParams(path)
        headers = self.parseHeaders()
        
        if let contentLength = headers["content-length"], let contentLengthValue: Int = Int(contentLength) {
            body = self.body(contentLengthValue)
        }
        /*
        if let httpMethod = HTTPMethod(rawValue: method) {
            if let requestBody = body {
                response = httpMethod.req(path, headers, requestBody)
            }
            else {
                response = httpMethod.req(path, headers)
            }
        }
        */
    }
    
    func echo() {
        print("Test: \(method), \(path) \(params), \(headers), \(body)")
    }
    
    func parseParams(url: String) -> [(String, String)] {
        guard let rawParams = (url.characters.split{ $0 == "?" }).map(String.init).last else {
            return []
        }
        
        return rawParams.characters.split{ $0 == "&" }.map(String.init).map { (param: String) -> (String, String) in
            let keyValue = param.characters.split{ $0 == "=" }.map(String.init)
            
            guard keyValue.count >= 2 else {
                return ("", "")
            }
            
            return (keyValue[0], keyValue[1])
        }
    }
    
    func parseHeaders() -> [String: String] {
        var header: String
        var requestHeaders = [String: String]()
        
        repeat {
            header = sock.bufferedLine()
            
            var headerElement = header.characters.split{ $0 == ":" }.map(String.init)
            
            if headerElement.count >= 2 {
                let headerName = headerElement[0].lowercaseString
                let headerValue = headerElement[1]
                
                if !headerName.isEmpty && !headerValue.isEmpty {
                    requestHeaders.updateValue(headerValue, forKey: headerName)
                }
            }
        } while !header.isEmpty
        
        return requestHeaders
    }
    
    private func body(size: Int) -> String {
        var body: String?
        var counter = 0;
        
        while counter < size {
            body!.append(UnicodeScalar(sock.socketMessage()))
            counter++;
        }
        
        return body!
    }
}
