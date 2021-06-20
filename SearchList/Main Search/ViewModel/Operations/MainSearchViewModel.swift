//
//  MainSearchViewModel.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/19.
//

import Foundation

final class MainSearchViewModel {

    typealias DispatchLeave = (() -> Void)?

    let dispatchQueue = DispatchQueue(label: "search query request", qos: .background, attributes: .concurrent)
    let dispatchGroup = DispatchGroup()

    var didFinishRequest: (() -> Void)?
    var didFailRequest: ((String) -> Void)?

    var query: String? {
        didSet {
            requestSearch()
        }
    }
    var page: Int = 1

    var sortType: SortType = .title {
        didSet {
            guard oldValue != sortType else { return }
            didFinishRequest?()
        }
    }
    var filterType: FilterType = .all {
        didSet {
            guard oldValue != filterType else { return }
            didFinishRequest?()
        }
    }

    var blogModel: SearchResultModel?
    var cafeModel: SearchResultModel?
    var resultModel: [DocumentModel] = []

    func requestSearch() {
//        guard let query = query else { return }
        let query = "아이유"

        page += 1

        let leave: DispatchLeave = { [weak self] in
            self?.dispatchGroup.leave()
        }
        let groups: [()] = [requestBlog(query: query, completion: leave),
                            requestCafe(query: query, completion: leave)]
        groups.forEach({ method in
            dispatchGroup.enter()
            dispatchQueue.async { method }
        })
        dispatchGroup.notify(queue: .main) {
            self.generateListModel()
        }
    }

    private func generateListModel() {
        if let blogModel = blogModel {
            blogModel.documents?.forEach({ resultModel.append($0) })
        }
        if let cafeModel = cafeModel {
            cafeModel.documents?.forEach({ resultModel.append($0) })
        }
        didFinishRequest?()
    }

    private func requestBlog(query: String, completion: DispatchLeave) {
//        NetworkAdapter.request(target: SearchAPI.searchBlog(query: query, page: page)) { response in
//            do {
//                self.blogModel = try JSONDecoder().decode(SearchResultModel.self, from: response.data)
//                completion?()
//            } catch {
//                print("‼️", error)
//                completion?()
//            }
//        } error: { error in
//            print("‼️", error)
//            completion?()
//        } failure: { failError in
//            print("‼️", failError)
//            completion?()
//        }
    }

    private func requestCafe(query: String, completion: DispatchLeave) {
//        NetworkAdapter.request(target: SearchAPI.searchCafe(query: query, page: page)) { response in
//            do {
//                self.cafeModel = try JSONDecoder().decode(SearchResultModel.self, from: response.data)
//                completion?()
//            } catch {
//                print("‼️", error)
//                completion?()
//            }
//        } error: { error in
//            print("‼️", error)
//            completion?()
//        } failure: { failError in
//            print("‼️", failError)
//            completion?()
//        }
    }
}
