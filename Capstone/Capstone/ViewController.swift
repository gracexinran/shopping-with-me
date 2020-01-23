//
//  ViewController.swift
//  Capstone
//
//  Created by Xinran Che on 1/7/20.
//  Copyright © 2020 Xinran Che. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var homepageImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        homepageImage.layer.masksToBounds = true
        homepageImage.layer.cornerRadius = homepageImage.bounds.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}

