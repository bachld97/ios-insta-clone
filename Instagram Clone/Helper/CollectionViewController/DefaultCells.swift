import Foundation
import UIKit

open class DefaultCollectionViewCell: CollectionViewCell {
    open lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override open func prepareUI() {
        super.prepareUI()
        addSubview(label)
        label.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: lineDivider.topAnchor,
            trailing: trailingAnchor
        )
    }
    
    override open func configureCell(with item: Any?) {
        label.text = String(describing: item)
    }
}

class DefaultCollectionHeader: DefaultCollectionViewCell {
    override func prepareUI() {
        super.prepareUI()
        label.text = "Header"
        label.textAlignment = .center
    }
    
    override func configureCell(with item: Any?) {
        guard let item = item else {
            label.text = "Header"
            return
        }
        label.text = "\(item)"
    }
}

class DefaultCollectionFooter: DefaultCollectionViewCell {
    override func prepareUI() {
        super.prepareUI()
        label.text = "Footer"
        label.textAlignment = .center
    }
    
    override func configureCell(with item: Any?) {
        guard let item = item else {
            label.text = "Footer"
            return
        }
        label.text = "\(item)"
    }
}
