//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Polina Fiksson on 08/07/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        
        shareData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shareData()
        tableView.reloadData()
    }
    
    func shareData(){
        memes = (UIApplication.shared.delegate as! AppDelegate).memes
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let meme = memes[indexPath.row]
        cell.textLabel?.text = meme.topText + "... " +  meme.bottomText
        cell.imageView?.image = meme.memedImage
        cell.detailTextLabel?.text = ""

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailedController = self.storyboard?.instantiateViewController(withIdentifier: "DetailedMeme") as! MemeDetailViewController
        detailedController.imageToShow = memes[indexPath.row].memedImage
        self.navigationController?.pushViewController(detailedController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            (UIApplication.shared.delegate as! AppDelegate).memes.remove(at: indexPath.row)
            shareData()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


}
