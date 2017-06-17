//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Adis Cehajic on 15/05/2017.
//  Copyright © 2017 Adis Cehajic. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: Outlet properties
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // MARK: Properties
    
    let topTextFieldEmptyText = "TOP"
    let bottomTextFieldEmptyText = "BOTTOM"
    var isTopTextFieldActive = false
    var meme: Meme?
    var memeIndex: Int?
    
    // MARK: ViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMemeEditorAppearance()
        
        // If the meme is being edited set meme editor properties.
        if memeIndex != nil {
            meme = Meme.allMemes()[memeIndex!]
            imagePickerView.image = meme?.originalImage
            topTextField.text = meme?.topText
            bottomTextField.text = meme?.bottomText
            setupButtonsState()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }

    // MARK: Action methods
    
    // Opens image picker controller where camera or photo library is displayed.
    @IBAction func pickAnImage(_ sender: Any) {
        
        chooseSourceType(sourceType: UIImagePickerControllerSourceType(rawValue: (sender as! UIBarButtonItem).tag)!)
    }
    
    // Opens activity view controller for sharing created meme image.
    @IBAction func shareImage(_ sender: Any) {
    
        dissmisKeyboard()
        
        // Create meme image and open share activity view controller.
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        // Set popover presentation controller needed for iPad activity view controller presentation.
        if activityViewController.responds(to: #selector(getter: popoverPresentationController)) {
            activityViewController.popoverPresentationController?.sourceView = view
        }
        
        present(activityViewController, animated: true, completion: nil)
        
        // Save the meme after it is shared.
        activityViewController.completionWithItemsHandler = {(activityType, completed, returnedItems, error) in
            
            // If the activity view controller is dissmised without sharing the meme return.
            if !completed {
                return
            }
            
            if self.meme == nil {
                // Initialize and save meme.
                self.meme = Meme(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, originalImage: self.imagePickerView.image!, memedImage: memedImage)
                self.meme!.save()
            } else {
                self.meme = Meme(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, originalImage: self.imagePickerView.image!, memedImage: memedImage)
                Meme.update(meme: self.meme!, at: self.memeIndex!)
            }

            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Reloads meme editor view to initial values.
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Private methods
    
    // Sets the appearance of the meme editor view and its subviews.
    func setupMemeEditorAppearance() {
        
        reloadMeme()
        
        setupTextFieldAppearance(textField: topTextField)
        setupTextFieldAppearance(textField: bottomTextField)
        
        addTapGestures()
    }
    
    // Sets the state of the all buttons depending on the meme.
    func setupButtonsState() {
        shareButton.isEnabled = imagePickerView.image != nil
        topTextField.isEnabled = imagePickerView.image != nil
        bottomTextField.isEnabled = imagePickerView.image != nil
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    // Reloads the meme editor view to the initial values.
    func reloadMeme() {
        
        topTextField.text = topTextFieldEmptyText
        bottomTextField.text = bottomTextFieldEmptyText
        imagePickerView.image = nil
        setupButtonsState()
    }

    // Sets the appearance of the textfield.
    func setupTextFieldAppearance(textField: UITextField) {
        
        textField.defaultTextAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "Impact", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        textField.delegate = self
        textField.textAlignment = NSTextAlignment.center
    }
    
    // Creates notifications for keyboard actions.
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    // Removes notifications related with keyboard actions.
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // Returns the height of the keyboard.
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // Generates and returns the image from the current view state.
    func generateMemedImage() -> UIImage {
        
        // Hide navbar and toolbar
        hideToolbars(hide: true)
        
        // Render view to an image
        UIGraphicsBeginImageContextWithOptions(imagePickerView.frame.size, false, 0)
        view.drawHierarchy(in: CGRect.init(x: -imagePickerView.frame.origin.x, y: -imagePickerView.frame.origin.y, width: view.frame.size.width, height: view.frame.size.height), afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show navbar and toolbar
        hideToolbars(hide: false)
        
        return memedImage
    }
    
    // Adds the tap gesture on the view with keyboard dissmis action.
    func addTapGestures() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(dissmisKeyboard))
        view.addGestureRecognizer(singleTapGesture)
    }
    
    // Resigns the first responder status.
    func dissmisKeyboard() {
        view.endEditing(true)
    }
    
    // Opens image picker controller with inputed source type and editing options.
    func chooseSourceType(sourceType: UIImagePickerControllerSourceType) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        imagePickerController.modalTransitionStyle = .crossDissolve
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // Sets navbar and toolbar hidden.
    func hideToolbars(hide: Bool) {
        navigationController?.navigationBar.isHidden = hide
        bottomToolbar.isHidden = hide
    }
    
    // MARK: Keyboard action methods
    
    // Called when keyboard will show and sets the view position above the top.
    func keyboardWillShow(_ notification: Notification) {
        
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
    }
    
    // Called when keyboard will hide and sets the view position on the top.
    func keyboardWillHide(_ notification: Notification) {
        
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
}

extension MemeEditorViewController : UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Checks if the returned image is edited or it is an original image.
        if let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imagePickerView.image = selectedImage
        } else if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        setupButtonsState()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        reloadMeme()
    }
}

extension MemeEditorViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.text == topTextFieldEmptyText || textField.text == bottomTextFieldEmptyText {
            textField.text = ""
        }
        isTopTextFieldActive = textField.isEqual(topTextField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.text == "" {
            textField.text = textField.isEqual(topTextField) ? topTextFieldEmptyText : bottomTextFieldEmptyText
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide keyboard
        textField.resignFirstResponder()
        return true
    }
}
