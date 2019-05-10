import UIKit

class PostContentView: UIView {

    private let likedImage = UIImage.original(named: "heart_filled")
    private let notLikedImage = UIImage.original(named: "heart")
    
    private var likedByMe: Bool = false
    
    static let buttonSize = CGSize(width: 36, height: 36)
    static let buttonPadding = UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 0)
    
    private let overlayHeartImageView = UIImageView()
    
    private lazy var contentImageView: UIImageView = {
        let imageView = UIImageView()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageDoubleTap))
        gesture.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(notLikedImage, for: .normal)
        button.addTarget(self, action: #selector(likeOnClick), for: .touchUpInside)
        return button
    }()
    
    
    @objc private func imageDoubleTap() {
        contentImageView.isUserInteractionEnabled = false
        likedByMe = true
        likeButton.change(toImage: likedImage, animated: true)
        
        let overlaySize = CGSize(width: 72, height: 72)
        contentImageView.addSubview(overlayHeartImageView)

        overlayHeartImageView.image = likedImage
        overlayHeartImageView.centerInSuperview(size: overlaySize)
        
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

        overlayHeartImageView.layer.add(group, forKey: nil)
    }
    
    @objc private func likeOnClick() {
        likedByMe = !likedByMe
        if likedByMe {
            likeButton.change(toImage: likedImage, animated: true)
        } else {
            likeButton.change(toImage: notLikedImage, animated: true)
        }
    }
    
    private lazy var commentButton: UIButton = {
        let button = UIButton()
        button.setImage(.original(named: "comment"), for: .normal)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(.original(named: "forward"), for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        likedByMe = false
        super.init(frame: frame)
        [contentImageView, likeButton, commentButton, shareButton].forEach {
            addSubview($0)
        }
        
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with post: Post) {
        likedByMe = post.content.likedByMe
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
        overlayHeartImageView.removeFromSuperview()
    }

}
