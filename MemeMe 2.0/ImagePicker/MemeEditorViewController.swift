//
//  ViewController.swift
//  ImagePicker
//
//  Created by Binyamin Alfassi on 8/16/20.
//  Copyright © 2020 RBG Designs. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: App outlets and variables
    @IBOutlet var imagePickerview: UIImageView?
    @IBOutlet var cameraButton: UIBarButtonItem?
    @IBOutlet var textFielfTop: UITextField?
    @IBOutlet var textFieldButtom: UITextField?
    
    @IBOutlet var toolbar: UIToolbar?
    @IBOutlet var navbar: UIToolbar?
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // Dlegate for UITextFields
    let memeTextFieldDelegate = MemeTextFilesDelegate()
    
    //MARK: Variables for internal use of the App
    // Defult values for UITextFields (TOP & BUTTOM)
    let  textTopDefult = "TOP"
    let  textButtomDefult = "BUTTOM"
    // Size of text frames in UITextFields
    let strokeWidth = 5.0
    
    // Screen Orientation enum (Landscape | Portrait)
    enum screenOrientation{
        case landscape, portrait
        // This function returns enum representing the current orrientation of the screen
        static func getScreenOrientation() -> screenOrientation {
            return UIDevice.current.orientation.isLandscape ? screenOrientation.landscape : screenOrientation.portrait
        }
    }
    // Font Size of UITextFields, corresponding to screen orientation
    let fontSize = [screenOrientation.landscape: CGFloat(30.0),
                    screenOrientation.portrait: CGFloat(50.0)]
    
    
    var savedMemes: [Meme] = []
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.strokeColor: UIColor.black,
    NSAttributedString.Key.foregroundColor: UIColor.white,
    NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 50)!,
    NSAttributedString.Key.strokeWidth: -4.0]
    
    // Defult functions of App
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting parameters for lunch state
        initializeApp()
        // Set Delegates
        textFielfTop!.delegate = memeTextFieldDelegate
        textFieldButtom!.delegate = memeTextFieldDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Enable/Disable camera button according to device
        cameraButton?.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        // Subscribe to keyboard notifications
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Unsubscribing from keyboard notifications
        unsubscribeFromKeyboardNotification()
    }
    
    // Handles with transition of screen orientation.
    // It comes to set the texts of UITextViewers to appropriate size
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let orientation = screenOrientation.getScreenOrientation()
        setFontSizeByOrientation(textFielfTop!, orientation)
        setFontSizeByOrientation(textFieldButtom!, orientation)
    }

    //MARK: Actions
    
    //This function invoted to cancel users changes and restore app to its lunch state
    @IBAction func cancel(){
        // Clearing image
        imagePickerview?.image = nil
        // Initializing to luch state
        initializeApp()
    }
    
    // This function picks and image from Photos Library
    // Invokes by pressing on "Album" button
    @IBAction func pickAnImage(_ sender: Any) {
        pickImageFrom(imageSource: .photoLibrary)
    }
    
    // This function picks and image from device camera
    // Invokes by pressing on Camera button
    @IBAction func pickAnImageFromCamera(_ sender: Any){
        pickImageFrom(imageSource: .camera)
    }
    
    
    // Invokes Sharing View with memed image
    @IBAction func share (){
        // Generating memed image
        let memedImage = generateMemeImage() as UIImage
        let myShareText = "My beautiful Image!"
        let meme = Meme(topText: textFielfTop!.text!, buttomText: textFieldButtom!.text!, originalImage: (imagePickerview?.image)!, memeImage: memedImage)
        // creating an Activity view and presenting it
        let activityController = UIActivityViewController(activityItems: [(memedImage), myShareText], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        activityController.completionWithItemsHandler = { activity, completed, items, error in
            if completed {
                self.save(meme)
                //self.dismiss(animated: true, completion: nil)
            }
        }

        
    }
    
    //MARK: Required operations supporting app functionality
    
    // Setting app parameters to lunch state
    func initializeApp() {
        // Initialize text field text configurations
        setupTextField(textFielfTop!, text: textTopDefult)
        setupTextField(textFieldButtom!, text: textButtomDefult)
        
        // Disabling share button (No image is set yet)
        shareButton.isEnabled = false
    }
    
    // Setting UITextField parameters
    func setupTextField(_ tf: UITextField, text: String) {
        tf.text = text
        // setting the background color to transparent
        tf.backgroundColor = UIColor.clear
        // Text size of UITextFields, according to screen orientation
        let orientation = screenOrientation.getScreenOrientation()
        setFontSizeByOrientation(tf, orientation)
        // centering text of UITextFields
        tf.textAlignment = .center
    }
    
    // This function sets font size according to screen orientation - Landscape | Portrait
    func setFontSizeByOrientation(_ tf: UITextField, _ orientation: screenOrientation) {
        var textAttributes = memeTextAttributes
        textAttributes[NSAttributedString.Key.font]! = UIFont(name: "HelveticaNeue-CondensedBlack", size: fontSize[orientation]!)!
        textFielfTop!.textColor = UIColor.white
        tf.defaultTextAttributes = textAttributes
    }
    
    // MARK: Picking an image
    // This function let user choose image from Photo Library or devices camera
    func pickImageFrom(imageSource: UIImagePickerController.SourceType) {
        let imagePiker = UIImagePickerController()
        imagePiker.delegate = self
        imagePiker.sourceType = imageSource
        present(imagePiker, animated: true, completion: nil)
    }
    
    //  This function handles with image after user picked one (either from Photo Library or device camera)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Setting selected image to UIImageViewer
        if let image = info[.originalImage] as? UIImage {
            picker.allowsEditing = false
            imagePickerview?.contentMode = .scaleAspectFit
            imagePickerview?.image = image
            shareButton.isEnabled = true
        }
        // Dismissing secondary viewer of picking the image
        dismiss(animated: true, completion: nil)
    }
    
    // Handles case of user canceling the image picking operation
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Keyboard changes functions
    // This function comes to "lift" the screen up once keyboard is invoked, so text will not be covered
    // TODO : Get indication to run code only for buttom UITextField
    @objc func keyboardWillShow(_ notification: Notification) {
        if textFieldButtom!.isEditing {
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
            let kbSize = keyboardSize.cgRectValue.height
            view.frame.origin.y -= kbSize
        }
    }
    
    // Subscribe to keyboard notifications
    func subscribeToKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Unsubscribe from keyboard notifications
    func unsubscribeFromKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    // seting the screen down once keyboard is hidden
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    //MARK: Generating Memed image
    //  This function generates a Memed image
    func generateMemeImage() -> UIImage {
        // Hide navbar and toolbar
        hideBar([navbar!, toolbar!], toHide: true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        // Creates the Memed image
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show navbar and toolbar
        hideBar([navbar!, toolbar!], toHide: false)
        
        return memedImage
    }
    
    // Saves meme to the memes array on the Application Delegate
    func save(_ meme: Meme) {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    // Toggle hidden state of list of UIToolBars
    func hideBar(_ bars: [UIToolbar], toHide: Bool){
        for b in bars {b.isHidden = toHide}
    }
    
}

