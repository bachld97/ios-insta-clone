import UIKit

open class BaseCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    open var dataSource: CollectionViewDataSource? {
        didSet {
            for cls in dataSource?.cellClasses() ?? [] {
                collectionView?.register(
                    cls, forCellWithReuseIdentifier: NSStringFromClass(cls)
                )
            }
            dataSource(didChangeFrom: oldValue, to: dataSource)
        }
    }

    public init(layout: UICollectionViewLayout = UICollectionViewFlowLayout()) {
        super.init(collectionViewLayout: layout)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        configureBaseViewController()
    }
    
    private func configureBaseViewController() {
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.register(
            BaseCollectionViewCell.self,
            forCellWithReuseIdentifier: NSStringFromClass(BaseCollectionViewCell.self)
        )
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func dataSource(didChangeFrom oldSource: CollectionViewDataSource?,
                         to newSource: CollectionViewDataSource?) {
        collectionView?.reloadData()
    }
    
    override open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections() ?? 0
    }
    
    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(inSection: section) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    // Default 1 row layout with arbitrary height
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 48)
    }
    
    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: CollectionViewCell
        let cellClass: CollectionViewCell.Type
        
        if let cls = dataSource?.cellClass(at: indexPath) {
            cellClass = cls
        } else if let cls = dataSource?.cellClasses().first {
            cellClass = cls
        } else {
            cellClass = BaseCollectionViewCell.self
        }

        let cellId = NSStringFromClass(cellClass)
        cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellId, for: indexPath
        ) as! CollectionViewCell
        
        cell.item = dataSource?.item(at: indexPath)
        return cell
    }
}

final class BaseCollectionViewCell: CollectionViewCell {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()

    override func prepareUI() {
        super.prepareUI()
        addSubview(label)
        label.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: lineDivider.topAnchor,
            trailing: trailingAnchor
        )
    }
    
    override func configureCell(with item: Any?) {
        label.text = String(describing: item)
    }
}

open class CollectionViewDataSource: NSObject {
    public var objects: [Any]? = nil
    
    open func numberOfSections() -> Int {
        return 1
    }
    
    open func numberOfItems(inSection section: Int) -> Int {
        return objects?.count ?? 0
    }
    
    open func item(at indexPath: IndexPath) -> Any? {
        return objects?[indexPath.row]
    }
    
    open func cellClass(at indexPath: IndexPath) -> CollectionViewCell.Type? {
        return nil
    }

    open func cellClasses() -> [CollectionViewCell.Type] {
        return []
    }
}

open class CollectionViewCell: UICollectionViewCell {
    public var item: Any? {
        didSet {
            configureCell(with: item)
        }
    }
    
    open var lineDivider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.from(r: 0, g: 0, b: 0, a: 0.5)
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func prepareUI() {
        clipsToBounds = true
        addSubview(lineDivider)
        lineDivider.anchor(
            top: nil, leading: leadingAnchor,
            bottom: bottomAnchor, trailing: trailingAnchor,
            padding: .zero,
            size: .init(width: 0, height: 0.5)
        )
    }

    open func configureCell(with item: Any?) {
        print("Configure cell with item: \(String(describing: item))")
    }
}
