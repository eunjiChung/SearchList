//
//  FilterOperation.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/22.
//

import Foundation

class FilterOperation: Operation {

    var cafeModel: SearchModel?
    var blogModel: SearchModel?

    override func main() {
        if self.isCancelled { return }

        guard let provider = dependencies.first as? SearchOperationDataProvider else { return }
        guard provider.isDownloadFinished else { return }

        if let cafeModel = provider.cafeModel as? SearchResultModel<CafeDocument> {
            self.cafeModel = cafeModel
        }
        if let blogModel = provider.blogModel as? SearchResultModel<BlogDocument> {
            self.blogModel = blogModel
        }
    }
}
