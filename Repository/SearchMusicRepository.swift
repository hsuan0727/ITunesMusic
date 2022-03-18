//
//  SearchMusicRepository.swift
//  ITunesMusic
//
//  Created by Hsuan on 2021/12/6.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

class SearchMusicRepository {
    private let http = HttpRequest.Singleton
    
    func triggerApi(enterTerm:String,parameter:MusicParameter) -> Single<HttpStatus<SearchMusicResponse>>  {
        let musicUrl = combineUrl(term: enterTerm)
     return http.postDecodeApiResult(url: musicUrl, parameter: parameter).flatMap { [weak self] status in
        self?.apiSuccess(status: status) ?? .just(.data(SearchMusicResponse()))
    }.observe(on: MainScheduler.instance)
  }
    
    private func apiSuccess(status:HttpStatus<SearchMusicResponse>) -> Single<HttpStatus<SearchMusicResponse>>  {
        switch status {
        case .data(let data):
            return .just(.data(data))
        case .error(let error):
            return .just(.error(error))
        }
    }
    
   
   private func combineUrl(term:String)-> String {
        let musicTrack:String = "musicTrack"
        let url = "https://itunes.apple.com/search?term=" + term + "&entity=" + musicTrack
        var encUrl:String = ""
        encUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return encUrl
    }
    
    
    }


