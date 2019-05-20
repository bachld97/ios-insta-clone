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
        let item = dataSource?.item(at: indexPath) as? PostItem
        let w = view.frame.width
        let h = PostCollectionViewCell.heightForCell(item, cellWidth: w)
        return .width(w, height: h)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .width(view.frame.width, height: 80)
    }
}

extension FeedScreenViewController: PostEventDelegate {
    func postEvent(_ event: PostEvent, happeningOn cell: CollectionViewCell) {
        guard let item = cell.item as? PostItem else {
            return
        }
        
        let sameId: (Any) -> Bool = { it in
            guard let it = it as? PostItem else {
                return false
            }
            return it.post.postId == item.post.postId
        }
        
        switch event {
        case .expandCaption:
            dataSource?.replaceItem(predicate: sameId, transformIfTrue: { it in
                guard let item = it as? PostItem else {
                    return it
                }
                return item.toExpanded()
            })
            collectionView.reloadData()
        case .like:
            sendLike(for: item.post)
            dataSource?.replaceItem(predicate: sameId, transformIfTrue: { it in
                guard let item = it as? PostItem else {
                    return it
                }
                return item.toLiked()
            })
        case .likeToggle:
            toggleLike(for: item.post)
            dataSource?.replaceItem(predicate: sameId, transformIfTrue: { it in
                guard let item = it as? PostItem else {
                    return it
                }
                return item.toggleLike()
            })
        case .navigateComment:
            print("Navigate comment: \(item.post.postId)")
        case .navigateShare:
            print("Navigate share: \(item.post.postId)")
        case .navigateCreator:
            print("Navigate creator: \(item.post.creator.name)")
        case .imagePositionUpdate(let index):
            dataSource?.replaceItem(predicate: sameId, transformIfTrue: { it in
                guard let item = it as? PostItem else {
                    return it
                }
                return item.setCurrentImage(index)
            })
        }
    }
    
    private func sendLike(for post: Post) {
        
    }
    
    private func sendUnlike(for post: Post) {
        
    }
    
    private func toggleLike(for post: Post) {
        if post.content.likedByMe {
            sendUnlike(for: post)
        } else {
            sendLike(for: post)
        }
    }
}
