// 

import UIKit

class MemeView: UIView {
    
    var image: UIImage? {
        didSet {
            imageScrollView.image = image
        }
    }
    
    var activeTextField: UITextField? = nil
    
    var isTopTextFieldActive: Bool {
        return activeTextField == topTextField
    }
    
    var isBottomTextFieldActive: Bool {
        return activeTextField == bottomTextField
    }
    
    weak var textFieldDelegate: UITextFieldDelegate?
    
    @IBOutlet weak var imageScrollView: ImageScrollView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    // MARK: - Private methods
    
    private func initUI() {
        let textFields: [UITextField] = [topTextField, bottomTextField]
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
            .strokeWidth: -3,
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.white,
        ]
        for textField in textFields {
            textField.delegate = textFieldDelegate
            textField.defaultTextAttributes = textAttributes
            textField.textAlignment = .center
            textField.adjustsFontSizeToFitWidth = true
            textField.minimumFontSize = 17
        }
    }
    
    private func generateMemedImage() -> UIImage {
        activeTextField?.endEditing(true)
        toggleScrollViewIndicatorsVisibility(isHidden: true)
        
        let memedImage = convertViewToImage(self)
        
        toggleScrollViewIndicatorsVisibility(isHidden: false)
        
        return memedImage
    }
    
    private func toggleScrollViewIndicatorsVisibility(isHidden: Bool) {
        imageScrollView.showsVerticalScrollIndicator = !isHidden
        imageScrollView.showsHorizontalScrollIndicator = !isHidden
    }
    
    private func convertViewToImage(_ view: UIView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        return image
    }
    
    // MARK: - Public methods
    
    func getMeme() -> Meme {
        let memedImage = convertViewToImage(self)
        let meme = Meme(
            topText: topTextField.text,
            bottomText: bottomTextField.text,
            originalImage: image,
            memedImage: memedImage
        )
        return meme
    }
    
}
