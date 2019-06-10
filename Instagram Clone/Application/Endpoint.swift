class Endpoint {
    static let host = "127.0.0.1"
    static let port = 8000
    static var tokenInfo: TokenInfo?
    
    static func registerToken(tokenInfo: TokenInfo?) {
        assert(self.tokenInfo == nil || tokenInfo == nil)
        self.tokenInfo = tokenInfo
    }
    
    static func loginRequest(username: String, password: String) -> WebService.Request {
        let params = [ "username" : username, "password": password ]
        let request = WebService.Request(
            host: host, path: "/auth/login/",
            params: params,
            port: port, httpMethod: .post
        )
        return request
    }
}
