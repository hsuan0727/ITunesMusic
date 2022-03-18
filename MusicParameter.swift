//
//  Request.swift
//  ITunesMusic
//
//  Created by Hsuan on 2021/12/7.
//

import Foundation

class MusicParameter:Encodable {
    private var term:String = ""
    private var entity:String = "musicTrack"
    
    init(term:String) {
        self.term = term
    }
    
    enum CodingKeys: String, CodingKey {
        case term = "term"
        case entity = "entity"
    }
    
    func encode(to encoder: Encoder) throws {
        var key = encoder.container(keyedBy: CodingKeys.self)
        try key.encode(term ,forKey: .term)
        try key.encode(entity, forKey: .entity)
    }
    
}
