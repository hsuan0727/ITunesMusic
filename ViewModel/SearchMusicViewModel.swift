//
//  SearchMusicViewModel.swift
//  ITunesMusic
//
//  Created by Hsuan on 2021/12/6.
//

import Foundation
import RxSwift
import RxRelay


class SearchMusicViewModel {
    
    enum searchMusicViewModelState {
        case loadstart
        case loadEnd
        case error(errorMessage: AppError)
        case data(_ d: SearchMusicResponse)
    
    }
    
    private var compositeDisposable:CompositeDisposable
    private var searchMusicRepository: SearchMusicRepository
    let searchMusicSubject = PublishSubject<searchMusicViewModelState>()
    private var disposeKey:CompositeDisposable.DisposeKey? = nil //回收機制以key值新增刪除
    
    init(composite: CompositeDisposable,searchMusicRepository: SearchMusicRepository) {
        compositeDisposable = composite
        self.searchMusicRepository = searchMusicRepository
        
    }
    
    func readProductDetailApiData(enterTerm:String,musicParameter: MusicParameter) {
        searchMusicSubject.onNext(.loadstart)
        if let key = disposeKey {
            compositeDisposable.remove(for: key)
        }
        
        disposeKey = compositeDisposable.insert(searchMusicRepository.triggerApi(enterTerm: enterTerm, parameter: musicParameter).subscribe(with: self, onSuccess: { (vm, status) in
            switch status {
            case .data(let resultData):
                vm.searchMusicSubject.onNext(.data(resultData))
            
            case .error(let error):
                vm.searchMusicSubject.onNext(.error(errorMessage: error))
            }
            vm.searchMusicSubject.onNext(.loadEnd)
           
        }, onFailure: { (vm, error) in
            vm.searchMusicSubject.onNext(.error(errorMessage: .init(error)))
            vm.searchMusicSubject.onNext(.loadEnd)
        }))

        
        
    }
    
}
