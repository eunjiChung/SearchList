//
//  SearchViewModel.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/20.
//

import Foundation

protocol SearchViewModelDelegate: AnyObject {
    func onFetchCompleted(with indexPaths: [IndexPath]?, deleteIndex: Int?, completion: (() -> Void)?)
    func onFetchFailed(completion: (() -> Void)?)
    func onFilterChanged()
}

final class SearchViewModel {

    var query: String = "" {
        didSet {
            refreshList()
            loadNextPage()
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

    var hasMore: Bool = true
    var isEnd: Bool { return pageInfo?.allSatisfy({ $0.value.isEnd }) ?? false }

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

    public func refreshList() {
        page = 0
        list = []
        pageInfo = nil
        isWaiting = true
    }

    public func loadNextPage() {
        guard !query.isEmpty && !isEnd && isWaiting else { return }

        isWaiting = false

        page += 1

        let waitingCompletion = {
            self.isWaiting = true
        }

        _ = SearchListProvider(pageInfo: pageInfo,
                               sort: sort,
                               query: query,
                               page: page) { pageInfo, newList in
            self.pageInfo = pageInfo

            if self.isFirstPage {
                self.list.append(contentsOf: newList)
                self.delegate?.onFetchCompleted(with: .none, deleteIndex: .none, completion: waitingCompletion)
            } else {
                let startIndex: Int = self.listCount
                self.list.append(contentsOf: newList)
                let newIndexPaths = self.loadingIndexPaths(from: startIndex)
                self.delegate?.onFetchCompleted(with: newIndexPaths, deleteIndex: startIndex, completion: waitingCompletion)
            }
        } failure: {
            self.delegate?.onFetchFailed(completion: { self.isWaiting = true })
        }
    }

    private func filterList() {
        self.delegate?.onFilterChanged()
    }

    private func sortList() {
        switch sort {
        case .title:        list.sort { $0.isAscendingTo($1) }
        case .datetime:     list.sort { $0.isRecentTo($1) }
        }
        self.delegate?.onFilterChanged()
    }

    func selectList(_ index: Int, completion: @escaping (() -> Void)) {
        var currentList = exposingList
        currentList[index].isSelected = true
        completion()
    }

    private func loadingIndexPaths(from startIndex: Int) -> [IndexPath]? {
        let startIndex = startIndex
        let endIndex = isEnd ? listCount : listCount+1
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
