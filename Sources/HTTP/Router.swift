public class Router {
    private(set) var routers = [Route]()
    
    public init() {  }
    
    public func addRoute(route: Route) {
        routers.append(route)
    }
    
    public func findRoute(path: String, method: HTTPMethod) -> Route? {
        for route in routers {
            if route.path == path && route.method == method {
                print("Route found! \(path)")
                return route
            }
        }
        
        return nil
    }
}