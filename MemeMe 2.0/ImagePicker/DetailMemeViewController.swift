//
//  DetailMemeViewController.swift
//  ImagePicker
//
//  Created by Binyamin Alfassi on 30/08/2020.
//  Copyright © 2020 RBG Designs. All rights reserved.
//

import UIKit

//MARK: Descripption
//This class implements View Controller, showing a saved-meme in detail (Full screen)
// This view is pushed to the screen once the user picks a meme in "Sent Memes" screen
class DetailMemeViewController: UIViewController {
    //MARK: Outlets
    // UIImageView to view the image
    @IBOutlet weak var memeImageView: UIImageView!
    // stores a Meme
    var meme: Meme!
    
    // This function will load the memed image once the view will appear
    override func viewWillAppear(_ animated: Bool) {
        memeImageView.image = meme?.memeImage
    }
}
