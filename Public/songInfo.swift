//
//  songInfo.swift
//  YFPFantasticDynamicEffect
//
//  Created by Charles Yao on 2017/1/27.
//  Copyright © 2017年 Charles Yao. All rights reserved.
//

import Foundation

class SongInfo {
    var songName: String!
    var covertImg: String!
    var singerName: String!
    var albumName: String!
    
    func initial(songName: String, covertImg: String, singerName: String, albumName: String) {
        self.songName = songName
        self.covertImg = covertImg
        self.singerName = singerName
        self.albumName = albumName
    }
}
