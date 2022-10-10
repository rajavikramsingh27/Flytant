//
//  Protocols.swift
//  Flytant
//
//  Created by Vivek Rai on 02/07/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit

protocol ProfileHeaderDelegate {
    func handleEditFollowTapped(for header: ProfileHeader)
    func handleWebsiteTapped(for header: ProfileHeader)
    func handleFollowersTapped(for header: ProfileHeader)
    func handleFollowingTapped(for header: ProfileHeader)
}

protocol SocialProfileHeaderDelegate {
    func handleYoutubeButtonTapped(for header: SocialProfileHeader)
    func handleInstagram(for header: SocialProfileHeader)
    func handleYoutube(for header: SocialProfileHeader)
    func handleWebsiteTapped(for header: SocialProfileHeader)
    func handleFollowersTapped(for header: SocialProfileHeader)
    func handleFollowingTapped(for header: SocialProfileHeader)
    func handleEditProfileMessageButton(for header: SocialProfileHeader)
    func addCategoriesData(for cell: CategoriesCollectionViewCell, indexPath: IndexPath)
}

protocol FeedHeaderDelegate {
    func handlePost(for header: FeedHeader)
    func handleOpenGallery(for header: FeedHeader)
    func handleUserProfile(for header: FeedHeader)
    func handleStory(for cell: StoryCollectionViewCell, indexPath: IndexPath)
}

protocol UsersAroundHeaderDelegate {
    func handleSegmentedControl(for header: UsersAroundHeader, sender: UISegmentedControl)
    func handleShowmap(for header: UsersAroundHeader)
    func handleSlider(for header: UsersAroundHeader, sender: UISlider, event: UIEvent)
}
protocol ChatsHeaderDelegate{
    func handleChats(for header: ChatsHeader)
    func handleCalls(for header: ChatsHeader)
    func handleContacts(for header: ChatsHeader)
    func handleSettings(for header: ChatsHeader)
}

protocol ShopHeaderDeleagte {
    func handleEditShopWebsite(for header: UserShopHeader)
}

protocol CardViewDelegate {
    func saveSwipe(for view: CardView, didLike: Bool)
    func showProfile(for view: CardView, user: Users)
}

protocol SwipeHeaderDelegate {
    func handleSettings()
    func handleFindUsers()
}

protocol SwipeBottomDelegate {
    func handleLike()
    func handleDislike()
}
protocol SwipeSettingsHeaderDelegate {
    func handlePhotoPicker(for header: SwipeSettingsHeader, didSelect index: Int)
}

protocol SwipeSettingsDelegate {
    func handleUpdateUserInfo(for cell: SwipeSettingsTableViewCell, value: String, section: SwipeSettingsSection)
}

protocol SwipeSettingDelegate {
    func handleSave()
}

protocol MatchViewDelegate {
    func handleMessage(for view: MatchView, user: Users)
}

protocol FeedCellDelegate {
    func handleFollow(for cell: FeedCollectionViewCell)
    func handleUsernameTapped(for cell: FeedCollectionViewCell)
    func handleThreeDotTapped(for cell: FeedCollectionViewCell)
    func handleLikesTapped(for cell: FeedCollectionViewCell)
    func handleCommentsTapped(for cell: FeedCollectionViewCell)
    func handleLikesLabelTapped(for cell: FeedCollectionViewCell)
    func handleUpvotesTapped(for cell: FeedCollectionViewCell)
    func handleUpvotesLabelTapped(for cell: FeedCollectionViewCell)
    func handleDescriptionLabelTapped(for cell: FeedCollectionViewCell)
    func handleSlideShowTapped(for cell: FeedCollectionViewCell)
    func handleActiveLabelUsernameTapped(for cell: FeedCollectionViewCell, username: String)
}

protocol ShopFeedCellDelegate {
    func handleWebsiteButtonTapped(for cell: ShopFeedCollectionViewCell)
    func handleThreeDotTapped(for cell: ShopFeedCollectionViewCell)
    func handleShopNameTapped(for cell: ShopFeedCollectionViewCell)
    func handleSlideShowTapped(for cell: ShopFeedCollectionViewCell)
    func handleActiveLabelShopNameTapped(for cell: ShopFeedCollectionViewCell, shopName: String)
}

protocol ApplieCellDelegate {
    func handleMessage(for cell: AppliedCollectionViewCell)
    func handleProfile(for cell: AppliedCollectionViewCell)
}

protocol LikeCellDelegate {
    func handleFollow(for cell: LikesCollectionViewCell)
}

protocol DiscverCellDelegate {
    func handleFollow(for cell: DiscoverCollectionViewCell)
}

protocol FollowFollowersCellDelegate {
    func handleFollow(for cell: FollowFollowersCollectionViewCell)
}

protocol CommentCellDelegate {
    func handleUsernameTapped(for cell: CommentCollectionViewCell)
    func handleActiveLabelUsernameTapped(for cell: CommentCollectionViewCell, username: String)
}
protocol MessageCellDelegate {
    func configureUserData(for cell: MessageTableViewCell)
}

protocol ChatCellDelegate {
    func handlePlayVideo(for cell: ChatCollectionViewCell)
}

protocol NotificationCellDelegate {
    func handleFollowTapped(for cell: NotificationTableViewCell)
    func handlePostTapped(for cell: NotificationTableViewCell)
    func handleMessageTapped(for cell: NotificationTableViewCell)
}

protocol MessageInputAccesoryViewDelegate {
    func handleUploadMessage(message: String)
    func handleSelectImage()
}

protocol CommentInputAccesoryViewDelegate {
    func didSubmit(forComment comment: String)
}

protocol ExploreHeaderDelegate {
    func handleSelectedCategory(for cell: ExploreHeaderCollectionViewCell, indexPath: IndexPath)
    func handleSelectedCategoryTapped(for cell: ExploreHeaderCollectionViewCell, indexPath: IndexPath)
}

protocol InfluencersHeaderDelegate {
    func handleSearch(for cell: InfluencersHeader)
    func handleInlfluencers(for cell: InfluencersHeader, user: Users)
}


protocol CommentHeaderDelegate {
    func handleHeaderUsernameTapped(for cell: CommentHeader)
}

protocol AnonymousLoginViewDelegate {
    func handleCancel()
    func handleLogin()
}
protocol Printable {
    var description: String { get }
}
