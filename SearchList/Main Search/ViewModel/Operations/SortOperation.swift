//
//  SortListModel.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/20.
//

import Foundation

typealias ReturnType = ((Bool, Bool, [Document]) -> Void)

enum FilterType: Int {
    case all = 0
    case blog
    case cafe

    var title: String {
        switch self {
        case .all:      return "ALL"
        case .blog:     return "BLOG"
        case .cafe:     return "CAFE"
        }
    }
}

enum SortType {
    case title
    case datetime
}

class SortOperation: Operation {

    fileprivate let completion: ReturnType?
    fileprivate let sort: SortType

    init(sort: SortType, completion: ReturnType?) {
        self.sort = sort
        self.completion = completion
        super.init()
    }

    override func main() {
        if self.isCancelled { return }

        guard let provider = dependencies.first as? AppendOperation else { return }

        var list: [Document] = []

        if let appendedList = provider.newList {
            switch sort {
            case .title:        list = appendedList.sorted { $0.isAscendingTo($1) }
            case .datetime:     list = appendedList.sorted { $0.isRecentTo($1) }
            }
        }

        completion?(provider.isCafeEnd, provider.isBlogEnd, list)
    }
}
