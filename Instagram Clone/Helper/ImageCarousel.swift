import UIKit

class ImageCarousel: UIView, UIScrollViewDelegate {

    var imageSelectionChanged: ((Int) -> Void)?
    
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
        let selectedColor = UIColor.red
        indicator.currentPageIndicatorTintColor = selectedColor
        indicator.pageIndicatorTintColor = selectedColor.withAlphaComponent(0.4)
        indicator.isUserInteractionEnabled = false
        return indicator
    }()
    
    private lazy var imageScroller = ImageScroller()
    
    var images = [Image]() {
        didSet {
            precondition(!images.isEmpty)
            imageScroller.images = images
            pageIndicator.numberOfPages = images.count
            imageScroller.delegate = self
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
        let selection = Int(floor((scrollView.contentOffset.x - w / 2) / w) + 1)
        
        // Clamping is neccessary. Boucing scrollView may produce out of bound index
        selectedImage = min(max(selection, 0), images.count - 1)
        imageSelectionChanged?(selectedImage)
    }
    
    func clear() {
        imageSelectionChanged = nil
        self.imageScroller.delegate = nil
        imageScroller.clear()
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
    private var shouldAdjustScroll = false
    var cachedRange = 1
    
    var selectedImage: Int = 0 {
        didSet {
            if images.isEmpty {
                return
            }
            assert(selectedImage >= 0)
            assert(selectedImage < images.count)
            
            for (index, imageView) in imageViews.enumerated() {
                if selectedImage - cachedRange ... selectedImage + cachedRange ~= index {
                    imageView.image(fromUrl: images[index].url)
                } else {
                    imageView.image = nil
                }
            }
            
            if shouldAdjustScroll {
                shouldAdjustScroll = false
                let visibleRect = imageViews[selectedImage].frame
                scrollRectToVisible(visibleRect, animated: true)
            }
        }
    }
    
    func clear() {
        self.contentSize = .zero
        imageViews.forEach {
            $0.image = nil
            $0.removeFromSuperview()
        }
        images.removeAll()
        imageViews.removeAll()
        selectedImage = 0
    }
    
    private func images(didSetFrom oldValue: [Image]) {
        shouldAdjustScroll = true
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
        
        updateContentSize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        isPagingEnabled = true
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
        updateContentSize()
    }
    
    private func updateContentSize() {
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
