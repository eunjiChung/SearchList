//
//  SearchListProvider.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/20.
//

import Foundation

typealias ReturnType = ((Bool, Bool, [Document]) -> Void)

class SearchListProvider {

    fileprivate let operationQueue = OperationQueue()

    fileprivate var isOperationExecuting: Bool {
        return operationQueue.operations.contains(where: { $0.isExecuting })
    }

    init(originList: [Document],
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
        let filterList = FilterOperation()
        let appendList = AppendOperation(originList: originList)
        let sortList = SortOperation(sort: sort) { isCafeEnd, isBlogEnd, newList in
            completion(isCafeEnd, isBlogEnd, newList)
        }

        let operations = [cafeFetch, blogFetch, listProvider, filterList, appendList, sortList]
        listProvider.addDependency(cafeFetch)
        listProvider.addDependency(blogFetch)
        filterList.addDependency(listProvider)
        appendList.addDependency(filterList)
        sortList.addDependency(appendList)

        operationQueue.addOperations(operations, waitUntilFinished: false)
    }

    func cancel() {
        operationQueue.cancelAllOperations()
    }
}
