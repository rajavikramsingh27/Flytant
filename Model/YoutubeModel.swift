//
//  YoutubeModel.swift
//  Flytant
//
//  Created by Flytant on 28/09/21.
//  Copyright © 2021 Vivek Rai. All rights reserved.
//

import Foundation


struct FirebaseYoutubeModel {
    var channelId: String?
    var socialScore: Int?
    
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        if channelId != nil {
            dict["channelId"] = channelId
        }
        if socialScore != nil {
            dict["socialScore"] = socialScore
        }
        return dict
    }
}



//MARK: - YoutubeVideoStatsModel
struct YoutubeVideoStatsModel: Codable {
    var kind: String?
    var etag: String?
    var items: [Item]?
    var pageInfo: YoutubePageInfo?
    
    enum CodingKeys: String, CodingKey {
        case kind = "kind"
        case etag = "etag"
        case pageInfo = "pageInfo"
        case items = "items"
    }
    
}

// MARK: - YoutubeVideoModel
struct YoutubeVideoModel: Codable {
    var kind: String?
    var etag: String?
    var regionCode: String?
    var pageInfo: YoutubePageInfo?
    var items: [YoutubeVideoItem]?

    enum CodingKeys: String, CodingKey {
        case kind = "kind"
        case etag = "etag"
        case regionCode = "regionCode"
        case pageInfo = "pageInfo"
        case items = "items"
    }
}

// MARK: - ID
struct ID: Codable {
    var kind: String?
    var videoID: String?

    enum CodingKeys: String, CodingKey {
        case kind = "kind"
        case videoID = "videoId"
    }
}

// MARK: - Snippet
struct Snippet: Codable {
    var publishedAt: String?
    var channelID: String?
    var title: String?
    var snippetDescription: String?
    var thumbnails: Thumbnails?
    var channelTitle: String?
    var liveBroadcastContent: String?
    var publishTime: String?

    enum CodingKeys: String, CodingKey {
        case publishedAt = "publishedAt"
        case channelID = "channelId"
        case title = "title"
        case snippetDescription = "description"
        case thumbnails = "thumbnails"
        case channelTitle = "channelTitle"
        case liveBroadcastContent = "liveBroadcastContent"
        case publishTime = "publishTime"
    }
}

// MARK: - Default
struct Default: Codable {
    var url: String?
    var width: Int?
    var height: Int?

    enum CodingKeys: String, CodingKey {
        case url = "url"
        case width = "width"
        case height = "height"
    }
}

// MARK: - YoutubeChannelModel
struct YoutubeChannelModel: Codable {
    var kind: String?
    var etag: String?
    var pageInfo: YoutubePageInfo?
    var items: [Item]?

    enum CodingKeys: String, CodingKey {
        case kind = "kind"
        case etag = "etag"
        case pageInfo = "pageInfo"
        case items = "items"
    }
}

// MARK: - YoutubeVideoItem
struct YoutubeVideoItem: Codable {
    var kind: String?
    var etag: String?
    var id: ID?
    var snippet: Snippet?
    var contentDetails: ContentDetails?
    var statistics: Statistics?

    enum CodingKeys: String, CodingKey {
        case kind = "kind"
        case etag = "etag"
        case id = "id"
        case snippet = "snippet"
        case contentDetails = "contentDetails"
        case statistics = "statistics"
    }
}

// MARK: - Item
struct Item: Codable {
    var kind: String?
    var etag: String?
    var id: String?
    var snippet: Snippet?
    var contentDetails: ContentDetails?
    var statistics: Statistics?

    enum CodingKeys: String, CodingKey {
        case kind = "kind"
        case etag = "etag"
        case id = "id"
        case snippet = "snippet"
        case contentDetails = "contentDetails"
        case statistics = "statistics"
    }
}

// MARK: - ContentDetails
struct ContentDetails: Codable {
    var relatedPlaylists: RelatedPlaylists?

    enum CodingKeys: String, CodingKey {
        case relatedPlaylists = "relatedPlaylists"
    }
}

// MARK: - RelatedPlaylists
struct RelatedPlaylists: Codable {
    var likes: String?
    var uploads: String?

    enum CodingKeys: String, CodingKey {
        case likes = "likes"
        case uploads = "uploads"
    }
}

// MARK: - Localized
struct Localized: Codable {
    var title: String?
    var localizedDescription: String?

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case localizedDescription = "description"
    }
}

// MARK: - Thumbnails
struct Thumbnails: Codable {
    var thumbnailsDefault: Default?
    var medium: Default?
    var high: Default?

    enum CodingKeys: String, CodingKey {
        case thumbnailsDefault = "default"
        case medium = "medium"
        case high = "high"
    }
}


// MARK: - Statistics
struct Statistics: Codable {
    var viewCount: String?
    var subscriberCount: String?
    var hiddenSubscriberCount: Bool?
    var videoCount: String?
    var likeCount: String?
    var dislikeCount: String?
    var favouriteCount: String?
    var commentCount: String?

    enum CodingKeys: String, CodingKey {
        case viewCount = "viewCount"
        case subscriberCount = "subscriberCount"
        case hiddenSubscriberCount = "hiddenSubscriberCount"
        case videoCount = "videoCount"
        case likeCount = "likeCount"
        case dislikeCount = "dislikeCount"
        case favouriteCount = "favouriteCount"
        case commentCount = "commentCount"
    }
}


// MARK: - Statistics
struct ChannelStatistics: Codable {
    var viewCount: String?
    var subscriberCount: String?
    var hiddenSubscriberCount: Bool?
    var videoCount: String?

    enum CodingKeys: String, CodingKey {
        case viewCount = "viewCount"
        case subscriberCount = "subscriberCount"
        case hiddenSubscriberCount = "hiddenSubscriberCount"
        case videoCount = "videoCount"
    }
}

// MARK: - PageInfo
struct YoutubePageInfo: Codable {
    var totalResults: Int?
    var resultsPerPage: Int?

    enum CodingKeys: String, CodingKey {
        case totalResults = "totalResults"
        case resultsPerPage = "resultsPerPage"
    }
}
