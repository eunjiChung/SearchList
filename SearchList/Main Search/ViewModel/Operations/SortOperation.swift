//
//  SortListModel.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/20.
//

import Foundation

final class SortOperation: Operation {

    fileprivate let completion: ReturnType?
    fileprivate let originList: [Document]
    fileprivate let sort: SortType

    init(originList: [Document], sort: SortType, completion: ReturnType?) {
        self.originList = originList
        self.sort = sort
        self.completion = completion
        super.init()
    }

    override func main() {
        if self.isCancelled { return }

        guard let provider = dependencies.first as? AppendOperation else { return }

        var list: [Document] = originList
        if let appendedList = provider.newList {
            switch sort {
            case .title:        list = appendedList.sorted { $0.isAscendingTo($1) }
            case .datetime:     list = appendedList.sorted { $0.isRecentTo($1) }
            }
        }
        completion?(provider.pageInfo, list)
    }
}
