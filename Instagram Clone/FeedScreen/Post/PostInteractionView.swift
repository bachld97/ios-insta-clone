import UIKit

protocol PostExtendCaptionDelegate: class {
    func extendCaptionForCell()
}


class PostInteractionView: UIView {
    
    weak var delegate: PostExtendCaptionDelegate?
    
    private lazy var likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = PostInteractionView.likeCountFont
        return label
    }()
    
    private lazy var captionLabel: UILabel = {
        let label = UILabel()
        label.font = PostInteractionView.captionFont
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        let gesture = UITapGestureRecognizer(
            target: self, action: #selector(captionOnTap)
        )
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        label.addGestureRecognizer(gesture)
        label.isUserInteractionEnabled = true
        
        return label
    }()

    @objc private func captionOnTap(tap: UITapGestureRecognizer) {
//        guard let text = captionLabel.text else {
//            return
//        }
        
        let userRange = NSRange(location: 0, length: postItem.post.creator.name.count)
        
        if tap.didTapAttributedTextInLabel(label: captionLabel, inRange: userRange) {
            print("To user page")
        } else {
            postItem.isTextExpanded = true
            delegate?.extendCaptionForCell()
        }
    }
    
    private lazy var timestampLabel: UILabel = {
       let label = UILabel()
        label.font = PostInteractionView.timestampFont
        label.textColor = .lightGray
        return label
    }()

    static let textHorizontalPadding: CGFloat = 16
    
    static let likeCountFont = UIFont.systemFont(ofSize: 13)
    static let captionFont = UIFont.systemFont(ofSize: 12)
    static let captionBoldFont = UIFont.boldSystemFont(ofSize: 12)
    static let timestampFont = UIFont.systemFont(ofSize: 12)

    private var postItem: PostItem!
    
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
        [likeCountLabel, timestampLabel, captionLabel].forEach { addSubview($0) }
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
        self.postItem = postItem
        
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
        
        if captionLabel.isTextTruncated() && !postItem.isTextExpanded {
            let color = UIColor.from(r: 0.7, g: 0.7, b: 0.7)
            let f = PostInteractionView.captionFont
            
            captionLabel.appendSeeMore(
                prefix: "… ", text: "more",
                seeMoreFont: f, seeMoreColor: color
            )
        }
        
        likeCountLabel.text = postItem.likeText
        timestampLabel.text = postItem.timeAgoText
    }
}
