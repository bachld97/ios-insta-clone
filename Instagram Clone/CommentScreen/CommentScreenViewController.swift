import UIKit

class CommentScreenViewController: BaseCollectionViewController {
    
    private let user: User
    private let fetchComments: FetchCommentUseCase
    private let sendComment: SendCommentUseCase
    private let lastCommentId: Post.Comment.IdType?
    private let post: Post
    
    private let commentDataSource: CommentsDataSource
    
    init(viewingAs user: User,
         postToLoad post: Post,
         lastCommentId: Post.Comment.IdType?,
         fetchComments: FetchCommentUseCase = .init(),
         sendComment: SendCommentUseCase = .init()
    ) {
        self.user = user
        self.post = post
        self.fetchComments = fetchComments
        self.sendComment = sendComment
        self.lastCommentId = lastCommentId
        
        let commentItems = post.comments.map {
            return CommentItem(comment: $0, isMyComment: $0.creator.id == user.id)
        }
        
        var data: [Any] = [post]
        data.append(contentsOf: commentItems)
        
        self.commentDataSource = CommentsDataSource(objects: data)
        super.init()
    }
    
    override func handleRefresh() {
        fetchComments.execute((post, lastCommentId), completion: commentsFetched(_:))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = commentDataSource
        fetchComments.execute((post, lastCommentId), completion: commentsFetched(_:))
    }
    
    private func commentsFetched(_ comments: [Post.Comment]) {
        let commentItems = comments.map {
            return CommentItem(comment: $0, isMyComment: $0.creator.id == user.id)
        }
        dataSource = commentDataSource.cloneSelf(withExtraComments: commentItems)
    }
}


class MyMessageCell: CollectionViewCell {
    
    override class func heightForCell(_ item: Any?, cellWidth: CGFloat) -> CGFloat {
        guard let commentItem = item as? CommentItem else {
            return super.heightForCell(item, cellWidth: cellWidth)
        }
        
        let font = Styles.MessageCell.commentFont
        let marginLeft = Styles.MessageCell.maxMarginOnEmptySide
        let labelInsets = Styles.MessageCell.labelInsets
        let labelMargin = Styles.MessageCell.labelMargin
        
        let labelWidth = cellWidth - labelMargin.right - marginLeft - labelInsets.left - labelInsets.right

        return commentItem.comment.content.heightToDisplay(
            fixedWidth: labelWidth, font: font
        ) + labelInsets.top + labelInsets.bottom + labelMargin.top + labelMargin.bottom
    }

    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = Styles.MessageCell.commentFont
        label.textColor = Styles.MessageCell.commentColor
        return label
    }()
    
    private lazy var labelContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 0.6
        view.layer.borderColor = Styles.MessageCell.labelBorderColor
        return view
    }()
    
    override func prepareUI() {
        labelContainer.addSubview(contentLabel)
        addSubview(labelContainer)
        
        let labelInsets = Styles.MessageCell.labelInsets
        let labelPadding = Styles.MessageCell.labelMargin
        
        contentLabel.anchor(
            top: labelContainer.topAnchor,
            leading: labelContainer.leadingAnchor,
            bottom: labelContainer.bottomAnchor,
            trailing: labelContainer.trailingAnchor,
            padding: labelInsets
        )
        
        labelContainer.anchor(
            top: topAnchor,
            leading: nil,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: labelPadding
        )
        
        let maxMargin = Styles.MessageCell.maxMarginOnEmptySide
        labelContainer.leadingAnchor.constraint(
            greaterThanOrEqualTo: leadingAnchor, constant: maxMargin
        )
    }
 
    override func configureCell(with item: Any?) {
        guard let commentItem = item as? CommentItem else {
            return
        }
        
        contentLabel.text = commentItem.comment.content
    }
}




