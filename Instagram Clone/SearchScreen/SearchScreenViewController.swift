import UIKit

class SearchScreenViewController: BaseViewController {

    private let user: User
    
    init(viewingAs user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchResultViewController = SearchResultViewController(viewingAs: user)
        addSubViewController(searchResultViewController)
    }
    
}

class SearchResultViewController: BaseCollectionViewController, SearchResultCollectionLayoutDelegate {
    func heightForItem(at indexPath: IndexPath) -> CGFloat {
        let lookUpHeight: [CGFloat] = [60, 40, 45, 50, 110]
        return lookUpHeight[indexPath.item % 5]
    }
    
    private let fetchSearchResult: FetchSearchResultUseCase
    private let user: User
    
    private let layout = SearchResultCollectionLayout()
    
    init(viewingAs user: User, fetchSearchResult: FetchSearchResultUseCase = .init()) {
        self.user = user
        self.fetchSearchResult = fetchSearchResult
        super.init(layout: layout)
        layout.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSearchResult.execute((user, ""), completion: temp(_:))
    }
    
    private func searchResultsFetched(_ searchResults: [SearchResult]) {
        self.dataSource = SearchResultCollectionViewDataSource(objects: searchResults)
    }
    
    private func temp(_ ints: [Int]) {
        self.dataSource = SearchResultCollectionViewDataSource(objects: ints)
    }
}

class SearchResultCollectionViewDataSource: CollectionViewDataSource {
    override func cellClasses() -> [CollectionViewCell.Type] {
        return [SearchResultCollectionViewCell.self]
    }
}

class SearchResultCollectionViewCell: CollectionViewCell {
    private let label = UILabel()
    
    override func prepareUI() {
        super.prepareUI()
        addSubview(label)
        label.centerInSuperview()
        lineDivider.invisible()
        backgroundColor = .red
    }
    
    override func configureCell(with item: Any?) {
        guard let num = item as? Int else {
            return
        }
        
        label.text = "\(num)"
    }
}


class FetchSearchResultUseCase: UseCase {
    func execute(
        _ request: (User, String), completion: @escaping ([Int]) -> Void) {
     
//        let longText = ""
//        let mediumText = ""
//        let shortText = ""
//
//        let sr1 = SearchResult(content: longText)
//        let sr2 = SearchResult(content: shortText)
//        let sr3 = SearchResult(content: mediumText)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            completion([
//                sr1, sr2, sr3, sr1, sr2, sr3, sr1, sr2, sr3, sr1, sr2, sr3,
//                 sr1, sr2, sr3, sr1, sr2, sr3, sr1, sr2, sr3, sr1, sr2, sr3
//            ].shuffled())
            completion(Array(0...1000))
        }
    }
    
    typealias Request = (User, String)
    typealias Response = [Int]
}

struct SearchResult {
    let content: String
}

protocol SearchResultCollectionLayoutDelegate: class {
    func heightForItem(at indexPath: IndexPath) -> CGFloat
}


class SearchResultCollectionLayout: UICollectionViewLayout {
    private var cache = [UICollectionViewLayoutAttributes]()
    
    weak var delegate: SearchResultCollectionLayoutDelegate?
    
    let numberOfColumns = 3
    
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        
        let insets = collectionView.contentInset
        return collectionView.bounds.width - insets.left - insets.right
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        cache.removeAll()
        cache = calculatePositions()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        visibleLayoutAttributes.append(contentsOf: cache.filter {
            return $0.frame.intersects(rect)
        })
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(
        at indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        if cache.isEmpty || indexPath.item > cache.count {
            cache = calculatePositions()
        }
        return cache[indexPath.item]
    }
    
    private func calculatePositions() -> [UICollectionViewLayoutAttributes] {
        guard let collectionView = collectionView,
            let delegate = delegate else {
            return []
        }
        
        var result = [UICollectionViewLayoutAttributes]()
        
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        
        let smallWidth = (collectionView.frame.width - 12) / 3
        let largeWidth = smallWidth * 2
        
        var yOffset: CGFloat = 0
        
        // Calculate for the first 5 * k items (k = number of items // 5)
        for group in 0..<numberOfItems / 5 {
            let ip1 = IndexPath(row: group * 5 + 0, section: 0)
            let ip2 = IndexPath(row: group * 5 + 1, section: 0)
            let h12 = max(delegate.heightForItem(at: ip1), delegate.heightForItem(at: ip2))
            let f1 = CGRect(x: 4, y: yOffset + 4, width: largeWidth, height: h12)
            let f2 = CGRect(x: largeWidth + 8, y: yOffset + 4, width: smallWidth, height: h12)
            let at1 = UICollectionViewLayoutAttributes(forCellWith: ip1)
            at1.frame = f1
            let at2 = UICollectionViewLayoutAttributes(forCellWith: ip2)
            at2.frame = f2
            
            yOffset += h12 + 4

            let ip3 = IndexPath(row: group * 5 + 2, section: 0)
            let ip4 = IndexPath(row: group * 5 + 3, section: 0)
            let ip5 = IndexPath(row: group * 5 + 4, section: 0)
            
            let h3 = delegate.heightForItem(at: ip3)
            let h4 = delegate.heightForItem(at: ip4)
            let h345 = 4 + max(
                h3 + h4, delegate.heightForItem(at: ip5)
            )
            let f3 = CGRect(x: 4, y: yOffset + 4, width: smallWidth, height: h3)
            let f4 = CGRect(x: 4, y: yOffset + h3 + 8, width: smallWidth, height: h345 - h3 - 4)
            let f5 = CGRect(x: smallWidth + 8, y: yOffset + 4, width: largeWidth, height: h345)
            let at3 = UICollectionViewLayoutAttributes(forCellWith: ip3)
            at3.frame = f3
            let at4 = UICollectionViewLayoutAttributes(forCellWith: ip4)
            at4.frame = f4
            let at5 = UICollectionViewLayoutAttributes(forCellWith: ip5)
            at5.frame = f5
            
            yOffset += h345
            yOffset += 4
            result.append(contentsOf: [at1, at2, at3, at4, at5])
        }

        contentHeight = max(contentHeight, result.last?.frame.maxY ?? 0)
        // Calculate for the last (number of items % 5) items
        
        
        return result
    }
}


