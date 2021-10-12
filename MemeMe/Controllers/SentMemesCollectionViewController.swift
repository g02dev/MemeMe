// 

import UIKit

private let reuseIdentifier = "MemeCell"
private let detailSegueIdentifier = "MemeDetail"

class SentMemesCollectionViewController: UICollectionViewController {
    
    private let cellsInRow: Int = 3
    private let spacing: CGFloat = 1.0
    
    var memes: [Meme] {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    var itemSize: CGSize {
        let minDimension = min(view.frame.size.width, view.frame.size.height)
        let size = (minDimension - CGFloat(cellsInRow - 1) * spacing) / CGFloat(cellsInRow)
        return CGSize(width: size, height: size)
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        flowLayout.minimumLineSpacing = spacing
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.itemSize = itemSize
        
        collectionView.backgroundView = MessageView(title: Messages.noMemesTitle, message: Messages.noMemesMessage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        flowLayout.itemSize = itemSize
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let meme = sender as! Meme
        
        if segue.identifier == detailSegueIdentifier {
            let vc = segue.destination as! MemeDetailViewController
            vc.image = meme.memedImage
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = memes.count
        let isEmpty = numberOfItems == 0
        collectionView.backgroundView?.isHidden = !isEmpty
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let meme = memes[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        cell.initWithMeme(meme)
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let meme = memes[indexPath.item]
        performSegue(withIdentifier: detailSegueIdentifier, sender: meme)
    }
}
