//
//  BaseTabBarViewController.swift
//  entunombre
//
//  Created by Eury Perez on 10/1/17.
//  Copyright © 2017 Dulce Refugio. All rights reserved.
//

import UIKit

class BaseTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // company logo
        let image: UIImage = UIImage(named: "ic_etn_wide_logo")!.resizeImageWithAspect(width: 110, height: 110)
        
        // nav bar configuration
        self.navigationItem.title = ""
        self.navigationItem.titleView = UIImageView(image: image)
        self.navigationController?.navigationBar.backItem?.title = ""
        
        let btnBack = UIButton(type: UIButtonType.system)
        btnBack.setImage(UIImage(named:"ic_back"), for: UIControlState())
        btnBack.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnBack.addTarget(self, action: #selector(BaseTabBarViewController.onBackPressed(_:)), for: UIControlEvents.touchUpInside)
        
        btnBack.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 15)
        
        if #available(iOS 11.0, *) {
            let widthConstraint = btnBack.widthAnchor.constraint(equalToConstant: 30)
            let heightConstraint = btnBack.heightAnchor.constraint(equalToConstant: 30)
            heightConstraint.isActive = true
            widthConstraint.isActive = true
        }
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: btnBack)]
        
        responsiveValidations(UIDevice().screenType)
    }

    
    
    func responsiveValidations(_ screenType: UIDevice.ScreenType) {
        
    }
    @objc func onBackPressed(_ sender : UIButton){
        if let navigator = self.navigationController {
            navigator.popViewController(animated: true)
            dismiss(animated: false, completion: nil)
        }
    }

}
