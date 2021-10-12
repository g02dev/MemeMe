// 

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func initWithMeme(_ meme: Meme) {
        imageView.contentMode = .scaleAspectFill
        imageView.image = meme.memedImage
    }
}
