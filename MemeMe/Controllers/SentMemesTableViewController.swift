// 

import UIKit

private let cellReuseIdentifier = "MemeRow"
private let detailSegueIdentifier = "MemeDetail"

class SentMemesTableViewController: UITableViewController {
    
    var memes: [Meme] {
        get {
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            return appDelegate.memes
        }
        set {
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let messageView = MessageView(title: Messages.noMemesTitle, message: Messages.noMemesMessage)
        tableView.backgroundView = messageView
        tableView.rowHeight = 100
        tableView.tableFooterView = UIView()  // Hides separator between empty cells
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = memes.count
        let isEmpty = numberOfRows == 0
        tableView.backgroundView?.isHidden = !isEmpty
        return numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let meme = memes[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
                
        cell.imageView?.bounds.size = CGSize(width: 100, height: 100)
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.topText
        cell.detailTextLabel?.text = meme.bottomText

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let meme = memes[indexPath.row]
        performSegue(withIdentifier: detailSegueIdentifier, sender: meme)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let meme = sender as! Meme
        
        if segue.identifier == detailSegueIdentifier {
            let vc = segue.destination as! MemeDetailViewController
            vc.image = meme.memedImage
        }
    }

}
