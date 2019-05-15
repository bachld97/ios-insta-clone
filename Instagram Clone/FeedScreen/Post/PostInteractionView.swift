import UIKit

class PostInteractionView: UIView {
    
    private lazy var likeCountLabel: UILabel = {
        let l = UILabel()
        l.font = PostInteractionView.likeCountFont
        return l
    }()
    
    private lazy var captionLabel: UILabel = {
        let l = UILabel()
        l.font = PostInteractionView.captionFont
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        return l
    }()
    
    private lazy var timestampLabel: UILabel = {
       let l = UILabel()
        l.font = PostInteractionView.timestampFont
        l.textColor = .lightGray
        return l
    }()

    static let textHorizontalPadding: CGFloat = 16
    
    static let likeCountFont = UIFont.systemFont(ofSize: 13)
    static let captionFont = UIFont.systemFont(ofSize: 12)
    static let captionBoldFont = UIFont.boldSystemFont(ofSize: 12)
    static let timestampFont = UIFont.systemFont(ofSize: 12)

    
    static func heightFor(_ item: PostItem, cellWidth: CGFloat) -> CGFloat {
        let fixedPortion: CGFloat = 32
        let width = cellWidth - 2 * PostInteractionView.textHorizontalPadding
        
        let captionHeight = item.post.creator.name.toBold(
            withNonBold: item.post.content.caption,
            boldFont: PostInteractionView.captionBoldFont,
            nonBoldFont: PostInteractionView.captionFont
        ).heightToDisplay(
            fixedWidth: width
        )
        
        let lineHeight = PostInteractionView.captionBoldFont.lineHeight
        let numLines = captionHeight / lineHeight
        
        let timeHeight = item.timeAgoText.heightToDisplay(
            fixedWidth: width,
            font:  PostInteractionView.timestampFont
        )
        
        if numLines <= 2 || item.isTextExpanded {
            return fixedPortion + timeHeight + captionHeight
        } else {
            return fixedPortion + timeHeight + lineHeight * 2
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [likeCountLabel, captionLabel, timestampLabel].forEach { addSubview($0) }
        setupConstraints()
    }
    
    private func setupConstraints() {
        let pad = PostInteractionView.textHorizontalPadding
        
        likeCountLabel.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .init(top: 0, left: pad, bottom: 0, right: pad),
            size: .init(width: 0, height: 12)
        )
        
        captionLabel.anchor(
            top: likeCountLabel.bottomAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .init(top: 4, left: pad, bottom: 0, right: pad)
        )
        
        timestampLabel.anchor(
            top: captionLabel.bottomAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .init(top: 8, left: pad, bottom: 0, right: pad)
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with postItem: PostItem) {
        
        if postItem.isTextExpanded {
            captionLabel.numberOfLines = 0
        } else {
            captionLabel.numberOfLines = 2
        }
        
        let post = postItem.post
        captionLabel.textFrom(
            bold: post.creator.name,
            nonBold: post.content.caption,
            boldFont: PostInteractionView.captionBoldFont,
            nonBoldFont: PostInteractionView.captionFont
        )
        
        if captionLabel.isTextTruncated() {
            let color = UIColor.from(r: 0.7, g: 0.7, b: 0.7)
            let f = PostInteractionView.captionFont
            captionLabel.addTrailing(with: "… ", moreText: "more",
                                     moreTextFont: f, moreTextColor: color)
        }
        
        likeCountLabel.text = postItem.likeText
        timestampLabel.text = postItem.timeAgoText
        
    }
}
