import UIKit

class NewFeedScreenViewController: BaseCollectionViewController {
    
    private let fetchPosts: FetchPostsUseCase
    private let fetchStories: FetchStoriesUseCase
    
    private let user: User
    
    init(viewingAs user: User,
         fetchPosts: FetchPostsUseCase = .init(),
         fetchStories: FetchStoriesUseCase = .init()) {
        self.user = user
        self.fetchPosts = fetchPosts
        self.fetchStories = fetchStories
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPosts.execute(user, completion: postsFetched(_:))
        fetchStories.execute(user, completion: storiesFetched(_:))
    }
    
    override func handleRefresh() {
        fetchPosts.execute(user, completion: postsFetched(_:))
    }
    
    private func postsFetched(_ posts: [Post]) {
        self.dataSource = FeedPostDataSource(posts: posts.map { return PostItem($0) })
    }
    
    private func storiesFetched(_ stories: [Story]) {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var h = PostCollectionViewCell.fixedHeight
        let w = view.frame.width
        if let item = dataSource?.item(at: indexPath) as? PostItem {
            h += view.frame.width * item.post.aspectRatio
            h += PostCollectionViewCell.heightFor(item, cellWidth: w)
            return .width(w, height: h)
        }
        
        return .width(w, height: w + h)
    }
    
    override func viewController() -> BaseCollectionViewController {
        return self
    }
}

extension NewFeedScreenViewController: PostLikeUnlikeDelegate, PostNavigateCommentDelegate, PostNavigateShareDelegate {
    func postLiked(_ postId: Post.IdType) {
        print("Post liked: \(postId)")
//        updateLocalLike(increaseLike: true, forPostWith: postId)
    }
    
     func postUnliked(_ postId: Post.IdType) {
        print("Post unliked: \(postId)")
//        updateLocalLike(increaseLike: false, forPostWith: postId)
    }
    
//    private func updateLocalLike(increaseLike: Bool, forPostWith postId: Post.IdType) {
//        guard let index = dataSource?.firstIndex(predicate: { obj in
//            guard let item = obj as? PostItem else {
//                return false
//            }
//            return item.post.postId == postId
//        }) else {
//            return
//        }
//
//    }
    
    func navigateComment(_ postId: Post.IdType) {
        print("To comment: \(postId)")
    }
    
    func navigateShare(_ postId: Post.IdType) {
        print("To share: \(postId)")
    }
}

protocol PostLikeUnlikeDelegate: class {
    func postLiked(_ postId: Post.IdType)
    func postUnliked(_ postId: Post.IdType)
}

protocol PostNavigateCommentDelegate: class {
    func navigateComment(_ postId: Post.IdType)
}

protocol PostNavigateShareDelegate: class {
    func navigateShare(_ postId: Post.IdType)
}
