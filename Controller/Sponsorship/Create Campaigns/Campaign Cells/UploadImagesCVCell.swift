////
////  UploadImagesCVCell.swift
////  Flytant
////
////  Created by Flytant on 05/10/21.
////  Copyright © 2021 Vivek Rai. All rights reserved.
////
//
//import UIKit
//
//class UploadImagesCVCell: UICollectionViewCell {
//
//    @IBOutlet weak var addImageButton: UIButton!
//    @IBOutlet weak var imageCollectionView: UICollectionView!
//    @IBOutlet weak var doneButton: UIButton!
//    weak var delegate: CampaignCellDelegate?
//    var images = [UIImage]() {
//        didSet { imageCollectionView.reloadData() }
//    }
//    
//    private let identifier: String = "campaignImageCell"
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        doneButton.layer.cornerRadius = 5
//        doneButton.layer.masksToBounds = true
//        
//        collectionViewInit()
//    }
//
//    
//    fileprivate func collectionViewInit() {
//        imageCollectionView.register(UINib(nibName: "CampaignImageCVCell", bundle: nil), forCellWithReuseIdentifier: identifier)
//        imageCollectionView.delegate = self
//        imageCollectionView.dataSource = self
//        imageCollectionView.reloadData()
//    }
//    
//    
//    @IBAction func selectImageAction(_ sender: UIButton) {
//        delegate?.selectImages()
//    }
//    
//    @IBAction func doneAction(_ sender: UIButton) {
//        if images.isEmpty {
//            delegate?.showErrorMeg(msg: "Please select image")
//        } else {
//            delegate?.done(cellType: .uploadImages, value: "")
//        }
//    }
//    
//}
//
//extension UploadImagesCVCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CampaignImageDelegate {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return images.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CampaignImageCVCell else { return UICollectionViewCell() }
//        cell.layer.cornerRadius = 10
//        cell.layer.masksToBounds = true
//        cell.mainImageView.image = images[indexPath.row]
//        cell.delegate = self
//        cell.index = indexPath.row
//        return cell
//    }
//    
//    func deleteTheImage(index: Int) {
//        images.remove(at: index)
//        delegate?.deleteCampaignImage(index)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (collectionView.bounds.width * 0.4), height: collectionView.bounds.height - 10)
//    }
//    
//}
