//
//  VideoListViewController.swift
//  entunombre
//
//  Created by Eury Perez on 10/18/17.
//  Copyright © 2017 Dulce Refugio. All rights reserved.
//

import UIKit
import MXParallaxHeader
import AlamofireImage
import Cloudinary
import RealmSwift
import YouTubePlayer

class VideoListViewController: BaseViewController, MXParallaxHeaderDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var lbNoVideo: UILabel!
    
    fileprivate var SpanichWhite : UIColor = #colorLiteral(red: 0.9471606319, green: 0.9673129858, blue: 0.9673129858, alpha: 1) // #FEFDF0
    var scrollView: MXScrollView!
    var progressIndicator: UIProgressView!
    var tableView: UITableView!
    var headerView: ParallaxCustomHeader!
    let headerMinimumHeight = CGFloat(170)
    var isVCLoaded = false
    var videos:[YoutubeVideoDB] = []
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.viewControllers.remove(at: 0)
        
        scrollView = MXScrollView()
        headerView = Bundle.main.loadNibNamed("StarshipHeader", owner: self, options: nil)?.first as? ParallaxCustomHeader
        scrollView.parallaxHeader.view = headerView
        scrollView.parallaxHeader.height = 200
        scrollView.parallaxHeader.mode = MXParallaxHeaderMode.fill
        scrollView.parallaxHeader.delegate = self
        view.addSubview(scrollView)
        
        progressIndicator = UIProgressView()
        progressIndicator.progress = 0.25
        view.addSubview(progressIndicator)
        
        tableView = UITableView()
        tableView.dataSource = self;
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        tableView.rowHeight = 130
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "VideoListCell", bundle: nil),
                           forCellReuseIdentifier: "VideoListCell")
        scrollView.addSubview(tableView)
        
        if videos.count == 0 {
            self.view.bringSubview(toFront: lbNoVideo)
        } else {
            self.lbNoVideo.alpha = 0
        }
        
        var frame = view.frame
        
        scrollView.frame = frame
        frame.size.height -= (topLayoutGuide.length + headerMinimumHeight - 15)
        scrollView.contentSize = frame.size
        
        frame.size.height -= scrollView.parallaxHeader.minimumHeight
        tableView.frame = frame
        
        frame.size.height = 2
        progressIndicator.frame = frame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.leftBarButtonItems = []
        self.tabBarController?.navigationItem.leftBarButtonItems = []
        self.tabBarController?.navigationItem.rightBarButtonItems = []
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.parallaxHeader.minimumHeight = headerMinimumHeight
        isVCLoaded = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func onLoadPictures() {
        self.videos = Array(realm.objects(YoutubeVideoDB.self).sorted(byKeyPath: "title", ascending: false))
        tableView.reloadData()
        
        if videos.count == 0 {
            self.view.bringSubview(toFront: lbNoVideo)
        } else {
            self.lbNoVideo.alpha = 0
        }
    }
    
    @objc func onShareVideo(_ sender : CustomUITapGesture){
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "VideoPlayerViewController") as? VideoPlayerViewController {
            viewController.videoId = sender.textTag
            if let navigator = self.navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }

    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView( _ tableView: UITableView, heightForHeaderInSection section: Int ) -> CGFloat
    {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.videos.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.headerView.ivCenterIcon.transform = CGAffineTransform.identity.rotated(by: 0)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let video = self.videos[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListCell") as? VideoListCell
        cell?.vContainer.frame.size.width = cell?.frame.size.width ?? 0
        
        switch UIDevice().screenType {
        case .iPhone6Plus:
            cell?.lbNameWidthConstraint.constant = 230
            break
        case .iPhone6:
            cell?.lbNameWidthConstraint.constant = 200
            break
        case .iPhone5, .iPhone4:
            cell?.lbNameWidthConstraint.constant = 160
            break
        default: break
        }
        
        cell?.lbName!.text = video.title
        cell?.lbDescription.text = video.desc
        if let url = URL(string: video.pictureUrl) {
            cell?.ivPicture.borderRadius(corners: [.allCorners], radius: 2)
            cell?.ivPicture.af_setImage(withURL: url)
        }
        let tap = CustomUITapGesture(target: self, action: #selector(self.onShareVideo(_:)))
        tap.textTag = video.videoId
        tap.tag = indexPath.row
        cell?.vContainer.borderRadius(corners: [.allCorners], radius: 3)
        cell?.vContainer.addBorderWithColor(color: UIColor.lightGray, width: 1.5)
        cell?.vContainer.isUserInteractionEnabled = true
        cell?.vContainer.addGestureRecognizer(tap)
        return cell!
    }
    
    // MARK: - MXParallaxHeaderDelegate
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        if isVCLoaded {
            if !scrollView.isAtTop {
                let angle = parallaxHeader.progress * CGFloat(Double.pi) * 2
                self.headerView.ivCenterIcon.transform = CGAffineTransform.identity.rotated(by: angle)
            } else {
                self.headerView.ivCenterIcon.transform = CGAffineTransform.identity.rotated(by: 0)
                
            }
        }
    }
}
