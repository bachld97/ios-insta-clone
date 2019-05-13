import UIKit

open class CollectionViewCell: UICollectionViewCell {
    public var item: Any? {
        didSet {
            configureCell(with: item)
        }
    }
    
    public weak var viewController: BaseCollectionViewController?
    
    open var lineDivider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.from(r: 0, g: 0, b: 0, a: 0.3)
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
            size: .init(width: 0, height: 0.25)
        )
    }
    
    open func configureCell(with item: Any?) {
        print("Configure cell with item: \(String(describing: item))")
    }
}
