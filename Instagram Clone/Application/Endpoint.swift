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
            host: host, path: "/auth/login/", params: params, port: port, httpMethod: .post
        )
        return request
    }
    
    static func fetchPostsRequest(viewingAs user: User) -> WebService.Request {
        guard let tokenInfo = tokenInfo else {
            fatalError("Nil token here indicates programming error.")
        }

        let request = WebService.Request(
            host: host, path: "/v1/post/", params: nil, port: port, httpMethod: .get,
            cookies: nil, accessToken: tokenInfo.accessToken
        )
        return request
    }
    
    static func likeRequest(for post: Post) -> WebService.Request {
        guard let tokenInfo = tokenInfo else {
            fatalError("Nil token here indicates programming error.")
        }
        
        let request = WebService.Request(
            host: host, path: "/v1/post/\(post.id)/like/",
            params: nil, port: port, httpMethod: .post,
            cookies: nil, accessToken: tokenInfo.accessToken
        )
        return request
    }
    
    static func unlikeRequest(for post: Post) -> WebService.Request {
        guard let tokenInfo = tokenInfo else {
            fatalError("Nil token here indicates programming error.")
        }
        
        let request = WebService.Request(
            host: host, path: "/v1/post/\(post.id)/unlike/",
            params: nil, port: port, httpMethod: .post,
            cookies: nil, accessToken: tokenInfo.accessToken
        )
        return request
    }
    
    static func fetchCommentRequest(
        for post: Post,
        lastCommentId: Post.Comment.IdType?
    ) -> WebService.Request {
        guard let tokenInfo = tokenInfo else {
            fatalError("Nil token here indicates programming error.")
        }
        
        let params: [String: String]?
        if let id = lastCommentId {
            params = ["lastCommentId" : "\(id)"]
        } else {
            params = nil
        }

        let request = WebService.Request(
            host: host, path: "v1/post/\(post.id)/comment/",
            params: params, port: port, httpMethod: .get,
            cookies: nil, accessToken: tokenInfo.accessToken
        )
        return request
    }
}
