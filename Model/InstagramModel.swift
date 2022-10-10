//
//  InstagramModel.swift
//  Flytant
//
//  Created by Flytant on 24/09/21.
//  Copyright © 2021 Vivek Rai. All rights reserved.
//

import Foundation

struct InstagramToken: Codable {
    var accessToken: String
    var userId: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case userId = "user_id"
    }
}

struct InstagramUsername: Codable {
    var username: String
    var id: String
}

struct FirebaseInstagramModel : Codable {
    var socialScore: Int?
    var username: String?
    var details: InstagramModel?
    
    func toDictionary() -> Dictionary<String, Any> {
        var dict: [String: Any] = [:]
        if let details = details {
            dict["details"] = details.toDictionary()
        }
        if let socialScore = socialScore {
            dict["socialScore"] = socialScore
        }
        if let username = username {
            dict["username"] = username
        }
        return dict
    }
}


struct InstagramModel: Codable {
    var graphql: GraphQL?
    
    func toDictionary() -> Dictionary<String, Any> {
        var dict: [String: Any] = [:]
        if let graphql = graphql {
            dict["graphql"] = graphql.toDictionary()
        }
        return dict
    }
}

struct GraphQL: Codable {
    var instaUser: InstaUser?
    
    enum CodingKeys: String, CodingKey {
        case instaUser = "user"
    }
    
    func toDictionary() -> Dictionary<String, Any> {
        var dict: [String: Any] = [:]
        if let instaUser = instaUser {
            dict["user"] = instaUser.toDictionary()
        }
        return dict
    }
}

struct InstaUser: Codable {
    var biography: String?
    var fullName: String?
    var isPrivate: Bool?
    var username: String?
    var profilePicUrl: String?
    var edgeOwnerToTimelineMedia: Edge?
    var edgeFollow: EdgeFollow?
    var edgeFollowedBy: EdgeFollow?
    var externalURL: String?
    var externalURLLinkshimmed: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case biography
        case isPrivate = "is_private"
        case fullName = "full_name"
        case edgeFollowedBy = "edge_followed_by"
        case edgeFollow = "edge_follow"
        case profilePicUrl = "profile_pic_url"
        case edgeOwnerToTimelineMedia = "edge_owner_to_timeline_media"
        case externalURL = "external_url"
        case externalURLLinkshimmed = "external_url_linkshimmed"
    }
    
    func toDictionary() -> Dictionary<String, Any> {
        var dict: [String: Any] = [:]
        if let biography = biography {
            dict["biography"] = biography
        }
        if let edgeFollow = edgeFollow {
            dict["edge_follow"] = edgeFollow.toDictionary()
        }
        if let edgeFollowedBy = edgeFollowedBy {
            dict["edge_followed_by"] = edgeFollowedBy.toDictionary()
        }
        if let edgeOwnerToTimelineMedia = edgeOwnerToTimelineMedia {
            dict["edge_owner_to_timeline_media"] = edgeOwnerToTimelineMedia.toDictionary()
        }
        return dict
    }
}

struct Edge: Codable {
    var count: Int?
    var pageInfo: PageInfo?
    var edges: [EdgeFelixVideoTimelineEdge]?
    
    enum CodingKeys: String, CodingKey {
        case count
        case pageInfo = "page_info"
        case edges
    }
    
    func toDictionary() -> Dictionary<String, Any> {
        var dict: [String: Any] = [:]
        if let count = count {
            dict["count"] = count
        }
        if let edges = edges {
            var dictionaryElement = [[String: Any]]()
            for edge in edges {
                dictionaryElement.append(edge.toDictionary())
            }
            dict["edges"] = dictionaryElement
        }
        return dict
    }
}

// MARK: - EdgeFelixVideoTimelineEdge
struct EdgeFelixVideoTimelineEdge: Codable {
    var node: PurpleNode?
    
    func toDictionary() -> Dictionary<String, Any> {
        var dict: [String: Any] = [:]
        if let node = node {
            dict["node"] = node.toDictionary()
        }
        
        return dict
    }
    
}

// MARK: - PurpleNode
struct PurpleNode: Codable {
    var id: String?
    var shortcode: String?
    var dimensions: Dimensions?
    var displayURL: String?
    var mediaPreview: String?
    var owner: Owner?
    var isVideo: Bool?
    var hasUpcomingEvent: Bool?
    var edgeMediaToComment: EdgeFollow?
    var commentsDisabled: Bool?
    var takenAtTimestamp: Int?
    var edgeLikedBy: EdgeFollow?
    var edgeMediaPreviewLike: EdgeFollow?
    var thumbnailSrc: String?
    var thumbnailResources: [ThumbnailResource]?
    var edgeMediaToCaption: EdgeRelatedProfilesClass?

    enum CodingKeys: String, CodingKey {
        case id
        case shortcode
        case dimensions
        case displayURL = "display_url"
        case mediaPreview = "media_preview"
        case owner
        case isVideo = "is_video"
        case hasUpcomingEvent = "has_upcoming_event"
        case edgeMediaToComment = "edge_media_to_comment"
        case commentsDisabled = "comments_disabled"
        case takenAtTimestamp = "taken_at_timestamp"
        case edgeLikedBy = "edge_liked_by"
        case edgeMediaPreviewLike = "edge_media_preview_like"
        case thumbnailSrc = "thumbnail_src"
        case thumbnailResources = "thumbnail_resources"
        case edgeMediaToCaption = "edge_media_to_caption"
    }
    
    func toDictionary() -> Dictionary<String, Any> {
        var dict: [String: Any] = [:]
        if let edgeMediaToComment = edgeMediaToComment {
            dict["edge_media_to_comment"] = edgeMediaToComment.toDictionary()
        }
        if let id = id {
            dict["id"] = id
        }
        if let takenAtTimestamp = takenAtTimestamp {
            dict["taken_at_timestamp"] = takenAtTimestamp
        }
        if let thumbnailSrc = thumbnailSrc {
            dict["thumbnail_src"] = thumbnailSrc
        }
        return dict
    }
}



// MARK: - Owner
struct Owner: Codable {
    var id: String?
    var username: String?
}

// MARK: - Dimensions
struct Dimensions: Codable {
    var height, width: Int?
    
    func toDictionary() -> Dictionary<String, Any> {
        var dict: [String: Any] = [:]
        if let height = height {
            dict["height"] = height
        }
        if let width = width {
            dict["width"] = width
        }
        return dict
    }
}

// MARK: - ThumbnailResource
struct ThumbnailResource: Codable {
    var src: String?
    var configWidth, configHeight: Int?

    enum CodingKeys: String, CodingKey {
        case src
        case configWidth = "config_width"
        case configHeight = "config_height"
    }
    
    func toDictionary() -> Dictionary<String, Any> {
        var dict: [String: Any] = [:]
        if let src = src {
            dict["src"] = src
        }
        if let configWidth = configWidth {
            dict["config_width"] = configWidth
        }
        if let configHeight = configHeight {
            dict["config_width"] = configHeight
        }
        return dict
    }
    
}

// MARK: - EdgeRelatedProfilesClass
struct EdgeRelatedProfilesClass: Codable {
    var edges: [EdgeRelatedProfilesEdge]?
}

// MARK: - EdgeRelatedProfilesEdge
struct EdgeRelatedProfilesEdge: Codable {
    var node: FluffyNode?
}

// MARK: - FluffyNode
struct FluffyNode: Codable {
    var text: String?
}

struct PageInfo: Codable {
    var hasNextPage: Bool?
    var endCursor: String?
    
    enum CodingKeys: String, CodingKey {
        case hasNextPage = "has_next_page"
        case endCursor = "end_cursor"
    }
}

struct EdgeFollow: Codable {
    var count: Int?
    
    func toDictionary() -> Dictionary<String, Any> {
        var dict: [String: Any] = [:]
        if let count = count {
            dict["count"] = count
        }
        return dict
    }
}
