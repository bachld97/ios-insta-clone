import UIKit

class YourStoryCell: UICollectionViewCell, ConfigurableCell {
    
    private lazy var userLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var storyImage: UIImageView = {
        let v = UIImageView()
        v.clipsToBounds = true
        v.backgroundColor = UIColor.lightGray
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(userLabel)
        addSubview(storyImage)
    }
    
    override var frame: CGRect {
        didSet {
            let padding: CGFloat = 10.0
            let imageDimen = frame.width - 2 * padding
            
            storyImage.frame = CGRect(
                x: padding, y: padding,
                width: imageDimen, height: imageDimen)
            storyImage.layer.cornerRadius = 0.5 * storyImage.frame.width
            
            let uY: CGFloat = storyImage.frame.maxY + padding
            userLabel.frame = CGRect(
                x: padding, y: uY,
                width: imageDimen, height: frame.height - uY - padding)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    typealias Item = User
    
    func configure(item: User) {
        userLabel.text = "Your story"
        storyImage.image = UIImage(named: item.name)
        
    }
}
