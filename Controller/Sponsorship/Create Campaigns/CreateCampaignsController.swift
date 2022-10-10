////
////  CreateCampaignsController.swift
////  Flytant
////
////  Created by Flytant on 05/10/21.
////  Copyright © 2021 Vivek Rai. All rights reserved.
////
//
//import UIKit
//import FMPhotoPicker
//
//enum CampaignCell {
//    case name
//    case description
//    case uploadImages
//    case payment
//    case platform
//    case followers
//    case gender
//    case category
//    case preview
//}
//
//protocol CampaignCellDelegate: AnyObject {
//    func done(cellType: CampaignCell, value: String)
//    func showErrorMeg(msg: String)
//    func previewCampaign()
//    func submitCampaign()
//    /// show category controller
//    func openCategoryPage()
//
//    func textEntered(cellType: CampaignCell, value: String)
//    /// show image selector
//    func selectImages()
//    /// delete selected image
//    func deleteCampaignImage(_ index: Int)
//
//    func selectedPayment(method: PaymentSelected, value: String)
//}
//
//typealias FileCompletionBlock = () -> Void
//
//class CreateCampaignsController: UIViewController {
//
//    //MARK:- Outlets
//    @IBOutlet weak var campaignCollectionVIew: UICollectionView!
//    @IBOutlet weak var downButton: UIButton!
//    @IBOutlet weak var upButton: UIButton!
//    @IBOutlet weak var backButton: UIButton!
//
//    //MARK:- Identifier
//    private let campaignNameIdentifier: String = "campaignNameCell"
//    private let describeCampaignIdentifier: String = "describeCell"
//    private let uploadImageCampaignIdentifier: String = "uploadImageCell"
//    private let campaignPaymentIdentifier: String = "paymentMethodCell"
//    private let selectPlatformIdentifier: String = "selectPlatformCell"
//    private let miniumFollowersIdentifier: String = "minimumFollowersCell"
//    private let genderTargetIdentifier: String = "genderTargetCell"
//    private let chooseCategoryIdentifier: String = "chooseCategoryCell"
//    private let previewIdentifier: String = "previewCell"
//
//    private var currentIndex: Int = 0
//    private var createCampaign = [String: String]()
//    private var createCampaignModel: CreateCampaignModel?
//    private var campaignImages = [UIImage]()
//    private let pickerData = ["Male", "Female", "Any"]
//
//    private var pickerView: UIPickerView!
//    private var toolBar: UIToolbar!
//
//    private var block: FileCompletionBlock?
//    private var imageURLs = [String]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        collectionViewInit()
//        roundTheButton()
//        pickerViewInit()
//    }
//
//
//    private func collectionViewInit() {
//        campaignCollectionVIew.register(UINib(nibName: "CampaignNameCVCell", bundle: nil), forCellWithReuseIdentifier: campaignNameIdentifier)
//        campaignCollectionVIew.register(UINib(nibName: "UploadImagesCVCell", bundle: nil), forCellWithReuseIdentifier: uploadImageCampaignIdentifier)
//        campaignCollectionVIew.register(UINib(nibName: "DescribeCampaignCVCell", bundle: nil), forCellWithReuseIdentifier: describeCampaignIdentifier)
//        campaignCollectionVIew.register(UINib(nibName: "CampaignPaymentCVCell", bundle: nil), forCellWithReuseIdentifier: campaignPaymentIdentifier)
//        campaignCollectionVIew.register(UINib(nibName: "SelectPlatformCVCell", bundle: nil), forCellWithReuseIdentifier: selectPlatformIdentifier)
//        campaignCollectionVIew.register(UINib(nibName: "MinimumFollowersCVCell", bundle: nil), forCellWithReuseIdentifier: miniumFollowersIdentifier)
//        campaignCollectionVIew.register(UINib(nibName: "GenderTargetCVCell", bundle: nil), forCellWithReuseIdentifier: genderTargetIdentifier)
//        campaignCollectionVIew.register(UINib(nibName: "ChooseCategoryCVCell", bundle: nil), forCellWithReuseIdentifier: chooseCategoryIdentifier)
//        campaignCollectionVIew.register(UINib(nibName: "PreviewCampaignCVCell", bundle: nil), forCellWithReuseIdentifier: previewIdentifier)
//        campaignCollectionVIew.delegate = self
//        campaignCollectionVIew.dataSource = self
//        campaignCollectionVIew.reloadData()
//    }
//
//    fileprivate func pickerViewInit() {
//        pickerView = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.bounds.width, height: 300))
//        pickerView.backgroundColor = .systemBackground
//        pickerView.delegate = self
//        pickerView.dataSource = self
//
//        toolBar = UIToolbar()
//        toolBar.barStyle = UIBarStyle.default
//        toolBar.isTranslucent = true
//        toolBar.tintColor = .black
//        toolBar.sizeToFit()
//
//        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButton))
//        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButton))
//
//        toolBar.setItems([cancel, space, done], animated: false)
//        toolBar.isUserInteractionEnabled = true
//    }
//
//
//    private func roundTheButton() {
//        upButton.layer.cornerRadius = 20
//        upButton.layer.masksToBounds = true
//
//        downButton.layer.cornerRadius = 20
//        downButton.layer.masksToBounds = true
//    }
//
//    @IBAction private func goDown(_ sender: UIButton) {
//        switch currentIndex {
//        case 0: //name
//            if createCampaignModel?.name != nil {
//                goDown()
//            } else {
//                showAlert(msg: "Please enter your campaign name")
//            }
//        case 1: //description
//            if createCampaignModel?.description != nil {
//                goDown()
//            } else {
//                showAlert(msg: "Please enter your campaign description")
//            }
//        case 2: // campaign images
//            if !campaignImages.isEmpty {
//                goDown()
//            } else {
//                showAlert(msg: "Please add some images for your campaign")
//            }
//        case 3: //payment
//            if createCampaignModel?.barter != nil || createCampaignModel?.price != nil {
//                goDown()
//            } else {
//                showAlert(msg: "Please select any payment method")
//            }
//        case 4: // platform
//            if createCampaignModel?.platforms != nil {
//                goDown()
//            } else {
//                showAlert(msg: "Please specify the minimum number of followers.")
//            }
//        case 5://followers
//            if createCampaignModel?.minFollowers != nil {
//                goDown()
//            } else {
//                showAlert(msg: "Please specify the minimum number of followers.")
//            }
//        case 6://gender
//            if createCampaignModel?.gender != nil {
//                goDown()
//            } else {
//                showAlert(msg: "Please select a target audiance for your campaign")
//            }
//        case 7://category
//            if createCampaignModel?.categories != nil {
//                goDown()
//            } else {
//                showAlert(msg: "Please add category for your campaign")
//            }
//        default:
//            break
//        }
//    }
//
//    @objc func doneButton() {
//        guard let cell = campaignCollectionVIew.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? GenderTargetCVCell else { return }
//        let row = self.pickerView.selectedRow(inComponent: 0)
//        self.pickerView.selectRow(row, inComponent: 0, animated: false)
//        cell.genderTF.text = self.pickerData[row]
//        cell.genderTF.resignFirstResponder()
//    }
//
//    @objc func cancelButton() {
//        guard let cell = campaignCollectionVIew.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? GenderTargetCVCell else { return }
//        cell.genderTF.resignFirstResponder()
//    }
//
//    private func goDown() {
//        if currentIndex < 8 {
//        currentIndex += 1
//        campaignCollectionVIew.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
//        }
//    }
//
//    @IBAction func backAction(_ sender: UIButton) {
//
//        let alert = UIAlertController(title: "Discard", message: "Do you want to discard this campaign?", preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "yes", style: .default, handler: discardChanges(_:)))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    @objc private func discardChanges(_ action: UIAlertAction) {
//        self.navigationController?.popViewController(animated: true)
//    }
//
//    @IBAction private func goUp(_ sender: UIButton) {
//        if currentIndex != 0 {
//        currentIndex -= 1
//        campaignCollectionVIew.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
//        }
//    }
//
//}
//extension CreateCampaignsController: UIPickerViewDelegate, UIPickerViewDataSource {
//
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return pickerData.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        let attributedString = NSAttributedString(string: pickerData[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.label])
//        return attributedString
//    }
//
//}
//
//extension CreateCampaignsController: CampaignCellDelegate, CategoriesDelegate {
//
//    func done(cellType: CampaignCell, value: String) {
//        createCampaignModel = CreateCampaignModel()
//        switch cellType {
//        case .name:
//            createCampaignModel?.name = value
//            goDown()
//        case .description:
//            createCampaignModel?.description = value
//            goDown()
//        case .uploadImages:
//            goDown()
//        case .platform:
//            let values = value.components(separatedBy: ", ")
//            createCampaignModel?.platforms = values
//            goDown()
//        case .followers:
//            createCampaignModel?.minFollowers = Int(value)
//            goDown()
//        case .gender:
//            createCampaignModel?.gender = value
//            goDown()
//        case .category:
//            let values = value.components(separatedBy: ", ")
//            createCampaignModel?.categories = values
//            goDown()
//        default:
//            break
//        }
//    }
//
//    func selectedPayment(method: PaymentSelected, value: String) {
//        if method == .giveaway {
//            createCampaignModel?.barter = true
//            createCampaignModel?.barterDescription = value
//            createCampaignModel?.price = 0
//        } else {
//            createCampaignModel?.barter = nil
//            createCampaignModel?.barterDescription = nil
//            createCampaignModel?.price = Int(value)
//        }
//    }
//
//    func showErrorMeg(msg: String) {
//        showAlert(msg: msg)
//    }
//
//    func previewCampaign() {
//        print("preview")
//    }
//
//    func submitCampaign() {
//        startUploading { [weak self] in
//            var model = [CampaignImage]()
//            if let urls = self?.imageURLs {
//                for i in urls {
//                    model.append(CampaignImage(path: i, type: "image"))
//                }
//                self?.createCampaignModel?.blob = model
//            }
//            self?.uploadSponsership()
//        }
//    }
//
//    func uploadSponsership() {
//        let sponsorshipDocument = SPONSORSHIP_REF.document()
//        createCampaignModel?.campaignId = sponsorshipDocument.documentID
//        if let model = createCampaignModel?.toDictionary() {
//            sponsorshipDocument.setData(model, merge: true) { [weak self] (error) in
//                if let error = error {
//                    self?.showAlert(msg: error.localizedDescription)
//                }
//                if let id = model["campaignId"] as? String {
//                    SPONSORSHIP_REVIEW_REF.document(id).setData(model)
//                }
//            }
//        }
//    }
//
//    func startUploading(completion: @escaping FileCompletionBlock) {
//        if campaignImages.count == 0 {
//            completion()
//            return
//        }
//        block = completion
//    }
//
//    func uploadImage(for index: Int) {
//        if index < campaignImages.count {
//            if let data = campaignImages[index].jpegData(compressionQuality: 0.4) {
//                let fileName: String = UUID().uuidString + ".jpg"
//
//                FirebaseUploadImages.shared.upload(data: data, withName: fileName) { [weak self] (url) in
//                    if let path = url {
//                        self?.imageURLs.append(path)
//                    }
//                    self?.uploadImage(for: index + 1)
//                }
//            }
//            return
//        }
//        if block != nil {
//            block!()
//        }
//    }
//
//    func selectImages() {
//        var config = FMPhotoPickerConfig()
//        config.selectMode = .multiple
//        config.mediaTypes = [.image]
//        let picker = FMPhotoPickerViewController(config: config)
//        picker.delegate = self
//        present(picker, animated: true, completion: nil)
//    }
//
//    func textEntered(cellType: CampaignCell, value: String) {
//        switch cellType {
//        case .category:
//            let values = value.components(separatedBy: ", ")
//            createCampaignModel?.categories = values
//        default:
//            break
//        }
//    }
//
//    func openCategoryPage() {
//        let categoryController = CategoryViewController()
//        categoryController.delegate = self
//        if let selectedCategories = createCampaignModel?.categories {
//            categoryController.selectedCategories = selectedCategories
//        }
//        present(categoryController, animated: true, completion: nil)
//    }
//
//    func getCategories(categories: String) {
//        guard let cell = campaignCollectionVIew.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? ChooseCategoryCVCell else { return }
//        cell.categoryTF.text = categories
//        cell.categories = categories
//    }
//
//    func deleteCampaignImage(_ index: Int) {
//        campaignImages.remove(at: index)
//    }
//
//}
//
//extension CreateCampaignsController: FMPhotoPickerViewControllerDelegate {
//
//    func fmPhotoPickerController(_ picker: FMPhotoPickerViewController, didFinishPickingPhotoWith photos: [UIImage]) {
//        print(photos)
//        guard let cell = campaignCollectionVIew.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? UploadImagesCVCell else { return }
//        campaignImages.append(contentsOf: photos)
//        cell.images.append(contentsOf: photos)
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//}
//
//extension CreateCampaignsController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 9
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch indexPath.row {
//        case 0:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: campaignNameIdentifier, for: indexPath) as? CampaignNameCVCell else { return UICollectionViewCell() }
//            cell.delegate = self
//            return cell
//        case 1:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: describeCampaignIdentifier, for: indexPath) as? DescribeCampaignCVCell else { return UICollectionViewCell() }
//            cell.delegate = self
//            return cell
//        case 2:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: uploadImageCampaignIdentifier, for: indexPath) as? UploadImagesCVCell else { return UICollectionViewCell() }
//            cell.delegate = self
//            return cell
//        case 3:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: campaignPaymentIdentifier, for: indexPath) as? CampaignPaymentCVCell else { return UICollectionViewCell() }
//            cell.delegate = self
//            return cell
//        case 4:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: selectPlatformIdentifier, for: indexPath) as? SelectPlatformCVCell else { return UICollectionViewCell() }
//            cell.delegate = self
//            return cell
//        case 5:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: miniumFollowersIdentifier, for: indexPath) as? MinimumFollowersCVCell else { return UICollectionViewCell() }
//            cell.delegate = self
//            return cell
//        case 6:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: genderTargetIdentifier, for: indexPath) as? GenderTargetCVCell else { return UICollectionViewCell() }
//            cell.delegate = self
//            cell.genderTF.inputView = pickerView
//            cell.genderTF.inputAccessoryView = toolBar
//            return cell
//        case 7:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: chooseCategoryIdentifier, for: indexPath) as? ChooseCategoryCVCell else { return UICollectionViewCell() }
//            cell.delegate = self
//            return cell
//        case 8:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: previewIdentifier, for: indexPath) as? PreviewCampaignCVCell else { return UICollectionViewCell() }
//            cell.delegate = self
//            return cell
//        default:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: campaignNameIdentifier, for: indexPath) as? CampaignNameCVCell else { return UICollectionViewCell() }
//            return cell
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
//    }
//
//
//}
