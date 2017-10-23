//
//  FirstViewController.swift
//  entunombre
//
//  Created by Eury Perez on 9/28/17.
//  Copyright © 2017 Dulce Refugio. All rights reserved.
//

import UIKit
import Sharaku

class MakePictureViewController: BaseViewController, FusumaDelegate, SHViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var upperImageView: UIImageView!
    @IBOutlet weak var imagesParentView: UIView!
    @IBOutlet weak var vLoading: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var framesCollectionViewHeightConstraint: NSLayoutConstraint!
    
    weak var delegate:MakePictureDelegate? = nil
    var isVCLoaded = false
    var isImageSelected = false
    var croppedImage:UIImage? = nil
    var frameCollectionViewHeight:CGFloat = 0
    var frames = [UIImage(named:"frame1"), UIImage(named:"frame2"), UIImage(named:"frame3"),
                  UIImage(named:"frame4"), UIImage(named:"frame5"), UIImage(named:"frame6"),
                  UIImage(named:"frame7"), UIImage(named:"frame8"), UIImage(named:"frame9"),
                  UIImage(named:"frame10"), UIImage(named:"frame11"), UIImage(named:"frame12")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isVCLoaded {
            self.frameCollectionViewHeight = self.framesCollectionViewHeightConstraint.constant
            self.framesCollectionViewHeightConstraint.constant = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isVCLoaded && !isImageSelected {
            if let nav = self.navigationController {
                nav.popViewController(animated: true)
            }
            return
        }
        if !isVCLoaded {
            let fusuma = FusumaViewController()
            fusuma.delegate = self
            self.present(fusuma, animated: true, completion: nil)
        }
        isVCLoaded = true
    }
    
    deinit {
        print("deiniting")
    }
    // Return the image which is selected from camera roll or is taken via the camera.
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        vLoading.alpha = 1
        isImageSelected = true
        DispatchQueue.global(qos: .background).async {
            self.croppedImage = image.compressTo(2)
            /*let imgData = NSData(data: UIImageJPEGRepresentation(image, 1)!)
            let imageSize = imgData.length
            print("size of image in KB: %f ", Double(imageSize) / 1024.0)*/
            
            DispatchQueue.main.async {
                //your main thread
                self.vLoading.alpha = 0
                let vc = SHViewController(image: self.croppedImage!)
                vc.delegate = self
                self.present(vc, animated:true, completion: nil)
                return
            }
        }
        print("Image selected")
    }
    
    func fusumaClosed() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
    }
    
    func fusumaWillClosed() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
    }
    
    func addSubmitButton() {
        let btnCreatePicture = UIButton(type: UIButtonType.system)
        btnCreatePicture.setImage(UIImage(named:"ic_checkmark"), for: UIControlState())
        btnCreatePicture.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnCreatePicture.addTarget(self, action: #selector(self.onSubmitPicture(_:)), for: UIControlEvents.touchUpInside)
        
        if #available(iOS 11.0, *) {
            let widthConstraint = btnCreatePicture.widthAnchor.constraint(equalToConstant: 30)
            let heightConstraint = btnCreatePicture.heightAnchor.constraint(equalToConstant: 30)
            heightConstraint.isActive = true
            widthConstraint.isActive = true
        }
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: btnCreatePicture)]
    }
    
    @objc func onSubmitPicture(_ sender : UIButton){
        let img = self.imagesParentView.capture()
        if let del = self.delegate {
            del.onPictureCreated(img)
        }
        
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
    }
    
    // Return the image but called after is dismissed.
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        print("Called just after FusumaViewController is dismissed.")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        print("Camera roll unauthorized")
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
    }
    
    func shViewControllerImageDidFilter(image: UIImage) {
        // Filtered image will be returned here.
        imageView.image = image
        upperImageView.image = frames[0]
        collectionView.reloadData()
        self.framesCollectionViewHeightConstraint.constant = self.frameCollectionViewHeight
        addSubmitButton()
    }
    
    func shViewControllerDidCancel() {
        if let image = self.croppedImage {
            imageView.image = image
            upperImageView.image = frames[0]
            collectionView.reloadData()
            self.framesCollectionViewHeightConstraint.constant = self.frameCollectionViewHeight
            addSubmitButton()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.frames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let frameImage = self.frames[indexPath.row]
        self.upperImageView.image = frameImage
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FrameCell", for: indexPath) as! FrameCell
        let frameImage = self.frames[indexPath.row]
        
        cell.ivFrame.image = frameImage
        
        if let picture = self.croppedImage {
            cell.ivPicture.image = picture
        }
        
        return cell
    }
}

public protocol MakePictureDelegate: class {
    
    func onPictureCreated(_ picture:UIImage)
}

