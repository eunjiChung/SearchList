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

    var isEnd: Bool { return isCafeEnd && isBlogEnd }

    var exposingList: [Document] {
        switch filter {
        case .all:      return list
        case .cafe:     return list.filter({ $0 is CafeDocument })
        case .blog:     return list.filter({ $0 is BlogDocument })
        }
    }

    private var list: [Document] = []
    private var dict: [UUID : Any] = [:]
    private var keyPath: KeyPath<Document, UUID>?

    var isListEmpty: Bool { return exposingList.count == 0 }
    var listCount: Int { return exposingList.count }
    var rowCount: Int {
        return isListEmpty ? 0 : exposingList.count + (isEnd ? 0 : 1)
    }

    private var page: Int = 0

    var isFirstPage: Bool { return page == 1 }

    private var isCafeEnd: Bool = false
    private var isBlogEnd: Bool = false

    private weak var delegate: SearchViewModelDelegate?

    var provider = SearchListProvider()

    init(delegate: SearchViewModelDelegate) {
        self.delegate = delegate
    }

    public func refreshList() {
        list.removeAll()
        page = 0
        provider.cancelAllRequest()
        // TODO: - 페이지 로딩
        provider.loadPage(originList: list, sort: sort, query: query, page: page) { info in
            self.bindNewPage(info)
        } failure: {
            self.delegate?.onFetchFailed(completion: { self.isWaiting = true })
        }
    }

    public func loadNextPage() {
        guard !query.isEmpty && !isEnd && isWaiting else { return }

        isWaiting = false

        page += 1

        provider.loadPage(originList: list, sort: sort, query: query, page: page) { info in
            self.bindNewPage(info)
        } failure: {
            self.delegate?.onFetchFailed(completion: { self.isWaiting = true })
        }
    }

    public func shouldPrefetch(index: Int) {
        if index == listCount - 1 {
            loadNextPage()
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

    func selectList(_ index: Int, completion: @escaping (() -> Void)) {
        var currentList = exposingList
        currentList[index].isSelected = true
        completion()
    }

    private func bindNewPage(_ info: PageInfo) {
        self.isCafeEnd = info.isCafeEnd
        self.isBlogEnd = info.isBlogEnd

        let waitingCompletion = { self.isWaiting = true }

        if self.isFirstPage {
            self.list = info.documents
            self.delegate?.onFetchCompleted(with: .none, completion: waitingCompletion)
        } else {
            let newIndexPaths = self.loadingIndexPaths(from: info.documents)
            self.list = info.documents
            self.delegate?.onFetchCompleted(with: newIndexPaths, completion: waitingCompletion)
        }
    }

    private func loadingIndexPaths(from newList: [Document]) -> [IndexPath]? {
        let startIndex = listCount
        var endIndex: Int
        switch filter {
        case .all:      endIndex = newList.count
        case .cafe:     endIndex = newList.compactMap({ $0 as? CafeDocument }).count
        case .blog:     endIndex = newList.compactMap({ $0 as? BlogDocument }).count
        }
        endIndex = isEnd ? endIndex-1 : endIndex
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
