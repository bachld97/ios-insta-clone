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
