import UIKit

extension UIButton {
    func change(toImage image: UIImage?, animated: Bool, duration: Double = 0.08) {
        setImage(image, for: .normal)

        if (animated) {
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.duration = duration
            animation.autoreverses = true
            animation.fromValue = 1
            animation.toValue = 1.45
            layer.add(animation, forKey: "transform.scale")
        }
    }
}

