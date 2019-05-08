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
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(avaImageView)
        addSubview(creatorNameLabel)
        addSubview(settingButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with post: Post) {
        creatorNameLabel.text = post.creator.name
    }
 
    override var frame: CGRect {
        didSet {
            let padding: CGFloat = 8.0
            avaImageView.frame = CGRect(
                x: padding,
                y: padding,
                width: frame.height - 2 * padding,
                height: frame.height - 2 * padding
            )
            avaImageView.layer.cornerRadius = avaImageView.frame.width / 2
            
            creatorNameLabel.frame = CGRect(
                x: avaImageView.frame.maxX + padding,
                y: padding,
                width: frame.width - padding * 2,
                height: frame.height - 2 * padding
            )
            
            settingButton.frame = CGRect(
                x: frame.width - padding - 32,
                y: (frame.height - 32) / 2,
                width: 32,
                height: 32
            )
        }
    }
}
