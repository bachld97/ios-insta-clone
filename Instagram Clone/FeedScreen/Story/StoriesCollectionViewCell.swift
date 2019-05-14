import UIKit

class StoriesCollectionViewCell: CollectionViewCell {
    
    private let collectionView = StoriesCollectionViewController()
    
    override func prepareUI() {
        super.prepareUI()
        addSubview(collectionView.view)
    }
    
    override func configureCell(with item: Any?) {
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
