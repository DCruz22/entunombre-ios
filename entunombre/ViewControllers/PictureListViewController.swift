//
//  PictureListViewController.swift
//  entunombre
//
//  Created by Eury Perez on 10/1/17.
//  Copyright © 2017 Dulce Refugio. All rights reserved.
//

import UIKit
import MXParallaxHeader
import AlamofireImage
import Cloudinary
import RealmSwift

class PictureListViewController: BaseViewController, MXParallaxHeaderDelegate, UITableViewDelegate, UITableViewDataSource, MakePictureDelegate {
    

    fileprivate var SpanichWhite : UIColor = #colorLiteral(red: 0.9471606319, green: 0.9673129858, blue: 0.9673129858, alpha: 1) // #FEFDF0
    var scrollView: MXScrollView!
    var progressIndicator: UIProgressView!
    var tableView: UITableView!
    var headerView: ParallaxCustomHeader!
    let headerMinimumHeight = CGFloat(170)
    var isVCLoaded = false
    var pictures:[Picture] = []
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.viewControllers.remove(at: 0)
        
        let btnCreatePicture = UIButton(type: UIButtonType.system)
        btnCreatePicture.setImage(UIImage(named:"ic_camera_filled"), for: UIControlState())
        btnCreatePicture.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnCreatePicture.addTarget(self, action: #selector(self.onCreatePicture(_:)), for: UIControlEvents.touchUpInside)
        
        if #available(iOS 11.0, *) {
            let widthConstraint = btnCreatePicture.widthAnchor.constraint(equalToConstant: 30)
            let heightConstraint = btnCreatePicture.heightAnchor.constraint(equalToConstant: 30)
            heightConstraint.isActive = true
            widthConstraint.isActive = true
        }
        
        self.tabBarController?.navigationItem.leftBarButtonItems = []
        self.tabBarController?.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: btnCreatePicture)]
        
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
        tableView.register(UINib(nibName: "PictureListCell", bundle: nil),
                              forCellReuseIdentifier: "PictureListCell")
        scrollView.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.leftBarButtonItems = []
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.parallaxHeader.minimumHeight = headerMinimumHeight
        isVCLoaded = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var frame = view.frame
        
        scrollView.frame = frame
        frame.size.height -= (topLayoutGuide.length + headerMinimumHeight - 15)
        scrollView.contentSize = frame.size
        
        frame.size.height -= scrollView.parallaxHeader.minimumHeight
        tableView.frame = frame
        
        frame.size.height = 2
        progressIndicator.frame = frame
    }
    
    func onLoadPictures() {
        self.pictures = Array(realm.objects(Picture.self).sorted(byKeyPath: "timestamp", ascending: false))
        tableView.reloadData()
    }
    
    
    @objc func onSharePicture(_ sender : CustomUITapGesture){
        if let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? PictureListCell {
            
            let textToShare = "Yo voy para #EnTuNombre Jesús. Descarga la app y hazte una foto!"
            
            let objectsToShare = [textToShare, cell.ivPicture.image!] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = sender.view!
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @objc func onCreatePicture(_ sender : UIButton){
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MakePictureViewController") as! MakePictureViewController
        viewController.delegate = self
        if let navigator = self.tabBarController?.navigationController {
            navigator.pushViewController(viewController, animated: true)
        }
    }
    
    func onPictureCreated(_ picture: UIImage) {
        print(picture)
        headerView.ivCenterIcon.fadeOut(duration:0.5)
        headerView.activityIndicator.fadeIn(duration:0.5)
        headerView.activityIndicator.startAnimating()
        if let imgData = NSData(data: UIImageJPEGRepresentation(picture, 0.5)!) as? Data {
            let completion:((Cloudinary.CLDUploadResult?, NSError?) -> ())? = { (response, error) in
                let picture = Picture()
                picture.timestamp = Int(Date().ticks)
                picture.url = response?.url ?? ""
                try! self.realm.write {
                    self.realm.add(picture)
                    self.onLoadPictures()
                    
                    self.headerView.ivCenterIcon.fadeIn(duration:0.5)
                    self.headerView.activityIndicator.fadeOut(duration:0.5)
                    self.headerView.activityIndicator.stopAnimating()
                }
            }
            let progressHandler:((Progress) -> Swift.Void)? = { (progress) in
                self.progressIndicator.progress = Float(progress.fractionCompleted)
                print("progres: \(progress)")
            }
            
            DispatchQueue.global(qos: .background).async {
                AppDelegate.shared.cloudinary?.createUploader().upload(data: imgData, uploadPreset: "xcqqm4ay", progress: progressHandler, completionHandler: completion)
                DispatchQueue.main.async {
                    //your main thread
                    return
                }
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
        return self.pictures.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.headerView.ivCenterIcon.transform = CGAffineTransform.identity.rotated(by: 0)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let picture = self.pictures[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PictureListCell") as? PictureListCell
        
        cell?.lbName!.text = "\(picture.timestamp)"
        let url = URL(string: picture.url)!
        cell?.ivPicture.borderRadius(corners: [.allCorners], radius: 2)
        cell?.ivPicture.af_setImage(withURL: url)
        let tap = CustomUITapGesture(target: self, action: #selector(self.onSharePicture(_:)))
        tap.textTag = picture.url
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
