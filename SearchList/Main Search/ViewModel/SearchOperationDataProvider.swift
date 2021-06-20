//
//  SearchOperationDataProvider.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/20.
//

import Foundation

class SearchOperationDataProvider: Operation {

    fileprivate let completion: (() -> ())?

    var cafeModel: SearchResultModel?
    var blogModel: SearchResultModel?

    var fullList: [DocumentModel]?

    init(completion: (() -> ())? = nil) {
        self.completion = completion
        super.init()
    }

    override func main() {
        if self.isCancelled { return }

        guard let dataLoaders = dependencies as? [DataLoadOperation] else { return }
        dataLoaders.forEach { dataLoader in
            if let cafeModel = dataLoader.cafeModel {
                self.cafeModel = cafeModel
            }
            if let blogModel = dataLoader.blogModel {
                self.blogModel = blogModel
            }
        }

        // TODO: - 둘 중 하나가 먼저 끝날 것도 예상
        guard cafeModel != nil, blogModel != nil else { return }
        var fullList: [DocumentModel] = self.cafeModel?.documents ?? []
        fullList.append(contentsOf: blogModel?.documents ?? [])
        self.fullList = fullList

        completion?()
    }
}
