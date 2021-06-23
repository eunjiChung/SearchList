//
//  Types.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/23.
//

import Foundation

enum FilterType: Int {
    case all = 0
    case blog
    case cafe

    var title: String {
        switch self {
        case .all:      return "ALL"
        case .blog:     return "BLOG"
        case .cafe:     return "CAFE"
        }
    }
}

enum SortType {
    case title
    case datetime
}
