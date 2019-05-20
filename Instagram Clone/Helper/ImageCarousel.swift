import UIKit

class ImageCarousel: UIView, UIScrollViewDelegate {
    
    init(hideIndicator: Bool = false) {
        super.init(frame: .zero)
        addSubview(imageScroller)
        addSubview(pageIndicator)
        
        imageScroller.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor
        )
        
        pageIndicator.anchor(
            top: nil,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: 8, right: 16),
            size: .height(12)
        )
        
        if hideIndicator {
            pageIndicator.invisible()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private let pageIndicator: UIPageControl = {
        let indicator = UIPageControl()
        indicator.hidesForSinglePage = true
        indicator.pageIndicatorTintColor = .lightGray
        indicator.currentPageIndicatorTintColor = .darkGray
        indicator.isUserInteractionEnabled = false
        return indicator
    }()
    
    private lazy var imageScroller: ImageScroller = {
        let scroller = ImageScroller()
        scroller.delegate = self
        return scroller
    }()

    var images = [Image]() {
        didSet {
            imageScroller.images = images
            pageIndicator.numberOfPages = images.count
        }
    }
    
    var selectedImage: Int = 0 {
        didSet {
            pageIndicator.currentPage = selectedImage
            imageScroller.selectedImage = selectedImage
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let w = frame.width
        selectedImage = Int(floor((scrollView.contentOffset.x - w / 2) / w) + 1)
    }
}


class ImageScroller: UIScrollView {

    var images: [Image] = [] {
        didSet {
            images(didSetFrom: oldValue)
        }
    }
    
    private var imageViews: [UIImageView] = []
    private let container = UIView()
    
    var selectedImage: Int = 0 {
        didSet {
            if images.isEmpty {
                assertionFailure("Empty carousel should not exist.")
            }
            assert(selectedImage >= 0)
            assert(selectedImage < images.count)
            
            let cachedRange = 1
            for (index, imageView) in imageViews.enumerated() {
                if selectedImage - cachedRange ... selectedImage + cachedRange ~= index {
                    imageView.image(fromUrl: images[index].url)
                } else {
                    imageView.image = nil
                }
            }
        }
    }
    
    private func images(didSetFrom oldValue: [Image]) {
        let diff = oldValue.count - images.count
        if diff > 0 {
            for _ in 0 ..< diff {
                imageViews.last?.removeFromSuperview()
                imageViews.removeLast()
            }
        } else {
            for _ in 0 ..< (-1 * diff) {
                let iv = UIImageView()
                container.addSubview(iv)
                imageViews.append(iv)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        isPagingEnabled = true
        bounces = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        addSubview(container)
        
        container.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = self.frame.width
        let height = self.frame.height
        contentSize = CGSize(
            width: width * CGFloat(images.count), height: height
        )
        
        for (index, view) in imageViews.enumerated() {
            view.frame = CGRect(
                x: CGFloat(index) * width,
                y: 0,
                width: width,
                height: height
            )
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
