import UIKit

class StoryCollectionViewCell: CollectionViewCell {
    
    static let nameHeight: CGFloat = 16
    static let padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    private lazy var avaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    private lazy var creatorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .center
        return label
    }()
    
    override func prepareUI() {
        super.prepareUI()
        addSubview(avaImageView)
        addSubview(creatorNameLabel)
        lineDivider.invisible()
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avaImageView.layer.cornerRadius = avaImageView.frame.size.width / 2
    }
    
    private func setupConstraints() {
        creatorNameLabel.anchor(
            top: nil, leading: leadingAnchor,
            bottom: bottomAnchor, trailing: trailingAnchor,
            padding: StoryCollectionViewCell.padding,
            size: .height(StoryCollectionViewCell.nameHeight)
        )
        
        avaImageView.anchor(
            top: topAnchor, leading: leadingAnchor,
            bottom: creatorNameLabel.topAnchor, trailing: trailingAnchor,
            padding: StoryCollectionViewCell.padding
        )
    }
    
    override func configureCell(with item: Any?) {
        guard let item = item as? StoryItem else {
            return
        }
        
        creatorNameLabel.text = item.story.user.name
        //        avaImageView.image = UIImage(named: item.story.content)
    }
}
