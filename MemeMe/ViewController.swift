//
//  ViewController.swift
//  MemeMe
//
//  Created by Polina Fiksson on 29/06/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var appToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    var memedImage:UIImage!
    
    //a dictionary of attributes chosen from those specified in the NSAttributedString class
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3.0]
    
    func configure(textField: UITextField, text: String, defaultAttributes: [String:Any]){
        // set delegation, text, attribtues, etc ...
        textField.text = text
        textField.defaultTextAttributes = defaultAttributes
        textField.delegate = self
        textField.textAlignment = .center
   
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareButton.isEnabled = false
        configure(textField: topText, text: "TOP", defaultAttributes: memeTextAttributes)
        configure(textField: bottomText, text: "BOTTOM", defaultAttributes: memeTextAttributes)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType){
        let controller = UIImagePickerController()
        controller.sourceType = sourceType
        controller.delegate = self
        present(controller, animated: true, completion: nil)
        
    }

    @IBAction func takeAPicture(_ sender: UIBarButtonItem) {
        presentImagePickerWith(sourceType: .camera)
    }
    
    @IBAction func choosePictureFromAlbum(_ sender: UIBarButtonItem) {
        presentImagePickerWith(sourceType: .photoLibrary)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        shareButton.isEnabled = true
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func shareImage(_ sender: UIBarButtonItem) {
        
//        generate a memed image
        memedImage = generateMemedImage()
//        define an instance of the ActivityViewController
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
//        pass the ActivityViewController a memedImage as an activity item
//        present the ActivityViewController
        controller.completionWithItemsHandler = {(activity, completed, items, error) in
            if completed{
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(controller, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardNotifications() {
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self,selector: #selector(keyboardWillHide(_:)),name: NSNotification.Name.UIKeyboardWillHide,object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification:Notification) {
        if bottomText.isFirstResponder {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
            view.frame.origin.y = 0
        
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //self.navigationController?.setToolbarHidden(true, animated: true)
        appToolbar.isHidden = true
        
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        appToolbar.isHidden = false
        
        return memedImage
    }
    
    func save() {
        // Create the meme
        
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imageView.image!, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate as! AppDelegate
        object.memes.append(meme)
    }

    @IBAction func cancelCreation(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

class Meme{
    var topText: String
    var bottomText: String
    var originalImage: UIImage?
    var memedImage: UIImage?
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage:UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
    
}

