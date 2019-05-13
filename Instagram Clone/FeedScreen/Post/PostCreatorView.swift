import UIKit

class PostCreatorView: UIView {
    private lazy var avaImageView: UIImageView = {
        let v = UIImageView()
        v.backgroundColor = UIColor.lightGray
        return v
    }()
    
    private lazy var creatorNameLabel: UILabel = {
        let v = UILabel()
        v.font = UIFont.boldSystemFont(ofSize: 12.0)
        return v
    }()
    
    private lazy var settingButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .lightGray
        b.invisible()
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(avaImageView)
        addSubview(creatorNameLabel)
        addSubview(settingButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        let padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        avaImageView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: nil,
            padding: padding
        )
        avaImageView.aspectRatio(widthToHeight: 1)
        
        settingButton.anchor(
            top: topAnchor,
            leading: nil,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: padding
        )
        settingButton.aspectRatio(widthToHeight: 1)
        
        creatorNameLabel.anchor(
            top: topAnchor,
            leading: avaImageView.trailingAnchor,
            bottom: bottomAnchor,
            trailing: settingButton.leadingAnchor,
            padding: padding
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with post: Post) {
        creatorNameLabel.text = post.creator.name
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avaImageView.layer.cornerRadius = avaImageView.frame.size.width / 2
    }
}
