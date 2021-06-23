//
//  SearchResultModel.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/19.
//

import Foundation

struct SearchResultModel<T: Decodable>: Decodable, SearchModel {
    private enum CodingKeys: String, CodingKey {
        case meta
        case documents
    }

    var meta: MetaModel
    var documents: [T]?
}

struct MetaModel: Decodable {
    private enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case totalCount = "pageable_count"
    }
    var isEnd: Bool
    var totalCount: Int
}

class CafeDocument: Document, Decodable {
    private enum CodingKeys: String, CodingKey {
        case title
        case thumbnail
        case contents
        case datetime
        case url
        case cafename
    }

    var id = UUID()
    var title: String
    var thumbnail: String
    var contents: String
    var datetime: String
    var url: String
    var cafename: String?

    var parsedTitle: String?
    var name: String? { return cafename }
    var type: SearchTargetType { return .cafe }
    var isSelected: Bool = false
}

class BlogDocument: Document, Decodable {
    private enum CodingKeys: String, CodingKey {
        case title
        case thumbnail
        case contents
        case datetime
        case url
        case blogname
    }

    var id = UUID()
    var title: String
    var thumbnail: String
    var contents: String
    var datetime: String
    var url: String
    var blogname: String?

    var parsedTitle: String?
    var name: String? { return blogname }
    var type: SearchTargetType { return .blog }
    var isSelected: Bool = false
}
