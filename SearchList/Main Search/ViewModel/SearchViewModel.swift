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

    var query: String?

    var isWaiting: Bool = false

    var hasMore: Bool = true

    var list: [DocumentModel] = []

    private var page: Int = 0
    private var isFirstLoad: Bool { return page == 0 }

    private weak var delegate: SearchViewModelDelegate?

    init(delegate: SearchViewModelDelegate) {
        self.delegate = delegate
    }

    func request() {
        if !isFirstLoad {
            guard hasMore && isWaiting else { return }
        }

        isWaiting = false

        page += 1

        _ = SearchListProvider(query: query!, page: page) { model in
            self.list.append(contentsOf: model)
            self.delegate?.onFetchCompleted()
        } failure: {
            self.delegate?.onFetchFailed()
        }
    }
}
