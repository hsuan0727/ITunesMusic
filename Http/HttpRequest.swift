//
//  HttpRequest.swift
//  ITunesMusic
//
//  Created by Hsuan on 2021/12/7.
//

import Foundation
import Alamofire
import RxSwift

public class HttpRequest {
    public static let Singleton = HttpRequest()
    private let manager: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        return Alamofire.Session(configuration: configuration)
    }()
    
    public func post<Parameters: Encodable>(url:String,parameter:Parameters) -> Single<HttpStatus<Data>> {
        Single<HttpStatus<Data>>.create{closure in
            let request = AF.request(url,method: .post,parameters: parameter).response(queue: .global()){
                response in
                switch response.result {
                case .success(let data):
                    if let d = data {
                        closure(.success(.data(d)))
                    }else {
                        closure(.failure(AppError("http data == nil")))
                    }
                case .failure(let error):
                    closure(.failure(AppError(error)))
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    public func postDecodeApiResult<Parameters: Encodable,T:Codable>(url: String, parameter: Parameters) -> Single<HttpStatus<T>> {
        post(url: url, parameter: parameter).flatMap {status -> Single<HttpStatus<T>> in
            switch status{
            case .data(let d):
                do {
                    let result:T = try ResultDecoder.parser(d)
                    return Single.just(HttpStatus<T>.data(result))
                } catch let errer as AppError {
                    return Single.just(HttpStatus<T>.error(errer))
                }
            case .error(let e):
                return Single.just(HttpStatus<T>.error(e))
            }
        }
    }
    
  
    
    
    
}
