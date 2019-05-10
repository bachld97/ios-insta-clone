import UIKit
import Kingfisher

extension UIImageView {
    func image(fromUrl urlString: String) {
        let url = URL(string: urlString)
        kf.setImage(with: url)
    }
}
