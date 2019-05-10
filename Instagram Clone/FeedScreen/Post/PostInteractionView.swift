import UIKit

class PostInteractionView: UIView {
    
    private lazy var likeCountLabel: UILabel = {
        let l = UILabel()
        l.font = .boldSystemFont(ofSize: 13)
        return l
    }()
    
    private lazy var captionLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12)
        l.numberOfLines = 2
        return l
    }()
    
    private lazy var timestampLabel: UILabel = {
       let l = UILabel()
        l.font = .systemFont(ofSize: 12)
        l.textColor = .lightGray
        return l
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [likeCountLabel, captionLabel, timestampLabel].forEach { addSubview($0) }
        setupConstraints()
    }
    
    private func setupConstraints() {
        likeCountLabel.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: 0, right: 0),
            size: .init(width: 0, height: 12)
        )
        
        captionLabel.anchor(
            top: likeCountLabel.bottomAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .init(top: 4, left: 16, bottom: 0, right: 0)
        )
        
        timestampLabel.anchor(
            top: captionLabel.bottomAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .init(top: 8, left: 16, bottom: 0, right: 0)
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with post: Post) {
        captionLabel.textFrom(
            bold: "\(post.creator.name)",
            nonBold: "\(post.content.caption)"
        )
        likeCountLabel.text = "\(post.content.likeCount) likes"
        timestampLabel.text = "10 years ago"
    }
}
