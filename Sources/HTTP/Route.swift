public class Route {    
    var method: HTTPMethod
    var path: String
    var handler: Handler
    
    public typealias Handler = (Request, Response) -> Action
    
    init(method: HTTPMethod, path: String, handler: Handler) {
        self.method = method
        self.path = path
        self.handler = handler
    }
}