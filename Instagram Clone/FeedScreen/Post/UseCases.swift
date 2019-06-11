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

class SendLikeUseCase: UseCase {
    typealias Request = Post
    typealias Response = Bool
    
    private let postRepository: PostRepository
    
    init(postRepository: PostRepository = Injection.getPostRepository()) {
        self.postRepository = postRepository
    }
    
    func execute(_ request: Post, completion: @escaping (Bool) -> Void) {
        let sendLikeCallback: (Result<LikePostResponse, Error>) -> Void = { result in
            switch result {
            case .success(let response):
                return completion(response.success)
            case .failure(let error):
                print("DEBUG: error send like - \(error)")
                return completion(false)
            }
        }
        
        postRepository.sendLike(post: request, completion: sendLikeCallback)
    }
}

class SendUnlikeUseCase: UseCase {
    typealias Request = Post
    typealias Response = Bool
    
    private let postRepository: PostRepository
    
    init(postRepository: PostRepository = Injection.getPostRepository()) {
        self.postRepository = postRepository
    }
    
    func execute(_ request: Post, completion: @escaping (Bool) -> Void) {
        let sendUnlikeCallback: (Result<UnlikePostResponse, Error>) -> Void = { result in
            switch result {
            case .success(let response):
                return completion(response.success)
            case .failure(let error):
                print("DEBUG: error send unlike - \(error)")
                return completion(false)
            }
        }
        
        postRepository.sendUnlike(post: request, completion: sendUnlikeCallback)
    }
}
