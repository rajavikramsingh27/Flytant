//
//  YoutubeData.swift
//  Flytant
//
//  Created by Vivek Rai on 28/12/20.
//  Copyright © 2020 Vivek Rai. All rights reserved.
//

import Foundation

class YoutubeData{

    private(set) var thumbnail: String!
    private(set) var title: String!
    private(set) var videoId: String!
    
    init(thumbnail: String, title: String, videoId: String){
        self.thumbnail = thumbnail
        self.title = title
        self.videoId = videoId
    }
    
}

