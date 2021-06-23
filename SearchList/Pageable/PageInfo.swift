//
//  PageInfo.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/23.
//

import Foundation

public struct PageInfo {
    var documents: [Document]
    var page: Int
    var totalPageCount: Int

    var isCafeEnd: Bool
    var isBlogEnd: Bool
}
