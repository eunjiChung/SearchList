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

    var query: String = "" {
        didSet {
            refreshList()
            request()
        }
    }

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

    var isEnd: Bool { return pageInfo?.allSatisfy({ $0.value.totalPage <= page }) ?? false }

    var exposingList: [Document] {
        switch filter {
        case .all:      return list
        case .cafe:     return list.filter({ $0 is CafeDocument })
        case .blog:     return list.filter({ $0 is BlogDocument })
        }
    }

    var isListEmpty: Bool {
        return exposingList.count == 0
    }
    var listCount: Int {
        return exposingList.count
    }
    var rowCount: Int {
        return isListEmpty ? 0 : exposingList.count + (isEnd ? 0 : 1)
    }

    var isFirstPage: Bool { return page == 1 }

    private var page: Int = 0

    private var list: [Document] = []

    private weak var delegate: SearchViewModelDelegate?

    var pageInfo: [SearchTargetType: PageInfoModel]?

    init(delegate: SearchViewModelDelegate) {
        self.delegate = delegate
    }

    private func refreshList() {
        page = 0
        list = []
        isWaiting = true
    }

    func request() {
        guard !query.isEmpty && !isEnd && isWaiting else { return }

        isWaiting = false

        page += 1

        let waitingCompletion = { self.isWaiting = true }

        _ = SearchListProvider(originList: list,
                               pageInfo: pageInfo,
                               sort: sort,
                               query: query,
                               page: page) { pageInfo, newList in

            if self.pageInfo == nil {
                self.pageInfo = pageInfo
            }

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
