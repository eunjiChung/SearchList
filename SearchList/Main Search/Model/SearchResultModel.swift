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

enum DocumentType: String {
    case none
    case cafe
    case blog
}

class DocumentModel: Decodable {
    private enum CodingKeys: String, CodingKey {
        case title
        case thumbnail
        case contents
        case datetime
        case url
        case cafename
        case blogname
    }

    var title: String
    var thumbnail: String
    var contents: String
    var datetime: String
    var url: String
    var cafename: String?
    var blogname: String?

    var name: String {
        if let cafename = cafename {
            return cafename
        } else if let blogname = blogname {
            return blogname
        }
        return ""
    }
    var type: SearchTargetType {
        if cafename != nil { return .cafe }
        if blogname != nil { return .blog }
        return .cafe
    }
    var isSelected: Bool = false
}
