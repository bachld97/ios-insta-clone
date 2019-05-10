import UIKit

extension UIView {
    func anchor(
        top: NSLayoutYAxisAnchor?,
        leading: NSLayoutXAxisAnchor?,
        bottom: NSLayoutYAxisAnchor?,
        trailing: NSLayoutXAxisAnchor?,
        padding: UIEdgeInsets = .zero,
        size: CGSize = .zero
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(
                equalTo: top, constant: padding.top
            ).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(
                equalTo: leading, constant: padding.left
            ).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(
                equalTo: bottom, constant: -padding.bottom
            ).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(
                equalTo: trailing, constant: -padding.right
            ).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(
                equalToConstant: size.width
            ).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(
                equalToConstant: size.height
            ).isActive = true
        }
    }
    
    func matchWidth(withHeightOf other: UIView) {
        translatesAutoresizingMaskIntoConstraints = false

        widthAnchor.constraint(
            equalTo: other.heightAnchor
        ).isActive = true
    }
    
    func matchWidth(withWidthOf other: UIView) {
        translatesAutoresizingMaskIntoConstraints = false

        widthAnchor.constraint(
            equalTo: other.widthAnchor
        ).isActive = true
    }
    
    func matchHeight(withHeightOf other: UIView) {
        translatesAutoresizingMaskIntoConstraints = false

        heightAnchor.constraint(
            equalTo: other.heightAnchor
        ).isActive = true
    }
    
    func matchHeight(withWidthOf other: UIView) {
        translatesAutoresizingMaskIntoConstraints = false

        heightAnchor.constraint(
            equalTo: other.widthAnchor
        ).isActive = true
    }
    
    func matchSize(with other: UIView) {
        matchWidth(withWidthOf: other)
        matchHeight(withHeightOf: other)
    }
    
    func aspectRatio(widthToHeight: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false

        widthAnchor.constraint(
            equalTo: heightAnchor, multiplier: widthToHeight
        ).isActive = true
    }
    
    func size(equalTo size: CGSize) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
    
    func centerInSuperview(size: CGSize = .zero) {
        guard let superview = superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false

        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        
        centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}
