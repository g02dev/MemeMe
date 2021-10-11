// 

import UIKit
import PhotosUI

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate {
    
    struct Alerts {
        static let incompleteMemeTitle = "Incomplete Meme"
        static let noBackgroundMessage = "Add background image to complete meme"
    }

    // MARK: - IBOutlets and IBActions
    
    @IBOutlet weak var memeView: MemeView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!

    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func pickImageFromCamera(_ sender: UIBarButtonItem) {
        presentPickerViewController(source: .camera)
    }

    @IBAction func pickImageFromLibrary(_ sender: UIBarButtonItem) {
        presentPickerViewController(source: .photoLibrary)
    }
    
    @IBAction func shareImage(_ sender: UIBarButtonItem) {
        let meme = memeView.getMeme()
        let memedImage = meme.memedImage
        
        guard meme.originalImage != nil else {
            showAlert(title: Alerts.incompleteMemeTitle, message: Alerts.noBackgroundMessage)
            return
        }
        
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: [])
        activityVC.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
            if completed {
                self.saveMeme(meme)
            }
        }
        present(activityVC, animated: true)
    }
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        memeView.textFieldDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotification()
    }

    
    // MARK: - Picker
    
    private func presentPickerViewController(source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.modalPresentationStyle = .fullScreen
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // MARK: - Meme image manipulation
    
    func saveMeme(_ meme: Meme) {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }

    
    // MARK: - Keyboard notifications
    
    private func subscribeToKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unsubscribeFromKeyboardNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let isBottomTextFieldActive = memeView.isBottomTextFieldActive
        let isViewMoved = view.frame.origin.y != 0
        
        if isBottomTextFieldActive && !isViewMoved {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardHeight = keyboardSize.cgRectValue.height
        return keyboardHeight
    }
}

extension MemeEditorViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        picker.dismiss(animated: true)
        
        let pickedImage: UIImage
        
        if let editedImage = info[.editedImage] as? UIImage {
            pickedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            pickedImage = originalImage
        } else {
            return
        }
        
        memeView.image = pickedImage
    }
}

extension MemeEditorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        memeView.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        memeView.activeTextField = nil
    }
}

