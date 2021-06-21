//
//  URLString.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/19.
//

import Foundation
import Moya

struct KakaoKey {
    static let appKey = "34e1bbfe849c78cdb250bfb5a9cedd87"
    static let apiKey = "937d9098adc7ba01ad75b9f472e1a1c0"
}

enum SearchAPI {
    case search(target: String, query: String, page: Int)
}

extension SearchAPI: TargetType {

    var baseURL: URL { return URL(string: "https://dapi.kakao.com")! }

    var path: String {
        switch self {
        case .search(let target, _, _):     return "/v2/search/\(target)"
        }
    }

    var method: Moya.Method { return .get }

    var task: Task {
        switch self {
        case .search(_, let query, let page):
            let param: [String: Any] = ["query": query, "sort": "recency", "page": page, "size": 25]
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        }
    }

    var sampleData: Data {
        return Data()
    }

    var headers: [String: String]? {
        let param = ["Authorization": "KakaoAK \(KakaoKey.apiKey)"]
        return param
    }
}
