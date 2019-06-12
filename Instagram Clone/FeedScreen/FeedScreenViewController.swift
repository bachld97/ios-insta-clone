import UIKit

class FeedScreenViewController: BaseCollectionViewController {
    
    private let fetchPosts: FetchPostsUseCase
    private let fetchStories: FetchStoriesUseCase
    private let sendLike: SendLikeUseCase
    private let sendUnlike: SendUnlikeUseCase
    
    private let user: User
    
    private let feedDataSource = FeedPostDataSource()
    
    init(viewingAs user: User,
         fetchPosts: FetchPostsUseCase = .init(),
         fetchStories: FetchStoriesUseCase = .init(),
         sendLike: SendLikeUseCase = .init(),
         sendUnlike: SendUnlikeUseCase = .init()
    ) {
        self.user = user
        self.fetchPosts = fetchPosts
        self.fetchStories = fetchStories
        self.sendLike = sendLike
        self.sendUnlike = sendUnlike
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContent()
    }
    
    private func loadContent() {
        fetchPosts.execute(user, completion: postsFetched(_:))
        fetchStories.execute(user, completion: storiesFetched(_:))
    }

    override func handleRefresh() {
        loadContent()
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
    
//    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let item = dataSource?.item(at: indexPath) as? PostItem
//        let w = view.frame.width
//        let h = PostCollectionViewCell.heightForCell(item, cellWidth: w)
//        return .width(w, height: h)
//    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .width(view.frame.width, height: 80)
    }
}

extension FeedScreenViewController: PostEventDelegate {
    func postEvent(_ event: PostEvent, happeningOn cell: CollectionViewCell) {
        guard let item = cell.item as? PostItem else {
            return
        }
        
        let isPostEqual: (Any) -> Bool = { it in
            guard let it = it as? PostItem else {
                return false
            }
            return it.post == item.post
        }
        
        let reload = {
            if let ip = self.dataSource?.constructIndexPath(for: item, usingPredicate: isPostEqual) {
                self.collectionView.reloadItems(at: [ip])
            } else {
                self.collectionView.reloadData()
            }
        }
        
        
        switch event {
        case .expandCaption:
            dataSource?.replaceItem(predicate: isPostEqual, transformIfTrue: { it in
                guard let item = it as? PostItem else {
                    return it
                }
                return item.toExpanded()
            })
            reload()
        case .like:
            requestSendLike(for: item.post)
            dataSource?.replaceItem(predicate: isPostEqual, transformIfTrue: { it in
                guard let item = it as? PostItem else {
                    return it
                }
                return item.toLiked()
            })
        case .likeToggle:
            toggleLike(for: item.post)
            dataSource?.replaceItem(predicate: isPostEqual, transformIfTrue: { it in
                guard let item = it as? PostItem else {
                    return it
                }
                return item.toggleLike()
            })
        case .navigateComment:
            let lastCommentId = item.post.comments.last?.id
            let vc = CommentScreenViewController(
                viewingAs: user, postToLoad: item.post, lastCommentId: lastCommentId
            )
            self.navigationController?.pushViewController(vc, animated: true)
            // present(vc, animated: true, completion: nil)
        case .navigateShare:
            print("Navigate share: \(item.post.id)")
        case .navigateCreator:
            print("Navigate creator: \(item.post.creator.name)")
        case .imagePositionUpdate(let index):
            dataSource?.replaceItem(predicate: isPostEqual, transformIfTrue: { it in
                guard let item = it as? PostItem else {
                    return it
                }
                return item.setCurrentImage(index)
            })
        }
    }
    
    private func requestSendLike(for post: Post) {
        sendLike.execute(post, completion: { isSuccess in
            print("Send like action is successful: \(isSuccess)")
        })
    }
    
    private func requestSendUnlike(for post: Post) {
        sendUnlike.execute(post, completion: { isSuccess in
            print("Send unlike action is successful: \(isSuccess)")
        })
    }
    
    private func toggleLike(for post: Post) {
        if post.content.likedByMe {
            requestSendUnlike(for: post)
        } else {
            requestSendLike(for: post)
        }
    }
}
