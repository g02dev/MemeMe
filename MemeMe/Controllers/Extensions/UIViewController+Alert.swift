// 

import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(.init(title: "OK", style: .default))
        present(alertVC, animated: true)
    }
}
