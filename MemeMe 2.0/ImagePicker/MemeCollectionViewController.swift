//
//  MemeCollectionViewController.swift
//  ImagePicker
//
//  Created by Binyamin Alfassi on 8/24/20.
//  Copyright © 2020 RBG Designs. All rights reserved.
//

import UIKit

//private let reuseIdentifier = "Cell"


//MARK: Description
// This class implements Collection View Controller, viewing sent memes
class MemeCollectionViewController: UICollectionViewController {
    
    //MARK: Outlets and properties
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    // constants related to Layouts
    let space: [MemeEditorViewController.screenOrientation: CGFloat] = [.portrait : 3.0, .landscape : 10.0]
    let columnsNumber: [MemeEditorViewController.screenOrientation: CGFloat] = [.portrait : 3.0, .landscape : 5.0]
    let rowsNumber: [MemeEditorViewController.screenOrientation: CGFloat] = [.portrait : 4.0, .landscape : 2.0]
    
    // Sent-Memes list - SHARED
    var memes: [Meme] {return (UIApplication.shared.delegate as! AppDelegate).memes }
    
    //MARK: Actions
    //Mark: Standard functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // setting button on the right side of navigation bar, to add a meme, and invoke the Meme-Editor
        // Finally it will set the layout of the memes.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToEditor))
        setFlowLayout()
        
        for _ in 1...15{
            (UIApplication.shared.delegate as! AppDelegate).memes.append(Meme(topText: "Top", buttomText: "Buttom", originalImage: UIImage(named: "ExamplePic")!, memeImage: UIImage(named: "ExamplePic")!))
        }
    }
    
    // This function invoked every time view will apear.
    // It will reload the data and add an observer to Notification Center to detect when the screen orientation changed so the layout will be set
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(setFlowLayout), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    // This function will remove the observer for screen-orientation changing before view will disapear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    //MARK: User functions
    //This function invokes the Meme-Editor View
    @objc func goToEditor(){
        performSegue(withIdentifier: "CollectionToEditorSegue", sender: self)
    }
    
    // This function sets correct layout for the images, according to screen orientation (Portrated/Landscape)
    @objc func setFlowLayout(){
        // Getting screen orientation
        let orientation = MemeEditorViewController.screenOrientation.getScreenOrientation()
        // Setting the appropriate layout
        let dimensionWidth = (view.frame.size.width - (2*space[orientation]!)) / columnsNumber[orientation]!
        let dimensionHeight = (view.frame.size.height - 2*space[orientation]!) / rowsNumber[orientation]!
        flowLayout.minimumInteritemSpacing = space[orientation]!
        flowLayout.minimumLineSpacing = space[orientation]!
        flowLayout.itemSize = CGSize(width: dimensionWidth, height: dimensionHeight)
    }

    // MARK: UICollectionViewDataSource
    // Returns the number of items in the sent-memes list
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    // Returns appropriate cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Deque MemeCollectionViewCCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        // Getting the right meme
        let meme = memes[indexPath.row]
        // Setting meme to the cell
        cell.memedImageView.image = meme.memeImage
        
        return cell
    }
    //This method detail the action done should the specified item selected
    // If user select a meme, it will show the meme in DetailMemeViewController
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        // Instansiating DetailMemeViewController
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "DetailMemeViewControllerId") as! DetailMemeViewController
        // getting the right meme
        let meme = self.memes[(indexPath as NSIndexPath).row]
        // setting the meme to VC
        detailController.meme = meme
        // Push VC to the Navigation stack
        self.navigationController?.pushViewController(detailController, animated: true)
        
        return true
    }
}
