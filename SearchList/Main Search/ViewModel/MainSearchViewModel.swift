//
//  MainSearchViewModel.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/19.
//

import Foundation

final class MainSearchViewModel {

    let dispatchQueue = DispatchQueue(label: "search query request", qos: .background, attributes: .concurrent)
    let dispatchGroup = DispatchGroup()

    var didFinishRequest: (() -> Void)?

    var query: String? {
        didSet {
            requestSearch()
        }
    }
    var sort: String?
    var page: Int?

    private func requestSearch() {
        guard let query = query else { return }

        let leave = { self.dispatchGroup.leave() }
        let groups: [()] = [requestBlog(query: query, completion: leave), requestCafe(query: query, completion: leave)]
        groups.forEach({ method in
            dispatchGroup.enter()
            dispatchQueue.async { method }
        })
        dispatchGroup.notify(queue: .main) {
            self.didFinishRequest?()
        }
    }

    private func requestBlog(query: String, completion: (() -> Void)?) {
        NetworkAdapter.request(target: SearchAPI.searchBlog(query: query, sort: "", page: 1)) { response in
            do {
                let blogResult = try JSONDecoder().decode(SearchResultModel.self, from: response.data)
                print("❤️ blog:", blogResult)
            } catch {
                print("‼️", error)
            }
        } error: { error in
            print("‼️", error)
        } failure: { failError in
            print("‼️", failError)
        }
    }

    private func requestCafe(query: String, completion: (() -> Void)?) {
        NetworkAdapter.request(target: SearchAPI.searchCafe(query: query, sort: "", page: 1)) { response in
            do {
                let cafeResult = try JSONDecoder().decode(SearchResultModel.self, from: response.data)
                print("❤️ cafe:", cafeResult)
            } catch {
                print("‼️", error)
            }
        } error: { error in
            print("‼️", error)
        } failure: { failError in
            print("‼️", failError)
        }
    }
}
