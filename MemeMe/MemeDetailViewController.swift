//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Polina Fiksson on 09/07/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var detailedImage: UIImageView!
    var imageToShow:UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        detailedImage.image = imageToShow

    }

   
    

  

}
