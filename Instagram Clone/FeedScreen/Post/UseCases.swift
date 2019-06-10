import Foundation

class FetchPostsUseCase: UseCase {
    typealias Request = User
    typealias Response = [Post]
    
    private let postRepository: PostRepository
    
    init(postRepository: PostRepository = Injection.getPostRepository()) {
        self.postRepository = postRepository
    }
    
    func execute(_ request: User, completion: @escaping ([Post]) -> Void) {
        let handleResult: (Result<[PostFromApiResponse], Error>) -> Void = { result in
            switch result {
            case .success(let posts):
                let localPosts = posts.map {
                    $0.toLocalPost()
                }.filter {
                    return !$0.content.images.isEmpty
                }
                return completion(localPosts)
            case .failure(let error):
                print("Error loading posts: \(error)")
                return completion([])
            }
        }
        
        self.postRepository.fetch(viewingAs: request, completion: handleResult)
    }
}

protocol PostRepository {
    func fetch(
        viewingAs user: User,
        completion: @escaping (Result<[PostFromApiResponse], Error>) -> Void
    )
}

class PostRepositoryImpl: PostRepository {
    
    private let webService: WebService
    
    init(webService: WebService = .init()) {
        self.webService = webService
    }
    
    func fetch(
        viewingAs user: User,
        completion: @escaping (Result<[PostFromApiResponse], Error>) -> Void
    ) {
        let request = Endpoint.fetchPostsRequest(viewingAs: user)
        webService.execute(request: request, completion: completion)
    }
}


class SendLikeUseCase: UseCase {
    func execute(_ request: Post, completion: @escaping (Bool) -> Void) {
        
    }
    
    typealias Request = Post
    typealias Response = Bool
}

class SendUnlikeUseCase: UseCase {
    func execute(_ request: Post, completion: @escaping (Bool) -> Void) {
        
    }
    
    typealias Request = Post
    typealias Response = Bool
}
