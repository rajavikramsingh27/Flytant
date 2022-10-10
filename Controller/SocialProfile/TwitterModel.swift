//
//  TwitterDataModel.swift
//  Flytantapp
//
//  Created by Vivek Singh Mehta on 02/10/21.
//

import Foundation

// MARK: - TwitterStatsModel
struct TwitterStatsModel: Codable {
    var data: [TwitterStatsData]?

    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

// MARK: - TwitterStatsData
struct TwitterStatsData: Codable {
    var name: String?
    var id: String?
    var username: String?
    var profileImageURL: String?
    var publicMetrics: PublicMetrics?
    var createdAt: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
        case username = "username"
        case profileImageURL = "profile_image_url"
        case publicMetrics = "public_metrics"
        case createdAt = "created_at"
    }
}

// MARK: - PublicMetrics
struct PublicMetrics: Codable {
    var followersCount: Int?
    var followingCount: Int?
    var tweetCount: Int?
    var listedCount: Int?

    enum CodingKeys: String, CodingKey {
        case followersCount = "followers_count"
        case followingCount = "following_count"
        case tweetCount = "tweet_count"
        case listedCount = "listed_count"
    }
}


struct TwitterDataModel: Codable {
    var data: TwitterData?
    
    enum CodingKeys: String, CodingKey {
            case data = "data"
        }
}


struct TwitterData: Codable {
    var id: String?
    var name: String?
    var username: String?
    
    enum CodingKeys: String, CodingKey {
            case id = "id"
            case name = "name"
            case username = "username"
        }
}


// MARK: - TwitterTweetModel
struct TwitterTweetModel: Codable {
    var createdAt: String?
    var id: Double?
    var idStr: String?
    var text: String?
    var truncated: Bool?
    var entities: TwitterTweetModelEntities?
    var source: String?
    var inReplyToStatusID: Double?
    var inReplyToStatusIDStr: String?
    var inReplyToUserID: Double?
    var inReplyToUserIDStr: String?
    var inReplyToScreenName: String?
    var user: QuotedStatusUser?
    var isQuoteStatus: Bool?
    var retweetCount: Int?
    var favoriteCount: Int?
    var favorited: Bool?
    var retweeted: Bool?
    var lang: String?
    var retweetedStatus: RetweetedStatus?
    var possiblySensitive: Bool?
    var extendedEntities: TwitterTweetModelExtendedEntities?
    var quotedStatusID: Double?
    var quotedStatusIDStr: String?
    var quotedStatus: QuotedStatus?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case id = "id"
        case idStr = "id_str"
        case text = "text"
        case truncated = "truncated"
        case entities = "entities"
        case source = "source"
        case inReplyToStatusID = "in_reply_to_status_id"
        case inReplyToStatusIDStr = "in_reply_to_status_id_str"
        case inReplyToUserID = "in_reply_to_user_id"
        case inReplyToUserIDStr = "in_reply_to_user_id_str"
        case inReplyToScreenName = "in_reply_to_screen_name"
        case user = "user"
        case isQuoteStatus = "is_quote_status"
        case retweetCount = "retweet_count"
        case favoriteCount = "favorite_count"
        case favorited = "favorited"
        case retweeted = "retweeted"
        case lang = "lang"
        case retweetedStatus = "retweeted_status"
        case possiblySensitive = "possibly_sensitive"
        case extendedEntities = "extended_entities"
        case quotedStatusID = "quoted_status_id"
        case quotedStatusIDStr = "quoted_status_id_str"
        case quotedStatus = "quoted_status"
    }
}

// MARK: - TwitterTweetModelEntities
struct TwitterTweetModelEntities: Codable {
    var hashtags: [Hashtag]?
    var userMentions: [UserMention]?
    var urls: [URLElement]?
    var media: [EntitiesMedia]?

    enum CodingKeys: String, CodingKey {
        case hashtags = "hashtags"
        case userMentions = "user_mentions"
        case urls = "urls"
        case media = "media"
    }
}

// MARK: - Hashtag
struct Hashtag: Codable {
    var text: String?
    var indices: [Int]?

    enum CodingKeys: String, CodingKey {
        case text = "text"
        case indices = "indices"
    }
}

// MARK: - EntitiesMedia
struct EntitiesMedia: Codable {
    var id: Double?
    var idStr: String?
    var indices: [Int]?
    var mediaURL: String?
    var mediaURLHTTPS: String?
    var url: String?
    var displayURL: String?
    var expandedURL: String?
    var type: TypeEnum?
    var sizes: Sizes?
    var sourceStatusID: Double?
    var sourceStatusIDStr: String?
    var sourceUserID: Double?
    var sourceUserIDStr: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case idStr = "id_str"
        case indices = "indices"
        case mediaURL = "media_url"
        case mediaURLHTTPS = "media_url_https"
        case url = "url"
        case displayURL = "display_url"
        case expandedURL = "expanded_url"
        case type = "type"
        case sizes = "sizes"
        case sourceStatusID = "source_status_id"
        case sourceStatusIDStr = "source_status_id_str"
        case sourceUserID = "source_user_id"
        case sourceUserIDStr = "source_user_id_str"
    }
}

// MARK: - Sizes
struct Sizes: Codable {
    var thumb: Large?
    var small: Large?
    var medium: Large?
    var large: Large?

    enum CodingKeys: String, CodingKey {
        case thumb = "thumb"
        case small = "small"
        case medium = "medium"
        case large = "large"
    }
}

// MARK: - Large
struct Large: Codable {
    var w: Int?
    var h: Int?
    var resize: Resize?

    enum CodingKeys: String, CodingKey {
        case w = "w"
        case h = "h"
        case resize = "resize"
    }
}

enum Resize: String, Codable {
    case crop = "crop"
    case fit = "fit"
}

enum TypeEnum: String, Codable {
    case photo = "photo"
    case video = "video"
}

// MARK: - URLElement
struct URLElement: Codable {
    var url: String?
    var expandedURL: String?
    var displayURL: String?
    var indices: [Int]?

    enum CodingKeys: String, CodingKey {
        case url = "url"
        case expandedURL = "expanded_url"
        case displayURL = "display_url"
        case indices = "indices"
    }
}

// MARK: - UserMention
struct UserMention: Codable {
    var screenName: String?
    var name: String?
    var id: Double?
    var idStr: String?
    var indices: [Int]?

    enum CodingKeys: String, CodingKey {
        case screenName = "screen_name"
        case name = "name"
        case id = "id"
        case idStr = "id_str"
        case indices = "indices"
    }
}

// MARK: - TwitterTweetModelExtendedEntities
struct TwitterTweetModelExtendedEntities: Codable {
    var media: [PurpleMedia]?

    enum CodingKeys: String, CodingKey {
        case media = "media"
    }
}

// MARK: - PurpleMedia
struct PurpleMedia: Codable {
    var id: Double?
    var idStr: String?
    var indices: [Int]?
    var mediaURL: String?
    var mediaURLHTTPS: String?
    var url: String?
    var displayURL: String?
    var expandedURL: String?
    var type: TypeEnum?
    var sizes: Sizes?
    var sourceStatusID: Double?
    var sourceStatusIDStr: String?
    var sourceUserID: Double?
    var sourceUserIDStr: String?
    var videoInfo: VideoInfo?
    var additionalMediaInfo: AdditionalMediaInfo?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case idStr = "id_str"
        case indices = "indices"
        case mediaURL = "media_url"
        case mediaURLHTTPS = "media_url_https"
        case url = "url"
        case displayURL = "display_url"
        case expandedURL = "expanded_url"
        case type = "type"
        case sizes = "sizes"
        case sourceStatusID = "source_status_id"
        case sourceStatusIDStr = "source_status_id_str"
        case sourceUserID = "source_user_id"
        case sourceUserIDStr = "source_user_id_str"
        case videoInfo = "video_info"
        case additionalMediaInfo = "additional_media_info"
    }
}

// MARK: - AdditionalMediaInfo
struct AdditionalMediaInfo: Codable {
    var title: String?
    var additionalMediaInfoDescription: String?
    var embeddable: Bool?
    var monetizable: Bool?
    var sourceUser: SourceUserClass?

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case additionalMediaInfoDescription = "description"
        case embeddable = "embeddable"
        case monetizable = "monetizable"
        case sourceUser = "source_user"
    }
}


// MARK: - VisitSite
struct VisitSite: Codable {
    var url: String?

    enum CodingKeys: String, CodingKey {
        case url = "url"
    }
}

// MARK: - SourceUserClass
struct SourceUserClass: Codable {
    var id: Double?
    var idStr: String?
    var name: String?
    var screenName: String?
    var location: String?
    var userDescription: String?
    var url: String?
    var protected: Bool?
    var followersCount: Int?
    var friendsCount: Int?
    var listedCount: Int?
    var createdAt: String?
    var favouritesCount: Int?
    var geoEnabled: Bool?
    var verified: Bool?
    var statusesCount: Int?
    var contributorsEnabled: Bool?
    var isTranslator: Bool?
    var isTranslationEnabled: Bool?
    var profileBackgroundColor: String?
    var profileBackgroundImageURL: String?
    var profileBackgroundImageURLHTTPS: String?
    var profileBackgroundTile: Bool?
    var profileImageURL: String?
    var profileImageURLHTTPS: String?
    var profileBannerURL: String?
    var profileLinkColor: String?
    var profileSidebarBorderColor: String?
    var profileSidebarFillColor: String?
    var profileTextColor: String?
    var profileUseBackgroundImage: Bool?
    var hasExtendedProfile: Bool?
    var defaultProfile: Bool?
    var defaultProfileImage: Bool?
    var following: Bool?
    var followRequestSent: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case idStr = "id_str"
        case name = "name"
        case screenName = "screen_name"
        case location = "location"
        case userDescription = "description"
        case url = "url"
        case protected = "protected"
        case followersCount = "followers_count"
        case friendsCount = "friends_count"
        case listedCount = "listed_count"
        case createdAt = "created_at"
        case favouritesCount = "favourites_count"
        case geoEnabled = "geo_enabled"
        case verified = "verified"
        case statusesCount = "statuses_count"
        case contributorsEnabled = "contributors_enabled"
        case isTranslator = "is_translator"
        case isTranslationEnabled = "is_translation_enabled"
        case profileBackgroundColor = "profile_background_color"
        case profileBackgroundImageURL = "profile_background_image_url"
        case profileBackgroundImageURLHTTPS = "profile_background_image_url_https"
        case profileBackgroundTile = "profile_background_tile"
        case profileImageURL = "profile_image_url"
        case profileImageURLHTTPS = "profile_image_url_https"
        case profileBannerURL = "profile_banner_url"
        case profileLinkColor = "profile_link_color"
        case profileSidebarBorderColor = "profile_sidebar_border_color"
        case profileSidebarFillColor = "profile_sidebar_fill_color"
        case profileTextColor = "profile_text_color"
        case profileUseBackgroundImage = "profile_use_background_image"
        case hasExtendedProfile = "has_extended_profile"
        case defaultProfile = "default_profile"
        case defaultProfileImage = "default_profile_image"
        case following = "following"
        case followRequestSent = "follow_request_sent"
    }
}

// MARK: - DescriptionClass
struct DescriptionClass: Codable {
    var urls: [URLElement]?

    enum CodingKeys: String, CodingKey {
        case urls = "urls"
    }
}

// MARK: - VideoInfo
struct VideoInfo: Codable {
    var aspectRatio: [Int]?
    var durationMillis: Int?
    var variants: [Variant]?

    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case durationMillis = "duration_millis"
        case variants = "variants"
    }
}

// MARK: - Variant
struct Variant: Codable {
    var bitrate: Int?
    var contentType: String?
    var url: String?

    enum CodingKeys: String, CodingKey {
        case bitrate = "bitrate"
        case contentType = "content_type"
        case url = "url"
    }
}


// MARK: - QuotedStatus
struct QuotedStatus: Codable {
    var createdAt: String?
    var id: Double?
    var idStr: String?
    var text: String?
    var truncated: Bool?
    var entities: TwitterTweetModelEntities?
    var source: String?
    var user: QuotedStatusUser?
    var isQuoteStatus: Bool?
    var quotedStatusID: Double?
    var quotedStatusIDStr: String?
    var retweetCount: Int?
    var favoriteCount: Int?
    var favorited: Bool?
    var retweeted: Bool?
    var possiblySensitive: Bool?
    var lang: String?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case id = "id"
        case idStr = "id_str"
        case text = "text"
        case truncated = "truncated"
        case entities = "entities"
        case source = "source"
        case user = "user"
        case isQuoteStatus = "is_quote_status"
        case quotedStatusID = "quoted_status_id"
        case quotedStatusIDStr = "quoted_status_id_str"
        case retweetCount = "retweet_count"
        case favoriteCount = "favorite_count"
        case favorited = "favorited"
        case retweeted = "retweeted"
        case possiblySensitive = "possibly_sensitive"
        case lang = "lang"
    }
}

// MARK: - QuotedStatusUser
struct QuotedStatusUser: Codable {
    var id: Double?
    var idStr: String?
    var name: String?
    var screenName: String?
    var location: String?
    var userDescription: String?
    var protected: Bool?
    var followersCount: Int?
    var friendsCount: Int?
    var listedCount: Int?
    var createdAt: String?
    var favouritesCount: Int?
    var geoEnabled: Bool?
    var verified: Bool?
    var statusesCount: Int?
    var contributorsEnabled: Bool?
    var isTranslator: Bool?
    var isTranslationEnabled: Bool?
    var profileBackgroundColor: String?
    var profileBackgroundImageURL: String?
    var profileBackgroundImageURLHTTPS: String?
    var profileBackgroundTile: Bool?
    var profileImageURL: String?
    var profileImageURLHTTPS: String?
    var profileLinkColor: String?
    var profileSidebarBorderColor: String?
    var profileSidebarFillColor: String?
    var profileTextColor: String?
    var profileUseBackgroundImage: Bool?
    var hasExtendedProfile: Bool?
    var defaultProfile: Bool?
    var defaultProfileImage: Bool?
    var following: Bool?
    var followRequestSent: Bool?
    var notifications: Bool?
    var profileBannerURL: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case idStr = "id_str"
        case name = "name"
        case screenName = "screen_name"
        case location = "location"
        case userDescription = "description"
        case protected = "protected"
        case followersCount = "followers_count"
        case friendsCount = "friends_count"
        case listedCount = "listed_count"
        case createdAt = "created_at"
        case favouritesCount = "favourites_count"
        case geoEnabled = "geo_enabled"
        case verified = "verified"
        case statusesCount = "statuses_count"
        case contributorsEnabled = "contributors_enabled"
        case isTranslator = "is_translator"
        case isTranslationEnabled = "is_translation_enabled"
        case profileBackgroundColor = "profile_background_color"
        case profileBackgroundImageURL = "profile_background_image_url"
        case profileBackgroundImageURLHTTPS = "profile_background_image_url_https"
        case profileBackgroundTile = "profile_background_tile"
        case profileImageURL = "profile_image_url"
        case profileImageURLHTTPS = "profile_image_url_https"
        case profileLinkColor = "profile_link_color"
        case profileSidebarBorderColor = "profile_sidebar_border_color"
        case profileSidebarFillColor = "profile_sidebar_fill_color"
        case profileTextColor = "profile_text_color"
        case profileUseBackgroundImage = "profile_use_background_image"
        case hasExtendedProfile = "has_extended_profile"
        case defaultProfile = "default_profile"
        case defaultProfileImage = "default_profile_image"
        case following = "following"
        case followRequestSent = "follow_request_sent"
        case notifications = "notifications"
        case profileBannerURL = "profile_banner_url"
    }
}

// MARK: - PurpleEntities
struct PurpleEntities: Codable {
    var entitiesDescription: DescriptionClass?

    enum CodingKeys: String, CodingKey {
        case entitiesDescription = "description"
    }
}


// MARK: - RetweetedStatus
struct RetweetedStatus: Codable {
    var createdAt: String?
    var id: Double?
    var idStr: String?
    var text: String?
    var truncated: Bool?
    var entities: TwitterTweetModelEntities?
    var source: String?
    var user: SourceUserClass?
    var isQuoteStatus: Bool?
    var retweetCount: Int?
    var favoriteCount: Int?
    var favorited: Bool?
    var retweeted: Bool?
    var possiblySensitive: Bool?
    var lang: String?
    var extendedEntities: RetweetedStatusExtendedEntities?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case id = "id"
        case idStr = "id_str"
        case text = "text"
        case truncated = "truncated"
        case entities = "entities"
        case source = "source"
        case user = "user"
        case isQuoteStatus = "is_quote_status"
        case retweetCount = "retweet_count"
        case favoriteCount = "favorite_count"
        case favorited = "favorited"
        case retweeted = "retweeted"
        case possiblySensitive = "possibly_sensitive"
        case lang = "lang"
        case extendedEntities = "extended_entities"
    }
}

// MARK: - RetweetedStatusExtendedEntities
struct RetweetedStatusExtendedEntities: Codable {
    var media: [FluffyMedia]?

    enum CodingKeys: String, CodingKey {
        case media = "media"
    }
}

// MARK: - FluffyMedia
struct FluffyMedia: Codable {
    var id: Double?
    var idStr: String?
    var indices: [Int]?
    var mediaURL: String?
    var mediaURLHTTPS: String?
    var url: String?
    var displayURL: String?
    var expandedURL: String?
    var type: String?
    var sizes: Sizes?
    var videoInfo: VideoInfo?
    var additionalMediaInfo: AdditionalMediaInfo?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case idStr = "id_str"
        case indices = "indices"
        case mediaURL = "media_url"
        case mediaURLHTTPS = "media_url_https"
        case url = "url"
        case displayURL = "display_url"
        case expandedURL = "expanded_url"
        case type = "type"
        case sizes = "sizes"
        case videoInfo = "video_info"
        case additionalMediaInfo = "additional_media_info"
    }
}





//struct TwitterTweetModel: Codable {
//    var createdAt: String?
//    var id: Int?
//    var text: String?
//    var entities: TwitterTweetModelEntities?
//    var retweetCount: Int?
//    var favoriteCount: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case createdAt = "created_at"
//        case id = "id"
//        case text = "text"
//        case entities = "entities"
//        case retweetCount = "retweet_count"
//        case favoriteCount = "favorite_count"
//    }
//}
//
//struct TwitterTweetModelEntities: Codable {
//    var media: [Media]?
//
//    enum CodingKeys: String, CodingKey {
//        case media = "media"
//    }
//}
//
//
//struct RetweetedStatus: Codable {
//    var createdAt: String?
//    var id: Int?
//    var text: String?
//
//
//    enum CodingKeys: String, CodingKey {
//        case createdAt = "created_at"
//        case id = "id"
//        case text = "text"
//    }
//}
//
//
//// MARK: - TwitterTweetModel
//struct Media: Codable {
//    var id: Double?
//    var idStr: String?
//    var indices: [Int]?
//    var mediaURL: String?
//    var mediaURLHTTPS: String?
//    var url: String?
//    var displayURL: String?
//    var expandedURL: String?
//    var type: String?
//    var sizes: Sizes?
//
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case idStr = "id_str"
//        case indices = "indices"
//        case mediaURL = "media_url"
//        case mediaURLHTTPS = "media_url_https"
//        case url = "url"
//        case displayURL = "display_url"
//        case expandedURL = "expanded_url"
//        case type = "type"
//        case sizes = "sizes"
//    }
//}
//
//// MARK: - Sizes
//struct Sizes: Codable {
//    var thumb: Large?
//    var small: Large?
//    var medium: Large?
//    var large: Large?
//
//    enum CodingKeys: String, CodingKey {
//        case thumb = "thumb"
//        case small = "small"
//        case medium = "medium"
//        case large = "large"
//    }
//}
//
//// MARK: - Large
//struct Large: Codable {
//    var w: Int?
//    var h: Int?
//    var resize: String?
//
//    enum CodingKeys: String, CodingKey {
//        case w = "w"
//        case h = "h"
//        case resize = "resize"
//    }
//}
