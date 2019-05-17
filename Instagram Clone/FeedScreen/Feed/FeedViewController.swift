import UIKit

class DefaultCollectionHeader: DefaultCollectionViewCell {
    override func prepareUI() {
        super.prepareUI()
        label.text = "Header"
        label.textAlignment = .center
    }
    
    override func configureCell(with item: Any?) {
        guard let item = item else {
            label.text = "Header"
            return
        }
        label.text = "\(item)"
    }
}

class DefaultCollectionFooter: DefaultCollectionViewCell {
    override func prepareUI() {
        super.prepareUI()
        label.text = "Footer"
        label.textAlignment = .center
    }
    
    override func configureCell(with item: Any?) {
        guard let item = item else {
            label.text = "Footer"
            return
        }
        label.text = "\(item)"
    }
}

class PostCollectionViewCell2: CollectionViewCell {
    
    private static var fixedHeight = creatorRowHeight + actionButtonRowHeight
    private static var creatorRowHeight: CGFloat = 48
    private static var actionButtonRowHeight: CGFloat = 48
    
    static func heightForCell(_ item: PostItem?, cellWidth: CGFloat) -> CGFloat {
        guard let item = item else {
            return fixedHeight
        }
        
        let contentRowHeight = cellWidth * item.post.aspectRatio
        let captionRowHeight = heightForCaptionRow(item, cellWidth)
        return contentRowHeight + captionRowHeight + fixedHeight
    }
    
    static func heightForCaptionRow(_ item: PostItem, _ cellWidth: CGFloat) -> CGFloat {
        return 0
    }
    
    weak var delegate: PostEventDelegate?
    private let padding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    private let filledHeart = UIImage(named: "heart_filled")
    private let emptyHeart = UIImage(named: "heart")
    
    private lazy var creatorRow: UIView = {
        let view = UIView()
        view.addViews(creatorImageView, creatorLabel, settingButton)

        creatorImageView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: nil
        )
        creatorImageView.backgroundColor = .yellow
        creatorImageView.aspectRatio(widthToHeight: 1)
        
        creatorLabel.anchor(
            top: view.topAnchor,
            leading: creatorImageView.trailingAnchor,
            bottom: view.bottomAnchor,
            trailing: settingButton.leadingAnchor,
            padding: .left(16, right: 16)
        )
        
        settingButton.anchor(
            top: view.topAnchor,
            leading: nil,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor
        )
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(creatorRowOnTap))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    private lazy var creatorImageView = UIImageView()
    
    private lazy var creatorLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var settingButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(settingButtonOnTap), for: .touchUpInside)
        button.invisible()
        return button
    }()
    
    private lazy var imageCarousel: ImageCarousel = {
        let carousel = ImageCarousel()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageOnDoubleTap))
        gesture.numberOfTapsRequired = 2
        carousel.addGestureRecognizer(gesture)
        carousel.isUserInteractionEnabled = true
        return carousel
    }()
    
    private lazy var actionButtonRow: UIView = {
        let view = UIView()
        let buttonPadding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        view.addViews(likeButton, commentButton, shareButton)
        
        likeButton.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: nil,
            padding: .left(0, right: 8)
        )
        likeButton.aspectRatio(widthToHeight: 1)
        
        commentButton.anchor(
            top: view.topAnchor,
            leading: likeButton.trailingAnchor,
            bottom: view.bottomAnchor,
            trailing: nil,
            padding: buttonPadding
        )
        commentButton.aspectRatio(widthToHeight: 1)

        shareButton.anchor(
            top: view.topAnchor,
            leading: commentButton.trailingAnchor,
            bottom: view.bottomAnchor,
            trailing: nil,
            padding: buttonPadding
        )
        shareButton.aspectRatio(widthToHeight: 1)
        
        return view
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(likeButtonOnTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.addTarget(self, action: #selector(commentButtonOnTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "forward"), for: .normal)
        button.addTarget(self, action: #selector(shareButtonOnTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeCountLabel: UILabel = {
        let label = VanishableLabel()
        return label
    }()
    
    private lazy var captionLabel: CaptionLabel = {
        return CaptionLabel()
    }()
    
    private lazy var timeAgoLabel: UILabel = {
        return UILabel()
    }()
    
    override var viewController: BaseCollectionViewController? {
        didSet {
            if let delegate = viewController as? PostEventDelegate {
                self.delegate = delegate
            }
        }
    }
    
    override func prepareUI() {
        super.prepareUI()
        lineDivider.invisible()
        addViews(
            creatorRow, imageCarousel, actionButtonRow,
            likeCountLabel, captionLabel, timeAgoLabel
        )
        setupConstraints()
    }
    
    private func setupConstraints() {
        creatorRow.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: padding,
            size: .height(PostCollectionViewCell2.creatorRowHeight)
        )
        
        imageCarousel.anchor(
            top: creatorRow.bottomAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .zero
        )
        
        actionButtonRow.anchor(
            top: imageCarousel.bottomAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: padding,
            size: .height(PostCollectionViewCell2.actionButtonRowHeight)
        )
        
        likeCountLabel.anchor(
            top: actionButtonRow.bottomAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: padding,
            size: .init(width: 0, height: 12)
        )
        
        captionLabel.anchor(
            top: likeCountLabel.bottomAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: padding
        )
        
        timeAgoLabel.anchor(
            top: captionLabel.bottomAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: padding
        )
    }
    
    @objc private func imageOnDoubleTap() {
        animateOverlayHeart()
        animateLikeButton(liked: true)
        delegate?.postEvent(.like, happeningOn: self)
    }
    
    private func animateOverlayHeart() {
        
    }
    
    private func animateLikeButton(liked: Bool) {
        
    }
    
    @objc private func captionOnTap(gesture: UITapGestureRecognizer) {
        delegate?.postEvent(.expandCaption, happeningOn: self)
    }
    
    @objc private func likeButtonOnTap() {
        if let liked = (item as? PostItem)?.post.content.likedByMe {
            animateLikeButton(liked: !liked)
        } else {
            animateLikeButton(liked: true)
        }
        delegate?.postEvent(.likeToggle, happeningOn: self)
    }
    
    @objc private func commentButtonOnTap() {
        delegate?.postEvent(.navigateComment, happeningOn: self)
    }
    
    @objc private func shareButtonOnTap() {
        delegate?.postEvent(.navigateShare, happeningOn: self)
    }
    
    @objc private func creatorRowOnTap() {
        delegate?.postEvent(.navigateCreator, happeningOn: self)
    }
    
    @objc private func settingButtonOnTap() {
        print("Setting on tap")
    }
    
    override func configureCell(with item: Any?) {
        func bindCreator(_ postItem: PostItem) {
            creatorLabel.text = postItem.post.creator.name
        }
        
        func bindContent(_ postItem: PostItem) {
            imageCarousel.images = postItem.post.content.images
            likeCountLabel.text = postItem.likeText
            timeAgoLabel.text = postItem.timeAgoText
            
            if postItem.post.content.likedByMe {
                likeButton.setImage(filledHeart, for: .normal)
            } else {
                likeButton.setImage(emptyHeart, for: .normal)
            }
        }
        
        func bindCaption(_ postItem: PostItem) {
            captionLabel.setCaption(
                postItem.post.content.caption,
                creatorName: postItem.post.creator.name,
                collapseText: !postItem.isTextExpanded
            )
        }
        
        guard let item = item as? PostItem else {
            return
        }
        
        bindCreator(item)
        bindContent(item)
        bindCaption(item)
    }
}

protocol PostEventDelegate: class {
    func postEvent(_ event: PostEvent, happeningOn cell: CollectionViewCell)
}

enum PostEvent {
    case expandCaption
    case like
    case likeToggle
    case navigateComment
    case navigateShare
    case navigateCreator
}

class ImageCarousel: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
    }
    
    init(indicator: Indicator = .none) {
        self.indicator = indicator
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var indicator: Indicator = .none
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        return imageView
    }()
    
    var images: [Image] = [] {
        didSet {
            selectedImage = 0
        }
    }
    
    private var selectedImage: Int = 0 {
        didSet {
            if images.isEmpty {
                return
            }
            
            precondition(selectedImage >= 0)
            precondition(selectedImage < self.images.count)
            self.imageView.image(fromUrl: images[selectedImage].url)
        }
    }
    
    enum Indicator {
        case none
        case dot
        case slide
    }
}

struct Image {
    let url: String
}

class CaptionLabel: UILabel {
    var creatorNameFont = UIFont.boldSystemFont(ofSize: 12)
    var captionFont = UIFont.systemFont(ofSize: 12)

    var seeMoreFont = UIFont.systemFont(ofSize: 12)
    var seeMoreColor = UIColor.black
    var seeMorePrefix: String = ""
    var seeMoreText: String = ""
    
    var numberOfLinesWhenCollapsed: Int
    
    init(numberOfLinesWhenCollapsed: Int = 2) {
        self.numberOfLinesWhenCollapsed = numberOfLinesWhenCollapsed
        super.init(frame: .zero)
        numberOfLines = numberOfLinesWhenCollapsed
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCaption(_ caption: String, creatorName: String, collapseText: Bool) {
        self.textFrom(
            bold: creatorName, nonBold: caption,
            boldFont: creatorNameFont, nonBoldFont: captionFont
        )
        
        if collapseText {
            numberOfLines = numberOfLinesWhenCollapsed
            if isTextTruncated() {
                appendSeeMore(
                    prefix: seeMorePrefix, text: seeMoreText,
                    seeMoreFont: seeMoreFont, seeMoreColor: seeMoreColor
                )
            }
        } else {
            numberOfLines = 0
        }
    }
}

class VanishableLabel: UILabel {

}
