class FetchCommentUseCase: UseCase {
    typealias Request = (post: Post, lastCommentId: Post.Comment.IdType?)
    typealias Response = [Post.Comment]
    
    private let postRepository: PostRepository
    
    init(postRepository: PostRepository = Injection.getPostRepository()) {
        self.postRepository = postRepository
    }
    
    func execute(
        _ request: (post: Post, lastCommentId: Post.Comment.IdType?),
        completion: @escaping ([Post.Comment]) -> Void
        ) {
        // Should this transformation be done at the Repository?
        let commentsFetched: (Result<[CommentFromApiResponse], Error>) -> Void  = { result in
            switch result {
            case .success(let comments):
                return completion(comments.map { $0.toLocalComment() })
            case .failure(let error):
                print("Error loading comments: \(error)")
                return completion([])
            }
        }
        
        postRepository.getComments(
            post: request.post,
            lastCommentId: request.lastCommentId, completion: commentsFetched)
    }
}


class SendCommentUseCase {
}
