//
//  Constants.swift
//  Flytant
//
//  Created by Vivek Rai on 30/06/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

// User Defauls

let AUTH_VERIFICATION_ID = "AUTH_VERIFICATION_ID"
let PHONE_NUMBER = "PHONE_NUMBER"
let USERNAME = "USERNAME"
let USER_ID = "USER_ID"
let BIO = "BIO"
let DATE_OF_BIRTH = "DATE_OF_BIRTH"
let EMAIL = "EMAIL"
let GENDER = "GENDER"
let NAME = "NAME"
let SWIPE_IMAGE_URLS = "SWIPE_IMAGE_URLS"
let YOUTUBE_ID = "YOUTUBE_ID"
let TWITTER_ID = "TWITTER_ID"
let CATEGORIES = "CATEGORIES"
let PROFILE_IMAGE_URL = "PROFILE_IMAGE_URL"
let LATITUDE_USERLOCATION = "LATITUDE_USERLOCATION"
let LONGITUDE_USERLOCATION = "LONGITUDE_USERLOCATION"
let WEBSITE = "WEBSITE"
let SHOP_ICON_URL = "SHOP_ICON_URL"
let SHOP_BANNER_URL = "SHOP_BANNER_URL"
let SHOP_NAME = "SHOP_NAME"
let SHOP_WEBSITE = "SHOP_WEBSITE"
let CHAT_BACKGROUND = "CHAT_BACKGROUND"
let UPVOTE_CREDITS = "UPVOTE_CREDITS"
let POST_INTERACTED = "POST_INTERACTED"
// Firebase References

let DB_REF = Firestore.firestore()
let RDB_REF = Database.database().reference()
let SPONSORSHIP_REF = DB_REF.collection("sponsorship")
let SLIDER_REF = DB_REF.collection("slider")
let SPONSORSHIP_REVIEW_REF = DB_REF.collection("sponsorshipReview")
let USER_REF = DB_REF.collection("users")
let POST_REF = DB_REF.collection("posts")
let SHOP_REF = DB_REF.collection("shop")
let SHOP_POST_REF = DB_REF.collection("shopPosts")
let COMMENT_REF = DB_REF.collection("comments")
let RECENT_CHAT_REF = DB_REF.collection("recentChats")
let MESSAGE_REF = DB_REF.collection("messages")
let NOTIFICATIONS_REF = DB_REF.collection("notifications")
let CALL_REF = DB_REF.collection("calls")
let STORY_REF = DB_REF.collection("story")
let SWIPES_REF = DB_REF.collection("swipes")
let PAYMENT_REF = DB_REF.collection("payments")
let TYPING_REF = DB_REF.collection("typing")
let GEO_REF = DB_REF.collection("geoLocations")
let HASHTAG_POST_REF = DB_REF.collection("hashtagPosts")
let HASHTAG_SHOP_POST_REF = DB_REF.collection("shopHashtagPosts")
let REPORT_POST_REF = DB_REF.collection("reportedPosts")
let REPORT_REF = DB_REF.collection("report")
let HELP_REF = DB_REF.collection("help")
let FOLLOWERS_REF = DB_REF.collection("followers")
let FOLLOWING_REF = DB_REF.collection("following")
let MESSAGES_REF = RDB_REF.child("messages")
let USER_MESSAGES_REF = RDB_REF.child("userMessages")
//let NOTIFICATIONS_REF = RDB_REF.child("notifications")
let LIKES_REF = RDB_REF.child("likes")
let STORAGE_REF = Storage.storage().reference()
let STORAGE_REF_PROFILE_IMAGES = STORAGE_REF.child("profile_images")
let STORAGE_REF_POST_IMAGES = STORAGE_REF.child("post_images")
let STORAGE_REF_CAMPAIGN_IMAGES = STORAGE_REF.child("sponsor_campaign_images")
let SWIPE_USER_IMAGES = STORAGE_REF.child("SwipeUserImages")
let STORAGE_MESSAGE_VIDEO_REF = STORAGE_REF.child("video_messages")
let STORAGE_MESSAGE_IMAGES_REF = STORAGE_REF.child("message_images")
let STORAGE_REF_SHOP_IMAGES = STORAGE_REF.child("shop_images")
let STORAGE_REF_SHOP_POST_IMAGES = STORAGE_REF.child("shop_posts")
let STORAGE_REF_STORY = STORAGE_REF.child("story")
let STORAGE_REF_SPONSOR_CAMPAIGN_VIDEOS = STORAGE_REF.child("sponsor_campaign_videos")
let STORAGE_REF_SPONSOR_CAMPAIGN_IMAGES = STORAGE_REF.child("sponsor_campaign_images")

// URLS

let DEFAULT_PROFILE_IMAGE_URL = "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/profile_images%2Fdefault_user_image.png?alt=media&token=45511585-2c3d-4997-a735-8a5f2073073d"
let DEFAULT_SHOP_ICON_URL = "https://firebasestorage.googleapis.com/v0/b/flytant-app.appspot.com/o/shop_images%2Fsnbssnsnsknsknksksknks.png?alt=media&token=26adeac4-7921-4ec4-8a62-a0d87388ecce"

// Notifiation Centre

let RELOAD_PROFILE_DATA = "RELOAD_PROFILE_DATA"
let RELOAD_SHOP_DATA = "RELOAD_SHOP_DATA"

// Notifications

let LIKE_INT_VALUE = 0
let COMMENT_INT_VALUE = 1
let FOLLOW_INT_VALUE = 2
let COMMENT_MENTION_INT_VALUE = 3
let POST_MENTION_INT_VALUE = 4


// Chats

let PRIVATE_CHAT = "privateChat"
let GROUP_CHAT = "groupChat"
let TYPE = "type"
let WITH_USERNAME = "withUsername"
let CHAT_ROOM_ID = "chatRoomId"
let RECENT_ID = "recentId"
let USERID = "userId"
let MEMBERS = "members"
let MEMBERS_TO_PUSH = "membersToPush"
let WITH_USER_ID = "withUserId"
let LAST_MESSAGE = "lastMessage"
let COUNTER = "counter"
let CREATION_DATE = "creationDate"
let CHAT_IMAGE_URL = "chatImageUrl"

// Messages
let NUMBER_OF_MESSAGES = 10
 
// Video
let SUCCESS = 2
let MAX_DURATION = 120.0

// Audio
let AUDIO_MAX_DURATION = 120.0

// Sinch
let SINCH_KEY = "ceb5f06e-898d-4749-94df-57bd1d344246"
let SINCH_SECRET = "R7mCDxfP1kW0gLiyZ+VDNw=="
