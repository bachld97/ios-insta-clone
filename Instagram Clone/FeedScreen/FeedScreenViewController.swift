import UIKit

class FeedScreenViewController: BaseCollectionViewController {
    
    private let fetchPosts: FetchPostsUseCase
    private let fetchStories: FetchStoriesUseCase
    
    private let user: User
    
    private let feedDataSource = FeedPostDataSource()
    
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
        feedDataSource.posts = posts.map {
            return PostItem($0)
        }
        self.dataSource = feedDataSource
    }
    
    private func storiesFetched(_ stories: [Story]) {
        feedDataSource.stories = stories.map {
            return StoryItem($0)
        }
        self.dataSource = feedDataSource
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 0 {
            return .width(view.frame.width, height: 80)
        }
        
        var h = PostCollectionViewCell.fixedHeight
        let w = view.frame.width
        if let item = dataSource?.item(at: indexPath) as? PostItem {
            h += view.frame.width * item.post.aspectRatio
            h += PostCollectionViewCell.heightFor(item, cellWidth: w)
            return .width(w, height: h)
        }
        
        return .width(w, height: w + h)
    }
}

extension FeedScreenViewController: PostLikeUnlikeDelegate, PostNavigateCommentDelegate, PostNavigateShareDelegate {
    func postLiked(_ postId: Post.IdType) {
        print("Post liked: \(postId)")
    }
    
     func postUnliked(_ postId: Post.IdType) {
        print("Post unliked: \(postId)")
    }
    
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
