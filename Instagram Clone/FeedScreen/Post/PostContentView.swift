import UIKit

class PostContentView: UIView {

    weak var likeUnlikeDelegate: PostLikeUnlikeDelegate?
    weak var navigateCommentDelegate: PostNavigateCommentDelegate?
    weak var navigateShareDelegate: PostNavigateShareDelegate?
    
    var rebindClosure: (() -> ())?
    
    private let likedImage = UIImage.original(named: "heart_filled")
    private let notLikedImage = UIImage.original(named: "heart")
    
    private var likedByMe: Bool = false
    private var post: Post!
    
    static let buttonSize = CGSize(width: 36, height: 36)
    static let buttonPadding = UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 0)
    
    private let overlayHeartImageView = UIImageView()
    
    private lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageDoubleTap))
        gesture.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(notLikedImage, for: .normal)
        button.addTarget(self, action: #selector(likeOnClick), for: .touchUpInside)
        return button
    }()
    
    
    fileprivate func animateOverlayHeart() {
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
    
    fileprivate func setupOverlayHeart() {
        let overlaySize = CGSize(width: 72, height: 72)
        contentImageView.addSubview(overlayHeartImageView)
        overlayHeartImageView.image = likedImage
        overlayHeartImageView.centerInSuperview(size: overlaySize)
    }
    
    private func sendLike() {
        if !post.content.likedByMe {
            likeUnlikeDelegate?.postLiked(post.postId)
        }
        
        post.content.likedByMe = true
        likeButton.change(toImage: likedImage, animated: true)
        rebindClosure?()
    }
    
    private func sendUnlike() {
        if post.content.likedByMe {
            likeUnlikeDelegate?.postUnliked(post.postId)
        }
        
        post.content.likedByMe = false
        likeButton.change(toImage: notLikedImage, animated: true)
        rebindClosure?()
    }
    
    @objc private func imageDoubleTap() {
        sendLike()
        contentImageView.isUserInteractionEnabled = false
        setupOverlayHeart()
        animateOverlayHeart()
    }
    
    @objc private func likeOnClick() {
        if post.content.likedByMe {
            sendUnlike()
        } else {
            sendLike()
        }
    }
    
    private lazy var commentButton: UIButton = {
        let button = UIButton()
        button.setImage(.original(named: "comment"), for: .normal)
        button.addTarget(self, action: #selector(commentOnClick), for: .touchUpInside)
        return button
    }()
    
    @objc private func commentOnClick() {
        navigateCommentDelegate?.navigateComment(post.postId)
    }
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(.original(named: "forward"), for: .normal)
        button.addTarget(self, action: #selector(shareOnClick), for: .touchUpInside)
        return button
    }()
    
    @objc private func shareOnClick() {
        navigateShareDelegate?.navigateShare(post.postId)
    }

    fileprivate func setupConstraints() {
        contentImageView.anchor(
            top: topAnchor, leading: leadingAnchor,
            bottom: nil, trailing: trailingAnchor
        )
        
        likeButton.anchor(
            top: contentImageView.bottomAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: PostContentView.buttonPadding,
            size: PostContentView.buttonSize
        )
        
        commentButton.anchor(
            top: contentImageView.bottomAnchor,
            leading: likeButton.trailingAnchor,
            bottom: nil,
            trailing: nil,
            padding: PostContentView.buttonPadding,
            size: PostContentView.buttonSize
        )
        
        shareButton.anchor(
            top: contentImageView.bottomAnchor,
            leading: commentButton.trailingAnchor,
            bottom: nil,
            trailing: nil,
            padding: PostContentView.buttonPadding,
            size: PostContentView.buttonSize
        )
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [contentImageView, likeButton, commentButton, shareButton].forEach {
            addSubview($0)
        }
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with post: Post) {
        self.post = post
        if post.content.likedByMe {
            likeButton.change(toImage: likedImage, animated: false)
        } else {
            likeButton.change(toImage: notLikedImage, animated: false)
        }
        contentImageView.aspectRatio(widthToHeight: post.aspectRatio)
        contentImageView.image(fromUrl: post.content.imageUrl)
        contentImageView.backgroundColor = .lightGray
    }
}

extension PostContentView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        contentImageView.isUserInteractionEnabled = true
        self.overlayHeartImageView.removeFromSuperview()
    }
}
