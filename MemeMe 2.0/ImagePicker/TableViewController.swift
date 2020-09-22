//
//  TableViewController.swift
//  ImagePicker
//
//  Created by Binyamin Alfassi on 8/24/20.
//  Copyright © 2020 RBG Designs. All rights reserved.
//

import UIKit

//MARK: Description
// This class implements Table View Controller, viewing sent memes
class TableViewController: UITableViewController {
    
    //MARK: Properties
    // Sent-Memes list - SHARED
    var memes: [Meme]  {return (UIApplication.shared.delegate as! AppDelegate).memes}
    
    // Table row height
    let rowHeight = CGFloat(85.0)

    
    //MARK: Actions
    //MARK: Standard functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // setting button on the right side of navigation bar, to add a meme, and invoke the Meme-Editor
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToEditor))
        
//        self.tableView.rowHeight = UITableView.automaticDimension
//        self.tableView.estimatedRowHeight = 200
    }
    // This function invoked every time view will apear.
    // It will reload the data
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: User functions
    //This function invokes the Meme-Editor View
    @objc func goToEditor(){
        performSegue(withIdentifier: "TableToEditorSegue", sender: self)
    }

    // MARK: - Table view data source
    // Returns the number of rows in the sent-memes list
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.count
    }

    // Returns appropriate cell for each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Deque a table cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell", for: indexPath)
        // getting meme
        let meme = memes[indexPath.row]
        // Setting memes properties to the cell
        cell.textLabel?.text = "\(meme.topText)...\(meme.buttomText)"
        cell.imageView?.image = meme.memeImage

        return cell
    }
    
    //This method detail the action done should the specified item selected
    // If user select a meme, it will show the meme in DetailMemeViewController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Instansiating DetailMemeViewController
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "DetailMemeViewControllerId") as! DetailMemeViewController
        // Getting the right meme
        let meme = self.memes[(indexPath as NSIndexPath).row]
        // setting the meme to VC
        detailController.meme = meme
        // Push VC to the Navigation stack
        detailController.memeImageView?.backgroundColor = UIColor.red
        self.navigationController?.pushViewController(detailController, animated: true)
        
    }
    
    // This function sets the height of each table cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return UITableView.automaticDimension
        return rowHeight
    }
}
