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

    var filter: FilterType = .all {
        didSet {
            if oldValue == filter { return }
            filterList()
        }
    }

    var sort: SortType = .title {
        didSet {
            if oldValue == sort { return }
            sortList()
        }
    }

    var isWaiting: Bool = true

    var isEnd: Bool { return isCafeEnd && isBlogEnd }

    var exposingList: [Document] {
        switch filter {
        case .all:      return list
        case .cafe:     return list.compactMap({ $0 as? CafeDocument })
        case .blog:     return list.compactMap({ $0 as? BlogDocument })
        }
    }

    private var list: [Document] = []

    var isListEmpty: Bool { return exposingList.count == 0 }
    var listCount: Int { return exposingList.count }
    var rowCount: Int { return exposingList.count + (isEnd ? 0 : 1) }

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

    private func filterList() {
        self.delegate?.onFetchCompleted(with: .none, completion: nil)
    }

    private func sortList() {
        switch sort {
        case .title:
            list.sort { $0.isAscendingTo($1) }
        case .datetime:
            list.sort { $0.isRecentTo($1) }
        }
        self.delegate?.onFetchCompleted(with: .none, completion: nil)
    }

    private func loadingIndexPaths(from newList: [Document]) -> [IndexPath]? {
        let startIndex = listCount
        let endIndex: Int
        switch filter {
        case .all:      endIndex = newList.count
        case .cafe:     endIndex = newList.compactMap({ $0 as? CafeDocument }).count
        case .blog:     endIndex = newList.compactMap({ $0 as? BlogDocument }).count
        }
        deleteIndex = startIndex
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
