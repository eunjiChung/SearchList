//
//  SearchListProvider.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/20.
//

import Foundation

class SearchListProvider {

    fileprivate let operationQueue = OperationQueue()

    fileprivate var isOperationExecuting: Bool {
        return operationQueue.operations.contains(where: { $0.isExecuting })
    }

    // List는 임시
    var list: [DocumentModel] = []

    init(query: String, page: Int, completion: @escaping (([DocumentModel]) -> Void), failure: @escaping (() -> Void)) {
        operationQueue.maxConcurrentOperationCount = 2

        let setFailedStatus = {
            guard self.isOperationExecuting else { return }
            self.cancel()
            failure()
        }
        let cafeFetch = DataLoadOperation(target: .cafe, query: query, page: page, failure: setFailedStatus)
        let blogFetch = DataLoadOperation(target: .blog, query: query, page: page, failure: setFailedStatus)
        let listProvider = SearchOperationDataProvider()
        let sortList = SortListModel { model in
            if let model = model {
                self.list = model
                completion(model)
            }
        }

        let operations = [cafeFetch, blogFetch, listProvider, sortList]
        listProvider.addDependency(cafeFetch)
        listProvider.addDependency(blogFetch)
        sortList.addDependency(listProvider)

        operationQueue.addOperations(operations, waitUntilFinished: false)
    }

    func cancel() {
        operationQueue.cancelAllOperations()
    }
}
