//
//  ViewController.swift
//  KurdRating
//
//  Created by Siros Taib on 3/27/24.
//

import UIKit

class MainTapBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
        
        let vc1 = UINavigationController(rootViewController: HomeVC())
        let vc2 = UINavigationController(rootViewController: SearchVC())
        let vc3 = UINavigationController(rootViewController: DownloadsVC())
        
        setViewControllers([vc1, vc2, vc3], animated: true)
    }


}

