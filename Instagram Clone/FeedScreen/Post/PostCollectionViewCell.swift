import UIKit

class PostCollectionViewCell: CollectionViewCell {
    
    private static var fixedHeight: CGFloat = headerHeight + contentExpansionHeight
    private static var headerHeight: CGFloat = 56
    private static var contentExpansionHeight: CGFloat = 56
    
    static func heightFor(_ item: PostItem?, cellWidth: CGFloat) -> CGFloat {
        guard let item = item else {
            return fixedHeight
        }

        let imageHeight = cellWidth * item.post.aspectRatio
        let interactionHeight = PostInteractionView.heightFor(item, cellWidth: cellWidth)
        return imageHeight + interactionHeight + fixedHeight
    }
    
    private lazy var creatorView = PostCreatorView()
    private lazy var postContentView = PostContentView()
    private lazy var commentView = PostInteractionView()
    
    private var imageRatio: CGFloat = 1.0
    
    private var postItem: PostItem!
    
    override var viewController: BaseCollectionViewController? {
        didSet {
            setupDelegates()
        }
    }
    
    override func prepareUI() {
        super.prepareUI()
        addSubview(creatorView)
        addSubview(postContentView)
        addSubview(commentView)
        lineDivider.invisible()
        setupConstraints()
        setupDelegates()
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
    
    private func setupDelegates() {
        if let delegate = self.viewController as? PostLikeUnlikeDelegate {
            postContentView.likeUnlikeDelegate = delegate
        }
        
        if let delegate = self.viewController as? PostNavigateShareDelegate {
            postContentView.navigateShareDelegate = delegate
        }
        
        if let delegate = self.viewController as? PostNavigateCommentDelegate {
            postContentView.navigateCommentDelegate = delegate
        }
        
        postContentView.rebindClosure = rebind
    }
    
    override func configureCell(with item: Any?) {
        guard let postItem = item as? PostItem else {
            return
        }
        
        self.postItem = postItem
        let post = postItem.post
        imageRatio = post.aspectRatio
        creatorView.configure(with: post)
        postContentView.configure(with: post)
        commentView.configure(with: postItem)
    }
    
    private func rebind() {
        configureCell(with: self.postItem)
    }
}
