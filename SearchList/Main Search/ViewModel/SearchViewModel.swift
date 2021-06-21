//
//  SearchViewModel.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/20.
//

import Foundation

protocol SearchViewModelDelegate: AnyObject {
    func onFetchCompleted(with indexPaths: [IndexPath]?, completion: (() -> Void)?)
    func onFetchFailed(completion: (() -> Void)?)
}

final class SearchViewModel {

    var query: String?

    var filter: FilterType = .all 

    var sort: SortType = .title

    var isWaiting: Bool = true

    var isEnd: Bool { return isCafeEnd && isBlogEnd }

    var list: [Document] = []

    var rowCount: Int { return list.count + (isEnd ? 0 : 1) }

    var deleteIndex: Int = 0

    private var page: Int = 0

    private var isFirstPage: Bool { return page == 1 }

    private var isCafeEnd: Bool = false
    private var isBlogEnd: Bool = false

    private weak var delegate: SearchViewModelDelegate?

    init(delegate: SearchViewModelDelegate) {
        self.delegate = delegate
    }

    func request() {
        guard !isEnd && isWaiting else { return }

        isWaiting = false

        page += 1

        let waitingCompletion = { self.isWaiting = true }

        _ = SearchListProvider(originList: list,
                               sort: sort,
                               query: query!,
                               page: page) { isCafeEnd, isBlogEnd, newList in
            self.isCafeEnd = isCafeEnd
            self.isBlogEnd = isBlogEnd

            if self.isFirstPage {
                self.list = newList
                self.delegate?.onFetchCompleted(with: .none, completion: waitingCompletion)
            } else {
                let newIndexPaths = self.loadingIndexPaths(from: newList)
                self.list = newList
                self.delegate?.onFetchCompleted(with: newIndexPaths, completion: waitingCompletion)
            }
        } failure: {
            self.delegate?.onFetchFailed(completion: waitingCompletion)
        }
    }

    private func loadingIndexPaths(from newList: [Document]) -> [IndexPath]? {
        let startIndex = list.count
        let endIndex = newList.count
        deleteIndex = startIndex
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
