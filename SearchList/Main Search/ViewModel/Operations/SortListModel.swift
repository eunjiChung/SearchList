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
        var isCafeEnd: Bool = false
        var isBlogEnd: Bool = false

        if self.isCancelled { return }

        guard let provider = dependencies.first as? SearchOperationDataProvider else { return }
        guard provider.isDownloadFinished else { return }

        if let cafeModel = provider.cafeModel as? SearchResultModel<CafeDocument> {
            isCafeEnd = cafeModel.meta.isEnd
            list.append(contentsOf: cafeModel.documents ?? [])
        }

        if let blogModel = provider.blogModel as? SearchResultModel<BlogDocument> {
            isBlogEnd = blogModel.meta.isEnd
            list.append(contentsOf: blogModel.documents ?? [])
        }

        switch sort {
        case .title:
            // TODO: - title에 따라 소팅
        case .datetime:
            // TODO: - 날짜에 따라 소팅
        }

        completion?(isCafeEnd, isBlogEnd, list)
    }
}
