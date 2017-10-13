//
//  SplashViewController.swift
//  entunombre
//
//  Created by Eury Perez on 10/1/17.
//  Copyright © 2017 Dulce Refugio. All rights reserved.
//

import UIKit
import RealmSwift

class SplashViewController: BaseViewController {

    var pictures:[Picture] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        self.pictures = Array(AppDelegate.shared.realm.objects(Picture.self).sorted(byKeyPath: "timestamp", ascending: false))
        
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.splashTimeOut(sender:)), userInfo: nil, repeats: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationItem.leftBarButtonItems = []
    }

    @objc func splashTimeOut(sender : Timer){
        let viewController = MainTabsViewController()
        viewController.pictures = self.pictures
        if let navigator = self.navigationController {
            navigator.pushViewController(viewController, animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
