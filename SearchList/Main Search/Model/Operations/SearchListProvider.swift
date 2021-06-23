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

    init(pageInfo: [SearchTargetType: PageInfoModel]?,
         sort: SortType,
         query: String,
         page: Int,
         completion: @escaping ReturnType,
         failure: @escaping (() -> Void)) {

        operationQueue.maxConcurrentOperationCount = 2

        let setFailedStatus = {
            guard self.isOperationExecuting else { return }
            self.cancelAllRequest()
            failure()
        }

        let cafeFetch = DataLoadOperation<CafeDocument>(target: .cafe, query: query, page: page, sort: sort, failure: setFailedStatus)
        let blogFetch = DataLoadOperation<BlogDocument>(target: .blog, query: query, page: page, sort: sort, failure: setFailedStatus)
        let listProvider = SearchOperationDataProvider()
        let filterList = FilterOperation()
        let appendList = AppendOperation { pageInfo, newList in
            completion(pageInfo, newList)
        }

        var operations: [Operation] = [listProvider, filterList, appendList]

        if let pageInfo = pageInfo {
            if !(pageInfo[.cafe]?.isEnd ?? true) {
                operations.append(cafeFetch)
                listProvider.addDependency(cafeFetch)
            }
            if !(pageInfo[.blog]?.isEnd ?? true) {
                operations.append(blogFetch)
                listProvider.addDependency(blogFetch)
            }
        } else {
            operations.append(cafeFetch)
            operations.append(blogFetch)
            listProvider.addDependency(cafeFetch)
            listProvider.addDependency(blogFetch)
        }
        filterList.addDependency(listProvider)
        appendList.addDependency(filterList)

        operationQueue.addOperations(operations, waitUntilFinished: false)
    }

    func cancelAllRequest() {
        operationQueue.cancelAllOperations()
    }
}
