// 

import UIKit

class ImageScrollView: UIScrollView {
    
    var image: UIImage? = nil {
        didSet {
            imageView.image = image
            setScale()
        }
    }
    
    @IBOutlet var imageView: UIImageView!
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        initUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setScrollViewInsetsToCenter()
    }
    
    // MARK: - Private methods
    
    private func initUI() {
        imageView.backgroundColor = .white
        imageView.image = nil
    }
    
    private func setScale() {
        guard let image = image else { return }
        
        let minImageDimension = min(image.size.width, image.size.height)
        let maxImageDimension = max(image.size.width, image.size.height)
        let frameSize = frame.width
        let perfectScale = frameSize / minImageDimension
        let minScale = frameSize / maxImageDimension
        let maxScale = perfectScale * 2
        
        minimumZoomScale = minScale
        maximumZoomScale = maxScale
        setZoomScale(perfectScale, animated: false)
    }
    
    private func setScrollViewInsetsToCenter() {
        guard contentSize != .zero else { return }
        
        let offsetX = max((bounds.width - contentSize.width) * 0.5, 0)
        let offsetY = max((bounds.height - contentSize.height) * 0.5, 0)
        let newContentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    
        contentInset = newContentInset
    }
}

extension ImageScrollView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
