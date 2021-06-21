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

    var list: [Document] = []

    var isCafeEnd: Bool = false
    var isBlogEnd: Bool = false

    var rowCount: Int { return list.count + (hasMore ? 1 : 0) }

    var sort: SortType = .title

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

        _ = SearchListProvider(originList: list,
                               sort: sort,
                               query: query!,
                               page: page) { isCafeEnd, isBlogEnd, newList in
            self.isCafeEnd = isCafeEnd
            self.isBlogEnd = isBlogEnd

            // TODO: - 새로 sorting한 list 집어넣기
            self.list = newList

            if self.page > 1 {
                self.delegate?.onFetchCompleted(with: self.list.count-newList.count, indexPaths: self.loadingIndexPaths(from: newList))
            } else {
                self.delegate?.onFetchCompleted(with: 0, indexPaths: nil)
            }
        } failure: {
            self.delegate?.onFetchFailed()
        }
    }

    private func loadingIndexPaths(from givenList: [Document]) -> [IndexPath]? {
        let startIndex = list.count - givenList.count
        let endIndex = startIndex + givenList.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
