//
//  SortListModel.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/20.
//

import Foundation

class SortListModel: Operation {

    fileprivate let completion: ([DocumentModel]?) -> ()
    fileprivate var inputList: [DocumentModel]?

    init(list: [DocumentModel]? = nil, completion: @escaping ([DocumentModel]?) -> ()) {
        self.inputList = list
        self.completion = completion
    }

    override func main() {
        var list: [DocumentModel] = []

        if self.isCancelled { return }

        if let inputList = self.inputList {
            list = inputList
        } else if let provider = dependencies.first as? SearchOperationDataProvider,
                  let fullList = provider.fullList {
            list = fullList
        }

        // TODO: - 소팅한 후 inputList에 데이터를 넣기
        inputList = list
        completion(inputList)
    }
}
