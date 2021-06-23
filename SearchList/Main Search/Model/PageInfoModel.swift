//
//  PageInfoModel.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/23.
//

import Foundation

public struct PageInfoModel {
    var totalCount: Int
    var isEnd: Bool
    var totalPage: Int { return Int(ceil(Double(totalCount))/25) }

    init(totalCount: Int = 0, isEnd: Bool = true) {
        self.totalCount = totalCount
        self.isEnd = isEnd
    }
}
