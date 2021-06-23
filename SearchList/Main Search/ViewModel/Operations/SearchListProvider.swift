//
//  SearchListProvider.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/20.
//

import Foundation

typealias PageInfoType = [SearchTargetType: PageInfoModel]
typealias ReturnType = ((PageInfoType, [Document])->Void)

final class SearchListProvider {

    fileprivate let operationQueue = OperationQueue()

    fileprivate var isOperationExecuting: Bool {
        return operationQueue.operations.contains(where: { $0.isExecuting })
    }

    init(originList: [Document],
         pageInfo: [SearchTargetType: PageInfoModel]?,
         sort: SortType,
         query: String,
         page: Int,
         completion: @escaping ReturnType,
         failure: @escaping (() -> Void)) {

        operationQueue.maxConcurrentOperationCount = 2

        let setFailedStatus = {
            guard self.isOperationExecuting else { return }
            self.cancel()
            failure()
        }

        let cafeFetch = DataLoadOperation<CafeDocument>(target: .cafe, query: query, page: page, failure: setFailedStatus)
        let blogFetch = DataLoadOperation<BlogDocument>(target: .blog, query: query, page: page, failure: setFailedStatus)
        let listProvider = SearchOperationDataProvider()
        let sortList = SortListModel(originList: originList, sort: sort) { infoDict, newList in
            completion(infoDict, newList)
        }

        var operations: [Operation] = [listProvider, sortList]
        if pageInfo?[.cafe]?.totalPage ?? 0 < page {
            operations.append(cafeFetch)
            listProvider.addDependency(cafeFetch)
        }
        if pageInfo?[.blog]?.totalPage ?? 0 < page {
            operations.append(blogFetch)
            listProvider.addDependency(blogFetch)
        }
        sortList.addDependency(listProvider)

        operationQueue.addOperations(operations, waitUntilFinished: false)
    }

    func cancel() {
        operationQueue.cancelAllOperations()
    }
}
