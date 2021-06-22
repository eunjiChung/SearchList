//
//  AppendOperation.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/22.
//

import Foundation

class AppendOperation: Operation {

    var newList: [Document]?
    var isCafeEnd: Bool = false
    var isBlogEnd: Bool = false

    private let originList: [Document]

    init(originList: [Document]) {
        self.originList = originList
        super.init()
    }

    override func main() {
        var list: [Document] = originList

        if self.isCancelled { return }

        guard let provider = dependencies.first as? FilterOperation else { return }

        if let cafeModel = provider.cafeModel as? SearchResultModel<CafeDocument> {
            isCafeEnd = cafeModel.meta.isEnd
            list.append(contentsOf: cafeModel.documents ?? [])
        }

        if let blogModel = provider.blogModel as? SearchResultModel<BlogDocument> {
            isBlogEnd = blogModel.meta.isEnd
            list.append(contentsOf: blogModel.documents ?? [])
        }

        newList = list
    }
}
