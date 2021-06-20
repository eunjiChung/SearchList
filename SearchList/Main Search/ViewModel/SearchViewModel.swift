//
//  SearchViewModel.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/20.
//

import Foundation

protocol SearchViewModelDelegate: AnyObject {
    func onFetchCompleted(with startIndex: Int, indexPaths: [IndexPath]?)
    func onFetchFailed()
}

final class SearchViewModel {

    var query: String?

    var isWaiting: Bool = false

    var hasMore: Bool = true

    var list: [DocumentModel] = []

    var rowCount: Int { return list.count + (hasMore ? 1 : 0) }

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
            // TODO: - 새로 sorting한 list 집어넣기
            self.list.append(contentsOf: model)

            if self.page > 1 {
                self.delegate?.onFetchCompleted(with: self.list.count-model.count, indexPaths: self.loadingIndexPaths(from: model))
            } else {
                self.delegate?.onFetchCompleted(with: 0, indexPaths: nil)
            }
        } failure: {
            self.delegate?.onFetchFailed()
        }
    }

    private func loadingIndexPaths(from givenList: [DocumentModel]) -> [IndexPath]? {
        let startIndex = list.count - givenList.count
        let endIndex = startIndex + givenList.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
