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

class SearchResultCollectionViewCell: CollectionViewCell {
    static var labelFont = UIFont.systemFont(ofSize: 15)
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = SearchResultCollectionViewCell.labelFont
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override func prepareUI() {
        super.prepareUI()
        addSubview(label)
        lineDivider.invisible()
        backgroundColor = .red
        
        label.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 4, left: 4, bottom: 4, right: 4)
        )
    }
    
    override func configureCell(with item: Any?) {
        guard let sr = item as? SearchResultItem else {
            return
        }
        label.text = sr.searchResult.content
    }
}

class SearchResultViewController: BaseCollectionViewController, SearchResultCollectionLayoutDelegate {
    func heightForItem(at indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        
        let w = cellWidth - 8 // padding left right
        guard let item = dataSource?.item(at: indexPath) as? SearchResultItem else {
            return w
        }

        if item.cachedHeight != -1 {
            return item.cachedHeight
        }
        
        let font = SearchResultCollectionViewCell.labelFont
        let h = item.searchResult.content.heightToDisplay(fixedWidth: w, font: font) + 16 // padding top bot
        item.cachedHeight = h
        return h
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
        fetchSearchResult.execute((user, ""), completion: searchResultsFetched(_:))
    }
    
    private func searchResultsFetched(_ searchResults: [SearchResult]) {
        let items = searchResults.map { return SearchResultItem($0) }
        self.dataSource = SearchResultCollectionViewDataSource(objects: items)
    }
}

class SearchResultCollectionViewDataSource: CollectionViewDataSource {
    override func cellClasses() -> [CollectionViewCell.Type] {
        return [SearchResultCollectionViewCell.self]
    }
}



class FetchSearchResultUseCase: UseCase {
    func execute(
        _ request: (User, String), completion: @escaping ([SearchResult]) -> Void) {
     
//        let t1 = "1. Kinda long text but it is okay. I think this text is longer than the second text already. No need to have more text. Bye now baby."
//        let t2 = "2. Hello world, I am a short (kind of) text."
//        let t3 = "3. Kinda long text but it is okay. I think this text is longer than the second text already. No need to have more text. Bye now baby."
//        let t4 = "4. Kinda long text but it is okay. I think this text is longer than the second text already. No need to have more text. Bye now baby."
//        let t5 = "5. Kinda long text but it is okay. I think this text is longer than the second text already. No need to have more text. Bye now baby. Kinda long text but it is okay. I think this text is longer than the second text already. No need to have more text. Bye now baby. Kinda long text but it is okay. I think this text is longer than the second text already. No need to have more text. Bye now baby. Kinda long text but it is okay. I think this text is longer than the second text already. No need to have more text. Bye now baby."
//
//        let sr1 = SearchResult(content: t1)
//        let sr2 = SearchResult(content: t2)
//        let sr3 = SearchResult(content: t3)
//        let sr4 = SearchResult(content: t4)
//        let sr5 = SearchResult(content: t5)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            completion([
//               sr1, sr2, sr3, sr4, sr5,
//               sr1, sr2, sr3, sr4, sr5,
//               sr1, sr2, sr3, sr4, sr5,
//               sr1, sr2, sr3, sr4, sr5,
//               sr1, sr2, sr3, sr4, sr5
//            ])
//        }
        
        var items = [String]()
        for _ in 1...100 {
            let random = Int.random(in: 0...99)
            var s = ""
            for j in 0...random {
                s += "\(j) "
            }
            items.append(s)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(items.map { SearchResult(content: $0) })
        }
    }
    
    typealias Request = (User, String)
    typealias Response = [SearchResult]
}

struct SearchResult {
    let content: String
}

class SearchResultItem {
    init(_ searchResult: SearchResult) {
        self.searchResult = searchResult
    }
    
    let searchResult: SearchResult
    var cachedHeight: CGFloat = -1
}

protocol SearchResultCollectionLayoutDelegate: class {
    func heightForItem(at indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat
}


class SearchResultCollectionLayout: UICollectionViewLayout {
    private var cache = [UICollectionViewLayoutAttributes]()
    
    weak var delegate: SearchResultCollectionLayoutDelegate?
    
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
            
            let h1 = delegate.heightForItem(at: ip1, cellWidth: largeWidth)
            let h2 = delegate.heightForItem(at: ip2, cellWidth: smallWidth)
            let h12 = max(h1, h2)
            let f1 = CGRect(x: 4, y: yOffset + 4, width: largeWidth, height: h1)
            let f2 = CGRect(x: largeWidth + 8, y: yOffset + 4, width: smallWidth, height: h2)
            let at1 = UICollectionViewLayoutAttributes(forCellWith: ip1)
            at1.frame = f1
            let at2 = UICollectionViewLayoutAttributes(forCellWith: ip2)
            at2.frame = f2
            
            yOffset += h12 + 4

            let ip3 = IndexPath(row: group * 5 + 2, section: 0)
            let ip4 = IndexPath(row: group * 5 + 3, section: 0)
            let ip5 = IndexPath(row: group * 5 + 4, section: 0)
            
            let h3 = delegate.heightForItem(at: ip3, cellWidth: smallWidth)
            let h4 = delegate.heightForItem(at: ip4, cellWidth: smallWidth)
            let h5 = delegate.heightForItem(at: ip5, cellWidth: largeWidth)
            let h345 = max(
                h3 + h4 + 4, delegate.heightForItem(at: ip5, cellWidth: largeWidth)
            )
            let f3 = CGRect(x: 4, y: yOffset + 4, width: smallWidth, height: h3)
            
            let f4 = CGRect(x: 4, y: yOffset + h3 + 8, width: smallWidth, height: h4)
            
            let f5 = CGRect(x: smallWidth + 8, y: yOffset + 4, width: largeWidth, height: h5)
            
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


