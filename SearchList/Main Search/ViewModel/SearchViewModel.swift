//
//  SearchViewModel.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/20.
//

import Foundation

protocol SearchViewModelDelegate: AnyObject {
    func onFetchCompleted()
    func onFetchFailed()
}

final class SearchViewModel {

    private weak var delegate: SearchViewModelDelegate?

    var query: String?
    var page: Int = 1

    var list: [DocumentModel] = []

    var provider: [SearchListProvider] = []

    init(delegate: SearchViewModelDelegate) {
        self.delegate = delegate
    }

    func request() {
        let provider = SearchListProvider(query: query!, page: page) { model in
            print("❤️", model)
            self.list = model
            self.delegate?.onFetchCompleted()
        }
    }
}
