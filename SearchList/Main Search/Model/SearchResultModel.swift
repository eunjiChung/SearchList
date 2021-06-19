//
//  SearchResultModel.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/19.
//

import Foundation

struct SearchResultModel: Decodable {
    var meta: MetaModel
    var documents: [DocumentModel]?
}

struct MetaModel: Decodable {
    private enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }

    var isEnd: Bool
    var pageableCount: Int
    var totalCount: Int
}

struct DocumentModel: Decodable {
    var cafename: String?
    var blogname: String?

    var contents: String
    var datetime: String
    var thumbnail: String
    var title: String
    var url: String
}
