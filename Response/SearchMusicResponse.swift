//
//  MusicResponse.swift
//  ITunesMusic
//
//  Created by Hsuan on 2021/12/6.
//

import Foundation


class SearchMusicResponse:Codable {
    private(set)var resultCount:Int = Int.min
    private(set)var results:[Results] = []
    
    enum CodingKeys:String,CodingKey {
        case resultCount = "resultCount"
        case results = "results"
    }
    
    init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        resultCount = try container.decodeIfPresent(Int.self, forKey: .resultCount) ?? Int.min
        results = try container.decodeIfPresent([Results].self, forKey: .results) ?? []
    }
    public func encode(to encoder: Encoder) throws {}
    
    
    struct Results:Decodable {
        let wrapperType:String
        let kind:String
        let artistId:Int
        let collectionId:Int
        let trackId:Int
        let artistName:String
        let collectionName:String
        let trackName:String
        let collectionCensoredName:String
        let trackCensoredName:String
        let artistViewUrl:String
        let collectionViewUrl:String
        let trackViewUrl:String
        let previewUrl:String
        let artworkUrl30:String
        let artworkUrl60:String
        let artworkUrl100:String
        let trackExplicitness:String
        let trackTimeMillis:Int
        let country:String
        
        init() {
            wrapperType = ""
            kind = ""
            artistId = Int.min
            collectionId = Int.min
            trackId = Int.min
            artistName = ""
            collectionName = ""
            trackName = ""
            collectionCensoredName = ""
            trackCensoredName = ""
            artistViewUrl = ""
            collectionViewUrl = ""
            trackViewUrl = ""
            previewUrl = ""
            artworkUrl30 = ""
            artworkUrl60 = ""
            artworkUrl100 = ""
            trackExplicitness = ""
            trackTimeMillis = Int.min
            country = ""
        }
        
        enum CodinkKeys:String,CodingKey {
            case wrapperType = "wrapperType"
            case kind = "kind"
            case artistId = "artistId"
            case collectionId = "collectionId"
            case trackId = "trackId"
            case artistName = "artistName"
            case collectionName = "collectionName"
            case trackName = "trackName"
            case collectionCensoredName = "collectionCensoredName"
            case trackCensoredName = "trackCensoredName"
            case artistViewUrl = "artistViewUrl"
            case collectionViewUrl = "collectionViewUrl"
            case trackViewUrl = "trackViewUrl"
            case previewUrl = "previewUrl"
            case artworkUrl30 = "artworkUrl30"
            case artworkUrl60 = "artworkUrl60"
            case artworkUrl100 = "artworkUrl100"
            case trackExplicitness = "trackExplicitness"
            case trackTimeMillis = "trackTimeMillis"
            case country = "country"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodinkKeys.self)
            wrapperType = try container.decodeIfPresent(String.self, forKey: .wrapperType) ?? ""
            kind = try container.decodeIfPresent(String.self, forKey: .kind) ?? ""
            artistId = try container.decodeIfPresent(Int.self, forKey: .artistId) ?? Int.min
            collectionId = try container.decodeIfPresent(Int.self, forKey: .collectionId) ?? Int.min
            trackId = try container.decodeIfPresent(Int.self, forKey: .trackId) ?? Int.min
            artistName = try container.decodeIfPresent(String.self, forKey: .artistName) ?? ""
            trackName = try container.decodeIfPresent(String.self, forKey: .trackName) ?? ""
            collectionName = try container.decodeIfPresent(String.self, forKey: .collectionName) ?? ""
            collectionCensoredName = try container.decodeIfPresent(String.self, forKey: .collectionCensoredName) ?? ""
            trackCensoredName = try container.decodeIfPresent(String.self, forKey: .trackCensoredName) ?? ""
            artistViewUrl = try container.decodeIfPresent(String.self, forKey: .artistViewUrl) ?? ""
            collectionViewUrl = try container.decodeIfPresent(String.self, forKey: .collectionViewUrl) ?? ""
            trackViewUrl = try container.decodeIfPresent(String.self, forKey: .trackViewUrl) ?? ""
            previewUrl = try container.decodeIfPresent(String.self, forKey: .previewUrl) ?? ""
            artworkUrl30 = try container.decodeIfPresent(String.self, forKey: .artworkUrl30) ?? ""
            artworkUrl60 = try container.decodeIfPresent(String.self, forKey: .artworkUrl60) ?? ""
            artworkUrl100 = try container.decodeIfPresent(String.self, forKey: .artworkUrl100) ?? ""
            trackExplicitness = try container.decodeIfPresent(String.self, forKey: .trackExplicitness) ?? ""
            trackTimeMillis =  try container.decodeIfPresent(Int.self, forKey: .trackTimeMillis) ?? Int.min
            country = try container.decodeIfPresent(String.self, forKey: .country) ?? ""
        }
        
    }
}
