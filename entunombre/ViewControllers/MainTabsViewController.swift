//
//  MainTabsViewController.swift
//  entunombre
//
//  Created by Eury Perez on 10/1/17.
//  Copyright © 2017 Dulce Refugio. All rights reserved.
//

import UIKit

class MainTabsViewController: BaseTabBarViewController {

    var sb: UIStoryboard? = nil
    var vcs:[UIViewController] = []
    var pictures:[Picture] = []
    var videos:[YoutubeVideoDB] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.viewControllers?.isEmpty ?? true {
            sb = UIStoryboard(name: "Main", bundle: nil)
            
            if let tabOne = sb?.instantiateViewController(withIdentifier: "PictureListViewController") as? PictureListViewController {
                tabOne.pictures = self.pictures
                let tabOneBarItem = UITabBarItem(title: "Tus fotos", image: UIImage(named: "ic_tab_pictures"), tag:0)
                tabOneBarItem.image = tabOneBarItem.image?.resizeImageWithAspect(width: 30.0, height: 30.0)
                tabOne.tabBarItem = tabOneBarItem
                vcs.append(tabOne)
            }
            
            if let tabTwo = sb?.instantiateViewController(withIdentifier: "VideoListViewController") as? VideoListViewController {
                tabTwo.videos = self.videos
                let tabTwoBarItem2 = UITabBarItem(title: "Videos", image: UIImage(named: "ic_tab_videos"), tag:1)
                tabTwoBarItem2.image = tabTwoBarItem2.image?.resizeImageWithAspect(width: 30.0, height: 30.0)
                tabTwo.tabBarItem = tabTwoBarItem2
                vcs.append(tabTwo)
            }
            
            self.viewControllers = vcs
            
            for viewController in self.viewControllers ?? []{
                _ = viewController.view
            }
        }
    }
}
