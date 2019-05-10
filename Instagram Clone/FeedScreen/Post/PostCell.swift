import UIKit

class PostCell: UICollectionViewCell, ConfigurableCell {
    static let headerSize: CGFloat = 56
    typealias Item = Post
    
    private var imageAspectRatio: CGFloat = 1
    private lazy var creatorView = PostCreatorView()
    private lazy var postContentView = PostContentView()
    private lazy var commentView = PostCommentView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(creatorView)
        addSubview(postContentView)
        addSubview(commentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(item: Post) {
        self.imageAspectRatio = item.aspectRatio
        
        creatorView.configure(with: item)
        postContentView.configure(with: item)
        commentView.configure(with: item)
    }
    
    override var frame: CGRect {
        didSet {
            creatorView.frame = CGRect(
                x: 0, y: 0,
                width: frame.width,
                height: PostCell.headerSize
            )
            
            postContentView.frame = CGRect(
                x: 0, y: creatorView.frame.maxY,
                width: frame.width,
                height: frame.width * imageAspectRatio + 56
            )
            
            commentView.frame = CGRect(
                x: 0,
                y: postContentView.frame.maxY,
                width: frame.width,
                height: frame.height - postContentView.frame.height - creatorView.frame.height
            )
        }
    }
}
