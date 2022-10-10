//
//  mainTableViewCell.swift
//  DynamicTableView
//

//

import UIKit
import Firebase

class mainTableViewCell: UITableViewCell{
    
    weak var viewAlldelegate: SponsorshipViewCellDelegate?
    
    var sponsorshipTableCellModel  = [Sponsorships]()
    var sponsorshipTableCellQueryArray = [Query]()
    var sponsorshipTableCellHeaderArray = [String]()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    func commonInit(){
        
        contentView.addSubview(collectionView)
        updateConstraints()
    }
    
    override func updateConstraints() {
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10),
        ])
        super.updateConstraints()
    }
    
    //    let list = [String](repeating: "Task_", count: 10)
    //
    //    public let label: UILabel = {
    //        let v = UILabel()
    //        v.textAlignment = .center
    //        return v
    //    }()
    
    public lazy var collectionView: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset.bottom = 5
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = .clear
        v.register(TableCollectionViewCell.self, forCellWithReuseIdentifier: "TableCollectionViewCell")
        
        v.register(SponshorshipCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "SponshorshipCollectionReusableView")
        v.showsHorizontalScrollIndicator = false
        v.delegate = self
        v.dataSource = self
        v.isScrollEnabled = true
        
        return v
    }()
    
    
    func reloadCollectionView(){
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    
    
}
extension mainTableViewCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sponsorshipTableCellModel.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TableCollectionViewCell", for: indexPath) as! TableCollectionViewCell
        
        cell.platformImageView.removeArrangedSubview( cell.platformImageView1)
        cell.platformImageView1.isHidden = true
        cell.platformImageView.removeArrangedSubview( cell.platformImageView2)
        cell.platformImageView2.isHidden = true
        cell.platformImageView.removeArrangedSubview( cell.platformImageView3)
        cell.platformImageView3.isHidden = true
        cell.platformImageView.removeArrangedSubview( cell.platformImageView4)
        cell.platformImageView4.isHidden = true
        cell.platformImageView.removeArrangedSubview( cell.platformImageView5)
        cell.platformImageView5.isHidden = true
        
        cell.setUpSponsorCell(model: sponsorshipTableCellModel[indexPath.item])
        
        cell.platform(sponsorshipTableCellModel[indexPath.item].platforms)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(sponsorshipTableCellModel[indexPath.item].platforms)
        
        let vc = CampaignDetailViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.sponsorship = Sponsorships(userId: sponsorshipTableCellModel[indexPath.row].userId, price: sponsorshipTableCellModel[indexPath.row].price, platforms: sponsorshipTableCellModel[indexPath.row].platforms, name: sponsorshipTableCellModel[indexPath.row].name, gender: sponsorshipTableCellModel[indexPath.row].gender, minFollowers: sponsorshipTableCellModel[indexPath.row].minFollowers, description: sponsorshipTableCellModel[indexPath.row].description, currency: sponsorshipTableCellModel[indexPath.row].currency, creationDate: Double(sponsorshipTableCellModel[indexPath.row].creationDate.timeIntervalSince1970), influencers: sponsorshipTableCellModel[indexPath.row].influencers, categories: sponsorshipTableCellModel[indexPath.row].categories, campaignId: sponsorshipTableCellModel[indexPath.row].campaignId, isApproved: sponsorshipTableCellModel[indexPath.row].isApproved, selectedUsers: sponsorshipTableCellModel[indexPath.row].selectedUsers, blob: sponsorshipTableCellModel[indexPath.row].blob)
        self.next(ofType: SponsorshipViewController.self)?.present(vc, animated: false, completion: nil)
    }
}
extension mainTableViewCell: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionFooter {
            
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "SponshorshipCollectionReusableView", for: indexPath) as! SponshorshipCollectionReusableView
            // Customize footerView here
            
            if sponsorshipTableCellModel.count == 10 {
                footerView.ViewMoreButton.isHidden = false
            }
            else{
                footerView.ViewMoreButton.isHidden = true
            }
            footerView.ViewMoreButton.tag = collectionView.tag
            footerView.ViewMoreButton.addTarget(self, action: #selector(viewmoreclicked), for: .touchUpInside)
            
            
            return footerView
        }
        fatalError("Unexpected kind")
        
    }
    
    @objc func viewmoreclicked(sender:AnyObject){
        let index = sender.tag!
        
        viewAlldelegate?.viewAllTap(query: sponsorshipTableCellQueryArray[index], title: sponsorshipTableCellHeaderArray[index])

 
    }
    
}
extension mainTableViewCell: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2-15, height: collectionView.frame.height-5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if sponsorshipTableCellModel.count == 10 {
            return CGSize(width: collectionView.frame.width/2+20, height: collectionView.frame.height-80)
        }
        
        return CGSize(width:0,height: 0)
        
    }
    
}
