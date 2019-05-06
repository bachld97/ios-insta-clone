import UIKit

class StoryViewController: UICollectionViewController {
    typealias StoryCollectionCell = CollectionViewItem<StoryCell, Story>

    private let storyContentDimen: CGFloat = 64
    var collectiveHeight: CGFloat {
        return storyContentDimen + 24
    }
    
    private let fetchStories: FetchStoriesUseCase
    private let loggedInUser: User
    private let layout = UICollectionViewFlowLayout()
    
    private var stories = [CellConfigurator]()
    
    init(viewingAs user: User, _ fetchStories: FetchStoriesUseCase = .init()) {
        loggedInUser = user
        self.fetchStories = fetchStories
        self.layout.scrollDirection = .horizontal
        self.layout.minimumInteritemSpacing = 0
        self.layout.minimumLineSpacing = 0
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStories.execute(loggedInUser, completion: storiesDidLoad(_:))
        
        layout.itemSize = CGSize(width: storyContentDimen, height: collectiveHeight)
        
        self.collectionView?.bounces = false
        self.collectionView?.backgroundColor = .white
        self.collectionView?.register(StoryCell.self, forCellWithReuseIdentifier:
            StoryCollectionCell.reuseId)
        self.collectionView?.showsHorizontalScrollIndicator = false
    }
    
    private func storiesDidLoad(_ stories: [Story]) {
        self.stories = stories.map { return StoryCollectionCell(item: $0) }
        collectionView.reloadData()
    }
    
    override func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let item = stories[indexPath.row]
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: type(of: item).reuseId, for: indexPath)
        item.configure(cell: cell)
        return cell
    }
    
    override func collectionView(
        _ collectionView: UICollectionView, numberOfItemsInSection section: Int
    ) -> Int {
        return stories.count
    }
}
