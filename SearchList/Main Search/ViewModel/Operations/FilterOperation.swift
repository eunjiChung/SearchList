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
            cafeModel.documents?.forEach({ $0.parsedTitle = $0.title.containsHtml ? $0.title.removeHtml : $0.title })
            self.cafeModel = cafeModel
        }
        if let blogModel = provider.blogModel as? SearchResultModel<BlogDocument> {
            blogModel.documents?.forEach({ $0.parsedTitle = $0.title.containsHtml ? $0.title.removeHtml : $0.title })
            self.blogModel = blogModel
        }
    }
}
