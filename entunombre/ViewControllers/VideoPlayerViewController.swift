//
//  VideoPlayerViewController.swift
//  entunombre
//
//  Created by Eury Perez on 10/18/17.
//  Copyright © 2017 Dulce Refugio. All rights reserved.
//

import UIKit
import YouTubePlayer

class VideoPlayerViewController: BaseViewController, UIWebViewDelegate, YouTubePlayerDelegate {

    @IBOutlet weak var player: YouTubePlayerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var videoId:String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        player.delegate = self
        
        activityIndicator.startAnimating()
        activityIndicator.alpha = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.darkText
    }
    
    override func viewDidAppear(_ animated: Bool) {
        player.playerVars = [
            "playsinline": "0" as AnyObject,
            "controls": "1" as AnyObject,
            "autoplay": "1" as AnyObject,
            "enablejsapi": "1" as AnyObject,
            "showinfo": "0" as AnyObject
        ]
        
        if let id = self.videoId {
            player.loadVideoID(id)
        }
    }
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        print("0")
        activityIndicator.stopAnimating()
        activityIndicator.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
