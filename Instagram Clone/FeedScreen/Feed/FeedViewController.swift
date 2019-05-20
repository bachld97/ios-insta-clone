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
    private static var creatorRowHeight: CGFloat = 56
    private static var actionButtonRowHeight: CGFloat = 48
    
    static func heightForCell(_ item: PostItem?, cellWidth: CGFloat) -> CGFloat {
        guard let item = item else {
            return fixedHeight
        }
        
        let contentRowHeight = cellWidth * item.post.aspectRatio
        let captionRowHeight = heightForCaption(item, cellWidth)
        return contentRowHeight + captionRowHeight + fixedHeight
    }
    
    static private func heightForCaption(_ item: PostItem, _ cellWidth: CGFloat) -> CGFloat {
        let captionHeight = item.post.creator.name.toBold(
            withNonBold: item.post.content.caption,
            boldFont: Styles.FeedPostCell.captionCreatorFont,
            nonBoldFont: Styles.FeedPostCell.captionFont
        ).heightToDisplay(
                fixedWidth: cellWidth
        )
        
        let lineHeight = Styles.FeedPostCell.captionCreatorFont.lineHeight
        let numLines = Int(ceil(captionHeight / lineHeight))
        let maxLine = Styles.FeedPostCell.collapsedLabelMaxLine
        
        if numLines <= maxLine || item.isTextExpanded {
            return captionHeight
        } else {
            return lineHeight * CGFloat(maxLine)
        }
    }
    
    weak var delegate: PostEventDelegate?
    private let padding = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    private let filledHeart = UIImage.original(named: "heart_filled")
    private let emptyHeart = UIImage.original(named: "heart")
    
    private lazy var creatorRow: UIView = {
        let view = UIView()
        view.addViews(creatorImageView, creatorLabel, settingButton)

        creatorImageView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: nil,
            padding: .init(top: 8, left: 16, bottom: 8, right: 16)
        )
        creatorImageView.backgroundColor = .lightGray
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
    
    private lazy var creatorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private lazy var creatorLabel: UILabel = {
        let label = UILabel()
        label.font = Styles.FeedPostCell.creatorLabelFont
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
        view.addViews(likeButton, commentButton, shareButton)
        
        likeButton.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: nil
        )
        likeButton.aspectRatio(widthToHeight: 1)
        
        commentButton.anchor(
            top: view.topAnchor,
            leading: likeButton.trailingAnchor,
            bottom: view.bottomAnchor,
            trailing: nil
        )
        commentButton.aspectRatio(widthToHeight: 1)

        shareButton.anchor(
            top: view.topAnchor,
            leading: commentButton.trailingAnchor,
            bottom: view.bottomAnchor,
            trailing: nil
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
        button.setImage(UIImage.original(named: "comment"), for: .normal)
        button.addTarget(self, action: #selector(commentButtonOnTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.original(named: "forward"), for: .normal)
        button.addTarget(self, action: #selector(shareButtonOnTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeCountLabel: UILabel = {
        let label = VanishableLabel()
        label.font = Styles.FeedPostCell.likeCountFont
        return label
    }()
    
    private lazy var captionLabel: CaptionLabel = {
        let label = CaptionLabel(
            numberOfLinesWhenCollapsed: Styles.FeedPostCell.collapsedLabelMaxLine
        )
        label.captionFont = Styles.FeedPostCell.captionFont
        label.creatorNameFont = Styles.FeedPostCell.captionCreatorFont
        label.seeMoreFont = Styles.FeedPostCell.seeMoreFont
        label.seeMoreColor = Styles.FeedPostCell.seeMoreColor
        return label
    }()
    
    private lazy var timeAgoLabel: UILabel = {
        let label = UILabel()
        label.font = Styles.FeedPostCell.timeAgoFont
        return label
    }()
    
    private let overlayHeartImageView = UIImageView()
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        creatorImageView.layer.cornerRadius = creatorImageView.frame.size.width / 2
    }
    
    private func setupConstraints() {
        creatorRow.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .zero,
            size: .height(PostCollectionViewCell2.creatorRowHeight)
        )
        
        imageCarousel.anchor(
            top: creatorRow.bottomAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor
        )
        
        actionButtonRow.anchor(
            top: imageCarousel.bottomAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .zero,
            size: .height(PostCollectionViewCell2.actionButtonRowHeight)
        )
        
        likeCountLabel.anchor(
            top: actionButtonRow.bottomAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .left(16, right: 16),
            size: .init(width: 0, height: 12)
        )
        
        let captionPadding = UIEdgeInsets(
            top: 0, left: Styles.FeedPostCell.captionHorizontalPadding,
            bottom: 0, right: Styles.FeedPostCell.captionHorizontalPadding
        )
        captionLabel.anchor(
            top: likeCountLabel.bottomAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: captionPadding
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
        setupOverlayHeart()
        animateOverlayHeart()
        animateLikeButton(liked: true)
        delegate?.postEvent(.like, happeningOn: self)
    }
    
    private func setupOverlayHeart() {
        let overlaySize = CGSize(width: 72, height: 72)
        imageCarousel.addSubview(overlayHeartImageView)
        overlayHeartImageView.image = filledHeart
        overlayHeartImageView.centerInSuperview(size: overlaySize)
        imageCarousel.isUserInteractionEnabled = false
    }
    
    private func animateOverlayHeart() {
        let duration = 0.12
        
        let pulse1 = CABasicAnimation(keyPath: "transform.scale")
        let pulse2 = CABasicAnimation(keyPath: "transform.scale")
        let pulse3 = CABasicAnimation(keyPath: "transform.scale")
        let shrink = CABasicAnimation(keyPath: "transform.scale")
        
        pulse1.duration = duration
        pulse2.duration = duration
        pulse3.duration = duration
        
        pulse2.beginTime = duration
        pulse3.beginTime = duration * 2
        
        pulse1.fromValue = 1
        pulse1.toValue = 1.25
        
        pulse2.fromValue = 1.25
        pulse2.toValue = 1
        
        pulse3.fromValue = 1
        pulse3.toValue = 1.1
        
        shrink.duration = duration
        shrink.beginTime = duration * 3
        shrink.fromValue = 1.1
        shrink.toValue = 0
        
        let group = CAAnimationGroup()
        group.duration = duration * 4
        group.animations = [pulse1, pulse2, pulse3, shrink]
        group.delegate = self
        
        overlayHeartImageView.layer.setAffineTransform(.init(scaleX: 0, y: 0))
        overlayHeartImageView.layer.add(group, forKey: nil)
    }
    
    private func animateLikeButton(liked: Bool) {
        if liked {
            likeButton.change(toImage: filledHeart, animated: true)
        } else {
            likeButton.change(toImage: emptyHeart, animated: true)
        }
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
            likeCountLabel.text = postItem.likeText
            timeAgoLabel.text = postItem.timeAgoText
            
            if postItem.post.content.likedByMe {
                likeButton.setImage(filledHeart, for: .normal)
            } else {
                likeButton.setImage(emptyHeart, for: .normal)
            }
            
            imageCarousel.images = postItem.post.content.images
            imageCarousel.selectedImage = postItem.selectedImage
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

extension PostCollectionViewCell2: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        imageCarousel.isUserInteractionEnabled = true
        self.overlayHeartImageView.removeFromSuperview()
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

struct Image {
    let url: String
}

class CaptionLabel: UILabel {
    var creatorNameFont = UIFont.boldSystemFont(ofSize: 12)
    var captionFont = UIFont.systemFont(ofSize: 12)
    var seeMoreFont = UIFont.systemFont(ofSize: 12)
    var seeMoreColor = UIColor.black
    var seeMorePrefix: String
    var seeMoreText: String
    var numberOfLinesWhenCollapsed: Int
    
    var currentCaption: String = ""
    var currentCreatorName: String = ""
    
    init(numberOfLinesWhenCollapsed: Int = 2,
         seeMorePrefix: String = "… ",
         seeMoreText: String = "more") {
        self.numberOfLinesWhenCollapsed = numberOfLinesWhenCollapsed
        self.seeMorePrefix = seeMorePrefix
        self.seeMoreText = seeMoreText
        super.init(frame: .zero)
        numberOfLines = numberOfLinesWhenCollapsed
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func expand() {
        setCaption(currentCaption, creatorName: currentCreatorName, collapseText: false)
    }
    
    func collapse() {
        setCaption(currentCaption, creatorName: currentCreatorName, collapseText: true)
    }
    
    func setCaption(_ caption: String, creatorName: String, collapseText: Bool) {
        self.currentCaption = caption
        self.currentCreatorName = creatorName
        
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
    
    let clientUsingAutoLayout: Bool
    
    init(clientUsingAutoLayout: Bool = true) {
        self.clientUsingAutoLayout = clientUsingAutoLayout
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}