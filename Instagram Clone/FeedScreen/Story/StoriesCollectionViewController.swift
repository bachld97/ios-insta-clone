import UIKit

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

