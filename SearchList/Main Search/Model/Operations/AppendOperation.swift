//
//  AppendOperation.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/22.
//

import Foundation

final class AppendOperation: Operation {

    var newList: [Document]?
    var pageInfo: [SearchTargetType: PageInfoModel] = [:]

    override func main() {
        var list: [Document] = []
        var cafeInfo = PageInfoModel(isEnd: true)
        var blogInfo = PageInfoModel(isEnd: true)

        if self.isCancelled { return }

        guard let provider = dependencies.first as? FilterOperation else { return }

        if let cafeModel = provider.cafeModel as? SearchResultModel<CafeDocument> {
            cafeInfo = PageInfoModel(isEnd: cafeModel.meta.isEnd)
            list.append(contentsOf: cafeModel.documents ?? [])
        }

        if let blogModel = provider.blogModel as? SearchResultModel<BlogDocument> {
            blogInfo = PageInfoModel(isEnd: blogModel.meta.isEnd)
            list.append(contentsOf: blogModel.documents ?? [])
        }

        newList = list
        pageInfo = [SearchTargetType.cafe: cafeInfo, SearchTargetType.blog: blogInfo]
    }
}
