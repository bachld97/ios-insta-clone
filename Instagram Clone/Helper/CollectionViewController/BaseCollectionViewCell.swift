import Foundation
import UIKit

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
