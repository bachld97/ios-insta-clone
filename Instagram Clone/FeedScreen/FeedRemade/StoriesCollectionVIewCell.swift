import UIKit

class StoriesCollectionViewCell: CollectionViewCell {
    
    private let collectionView = StoriesCollectionViewController()
    
    override func prepareUI() {
        super.prepareUI()
        addSubview(collectionView.view)
    }
    
    override func configureCell(with item: Any?) {
        super.configureCell(with: item)
        guard let stories = item as? [StoryItem] else {
            return
        }
        
        collectionView.storiesDidLoad(stories)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.view.frame = self.bounds
    }
}


class StoriesCollectionViewController: BaseCollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.bounces = false
        self.collectionView?.showsHorizontalScrollIndicator = false
        flowLayout()?.scrollDirection = .horizontal
    }
    
    func storiesDidLoad(_ stories: [StoryItem]) {
        self.dataSource = StoryCollectionViewDataSource(objects: stories)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimen = view.frame.height
        let botPadding = StoryCollectionViewCell.padding.bottom
        return CGSize(
            width: dimen - StoryCollectionViewCell.nameHeight - botPadding,
            height: dimen
        )
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


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


class StoryCollectionViewDataSource: CollectionViewDataSource {
    override func cellClasses() -> [CollectionViewCell.Type] {
        return [StoryCollectionViewCell.self]
    }
}

class StoryItem {
    let story: Story
    
    init(_ story: Story) {
        self.story = story
    }
}
