//
//  SearchListProvider.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/20.
//

import Foundation

typealias ReturnType = ((Bool, Bool, [Document]) -> Void)

final class SearchListProvider {

    fileprivate let operationQueue = OperationQueue()

    fileprivate var isOperationExecuting: Bool {
        return operationQueue.operations.contains(where: { $0.isExecuting })
    }

    public func loadPage(originList: [Document],
                  sort: SortType,
                  query: String,
                  page: Int,
                  completion: @escaping ((PageInfo) -> Void),
                  failure: @escaping (() -> Void)) {

        operationQueue.maxConcurrentOperationCount = 2

        let setFailedStatus = {
            guard self.isOperationExecuting else { return }
            self.cancelAllRequest()
            failure()
        }
        let cafeFetch = DataLoadOperation<CafeDocument>(target: .cafe, query: query, page: page, failure: setFailedStatus)
        let blogFetch = DataLoadOperation<BlogDocument>(target: .blog, query: query, page: page, failure: setFailedStatus)
        let listProvider = SearchOperationDataProvider()
        let sortList = SortListModel(originList: originList, sort: sort) { isCafeEnd, isBlogEnd, newList in
            // TODO: - 페이지 정보 수정 (totalPageCount, page 등)
            let pageInfo = PageInfo(documents: newList, page: page, totalPageCount: page, isCafeEnd: isCafeEnd, isBlogEnd: isBlogEnd)
            completion(pageInfo)
        }

        let operations = [cafeFetch, blogFetch, listProvider, sortList]
        listProvider.addDependency(cafeFetch)
        listProvider.addDependency(blogFetch)
        sortList.addDependency(listProvider)

        operationQueue.addOperations(operations, waitUntilFinished: false)
    }

    func cancelAllRequest() {
        operationQueue.cancelAllOperations()
    }
}
