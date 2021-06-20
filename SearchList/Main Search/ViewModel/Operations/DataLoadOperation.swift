//
//  DataLoadOperation.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/20.
//

import Foundation

enum SearchTargetType: String {
    case cafe
    case blog
}

protocol TargetDataProvider {
    var cafeModel: SearchResultModel? { get }
    var blogModel: SearchResultModel? { get }
}

class DataLoadOperation: AsyncOperation {

    fileprivate let target: SearchTargetType
    fileprivate let query: String
    fileprivate let page: Int
    fileprivate let failure: (() -> Void)?
    fileprivate var loadedModel: SearchResultModel?

    init(target: SearchTargetType, query: String, page: Int, failure: (() -> Void)? = nil) {
        self.target = target
        self.query = query
        self.page = page
        self.failure = failure
        super.init()
    }

    override func main() {
        if self.isCancelled { return }

        NetworkAdapter.request(target: SearchAPI.search(target: target.rawValue,
                                                        query: query,
                                                        page: page)) { response in
            if self.isCancelled { return }

            do {
                let model = try JSONDecoder().decode(SearchResultModel.self, from: response.data)
                self.loadedModel = model
                self.state = .Finished
            } catch {
                print("‼️", error.localizedDescription)
                self.state = .Finished
                self.failure?()
            }
        } error: { error in
            print("‼️", error.localizedDescription)
            self.state = .Finished
            self.failure?()
        } failure: { failError in
            print("‼️", failError.localizedDescription)
            self.state = .Finished
            self.failure?()
        }
    }
}

extension DataLoadOperation: TargetDataProvider {
    var cafeModel: SearchResultModel? {
        guard let loadedModel = self.loadedModel else { return nil }
        return target == .cafe ? loadedModel : nil
    }

    var blogModel: SearchResultModel? {
        guard let loadedModel = self.loadedModel else { return nil }
        return target == .blog ? loadedModel : nil
    }
}
