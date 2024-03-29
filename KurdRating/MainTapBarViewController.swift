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
        let vc2 = UINavigationController(rootViewController: UpcomingVC())
        let vc3 = UINavigationController(rootViewController: SearchVC())
        let vc4 = UINavigationController(rootViewController: DownloadsVC())
        
        vc1.tabBarItem.image = UIImage(systemName: "popcorn.fill")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "sparkle.magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "square.and.arrow.down.fill")
        
        vc1.tabBarItem.title = "Home"
        vc2.tabBarItem.title = "Upcoming"
        vc3.tabBarItem.title = "Search"
        vc4.tabBarItem.title = "Downloads"
        
        tabBar.tintColor = .label
        
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }


}

