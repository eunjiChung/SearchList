//
//  DataLoadOperation.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/20.
//

import Foundation

class DataLoadOperation<Element: Decodable>: AsyncOperation, TargetDataProvider {
    
    fileprivate let target: SearchTargetType
    fileprivate let query: String
    fileprivate let page: Int
    fileprivate let sort: SortType
    fileprivate let failure: (() -> Void)?
    internal var loadedModel: SearchModel?

    init(target: SearchTargetType, query: String, page: Int, sort: SortType, failure: (() -> Void)? = nil) {
        self.target = target
        self.query = query
        self.page = page
        self.sort = sort
        self.failure = failure
        super.init()
    }

    override func main() {
        if self.isCancelled { return }

        NetworkAdapter.request(target: SearchAPI.search(target: target.rawValue,
                                                        query: query,
                                                        page: page,
                                                        sort: sort)) { response in
            if self.isCancelled { return }

            do {
                let model = try JSONDecoder().decode(SearchResultModel<Element>.self, from: response.data)
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
