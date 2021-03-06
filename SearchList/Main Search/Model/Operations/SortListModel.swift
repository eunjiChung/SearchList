//
//  SortListModel.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/20.
//

import Foundation

class SortListModel: Operation {

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
        var list: [Document] = originList
        var cafeInfo = PageInfoModel()
        var blogInfo = PageInfoModel()

        if self.isCancelled { return }

        guard let provider = dependencies.first as? SearchOperationDataProvider else { return }
        guard provider.isDownloadFinished else { return }

        if let cafeModel = provider.cafeModel as? SearchResultModel<CafeDocument> {
            cafeInfo = PageInfoModel(totalCount: cafeModel.meta.totalCount, isEnd: cafeModel.meta.isEnd)
            list.append(contentsOf: cafeModel.documents ?? [])
        }

        if let blogModel = provider.blogModel as? SearchResultModel<BlogDocument> {
            blogInfo = PageInfoModel(totalCount: blogModel.meta.totalCount, isEnd: blogModel.meta.isEnd)
            list.append(contentsOf: blogModel.documents ?? [])
        }

        let sortedList: [Document]
        switch sort {
        case .title:        sortedList = list.sorted { $0.isAscendingTo($1) }
        case .datetime:     sortedList = list.sorted { $0.isRecentTo($1) }
        }

        let infos = [SearchTargetType.cafe: cafeInfo, SearchTargetType.blog: blogInfo]
        completion?(infos, sortedList)
    }
}
