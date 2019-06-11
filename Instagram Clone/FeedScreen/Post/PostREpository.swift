protocol PostRepository {
    func fetch(
        viewingAs user: User,
        completion: @escaping (Result<[PostFromApiResponse], Error>) -> Void
    )
    
    func sendLike(
        post: Post,
        completion: @escaping (Result<LikePostResponse, Error>) -> Void
    )
    
    func sendUnlike(
        post: Post,
        completion: @escaping (Result<UnlikePostResponse, Error>) -> Void
    )
}

class PostRepositoryImpl: PostRepository {
    
    private let webService: WebService
    
    init(webService: WebService = Injection.getWebService()) {
        self.webService = webService
    }
    
    func fetch(
        viewingAs user: User,
        completion: @escaping (Result<[PostFromApiResponse], Error>) -> Void
    ) {
        let request = Endpoint.fetchPostsRequest(viewingAs: user)
        webService.execute(request: request, completion: completion)
    }
    
    func sendLike(
        post: Post,
        completion: @escaping (Result<LikePostResponse, Error>) -> Void
    ) {
        let request = Endpoint.likeRequest(for: post)
        webService.execute(request: request, completion: completion)
    }
    
    func sendUnlike(
        post: Post,
        completion: @escaping (Result<UnlikePostResponse, Error>) -> Void
    ) {
        let request = Endpoint.unlikeRequest(for: post)
        webService.execute(request: request, completion: completion)
    }
}
