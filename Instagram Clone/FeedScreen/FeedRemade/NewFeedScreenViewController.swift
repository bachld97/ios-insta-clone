import UIKit

class NewFeedScreenViewController: BaseCollectionViewController {
    
    private let fetchPosts: FetchPostsUseCase
    private let user: User
    
    init(viewingAs user: User, fetchPosts: FetchPostsUseCase = .init()) {
        self.user = user
        self.fetchPosts = fetchPosts
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPosts.execute(user, completion: postsFetched(_:))
    }
    
    override func handleRefresh() {
        fetchPosts.execute(user, completion: postsFetched(_:))
    }
    
    private func postsFetched(_ posts: [Post]) {
        self.dataSource = FeedPostDataSource(posts: posts.map { return PostItem($0) })
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var h = PostCollectionViewCell.fixedHeight
        if let item = dataSource?.item(at: indexPath) as? PostItem {
            h += view.frame.width * item.post.aspectRatio
            h += PostCollectionViewCell.heightForCaption(
                item.post.content.caption, creator: item.post.creator
            )
            return .width(view.frame.width, height: h)
        }
        
        return .width(view.frame.width, height: view.frame.width + h)
    }
}

class PostItem {
    private var isTextExpanded = false
    private (set) var post: Post
    
    init(_ post: Post) {
        self.post = post
    }
}

class FeedPostDataSource: CollectionViewDataSource {
    init(posts: [PostItem]) {
        super.init(objects: posts)
    }
    
    override func cellClasses() -> [CollectionViewCell.Type] {
        return [PostCollectionViewCell.self]
    }
}

class PostCollectionViewCell: CollectionViewCell {
    
    static var fixedHeight: CGFloat = headerHeight + contentExpansionHeight
    static var headerHeight: CGFloat = 56
    static var contentExpansionHeight: CGFloat = 56
    
    static func heightForCaption(_ caption: String, creator: User) -> CGFloat {
        return 56
    }
    
    private lazy var creatorView = PostCreatorView()
    private lazy var postContentView = PostContentView()
    private lazy var commentView = PostInteractionView()
    
    private var imageRatio: CGFloat = 1.0
    
    override func prepareUI() {
        super.prepareUI()
        addSubview(creatorView)
        addSubview(postContentView)
        addSubview(commentView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        creatorView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .zero,
            size: .height(PostCollectionViewCell.headerHeight)
        )
        
        postContentView.anchor(
            top: creatorView.bottomAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .zero,
            size: .height(
                PostCollectionViewCell.contentExpansionHeight + frame.width * imageRatio
            )
        )
        
        commentView.anchor(
            top: postContentView.bottomAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor
        )
    }
    
    override func configureCell(with item: Any?) {
        guard let postItem = item as? PostItem else {
            return
        }
        
        let post = postItem.post
        imageRatio = post.aspectRatio
        creatorView.configure(with: post)
        postContentView.configure(with: post)
        commentView.configure(with: post)
    }
}
