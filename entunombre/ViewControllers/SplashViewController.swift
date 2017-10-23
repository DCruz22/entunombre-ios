//
//  SplashViewController.swift
//  entunombre
//
//  Created by Eury Perez on 10/1/17.
//  Copyright © 2017 Dulce Refugio. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import AlamofireObjectMapper


class SplashViewController: BaseViewController {

    var pictures:[Picture] = []
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        self.pictures = Array(AppDelegate.shared.realm.objects(Picture.self).sorted(byKeyPath: "timestamp", ascending: false))
        
        /*Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.splashTimeOut(sender:)), userInfo: nil, repeats: false)*/
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationItem.leftBarButtonItems = []
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Alamofire.request(Constants.Urls.YOUTUBE_SEARCH_VIDEOS, method: .get, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseObject { (response: DataResponse<YoutubeVideoResponse>) in
                switch response.result {
                case .success(let value):
                    let videos:[YoutubeVideo] = value.items ?? []
                    let videosDB:[YoutubeVideoDB] = videos.map {video in
                        let videoDB = YoutubeVideoDB()
                        videoDB.videoId = video.id?.videoId ?? ""
                        videoDB.title = video.snippet?.title ?? ""
                        videoDB.desc = video.snippet?.description ?? ""
                        videoDB.pictureUrl = video.snippet?.thumbnails?.thumbnail?.url ?? ""
                        return videoDB
                    }
                    
                    try! self.realm.write {
                        self.realm.add(videosDB, update:true)
                        
                        let viewController = MainTabsViewController()
                        viewController.pictures = self.pictures
                        viewController.videos = videosDB
                        if let navigator = self.navigationController {
                            navigator.pushViewController(viewController, animated: true)
                        }
                    }
                    print("videos done")
                    break
                case .failure(let error):
                    print(error)
                    return
                }
        }
    }

    @objc func splashTimeOut(sender : Timer){
        let viewController = MainTabsViewController()
        viewController.pictures = self.pictures
        if let navigator = self.navigationController {
            navigator.pushViewController(viewController, animated: true)
        }
    }
}
