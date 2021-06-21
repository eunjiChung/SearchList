//
//  SearchOperationDataProvider.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/20.
//

import Foundation

class SearchOperationDataProvider: Operation {

    var cafeModel: SearchModel?
    var blogModel: SearchModel?
    var isDownloadFinished: Bool = false

    override func main() {
        if self.isCancelled { return }

        guard let dataLoaders = dependencies as? [TargetDataProvider] else { return }
        for loader in dataLoaders {
            if let model = loader.loadedModel as? SearchResultModel<CafeDocument> {
                cafeModel = model
            }

            if let model = loader.loadedModel as? SearchResultModel<BlogDocument> {
                blogModel = model
            }
        }

        isDownloadFinished = dependencies.allSatisfy({ $0.isFinished })
    }
}
