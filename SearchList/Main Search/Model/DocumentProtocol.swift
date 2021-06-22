//
//  DocumentProtocol.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/21.
//

import Foundation

protocol SearchModel {}

protocol Sortable {
    func isAscendingTo(_ object: Any) -> Bool
    func compare(ofTitle first: String?, _ second: String?) -> Bool

    func isRecentTo(_ object: Any) -> Bool
    func compare(ofDate first: String, _ second: String) -> Bool
}

extension Sortable {
    func compare(ofTitle first: String?, _ second: String?) -> Bool {
        guard let first = first, let second = second else { return false }

        var isAscending: Bool = false

        let length: Int = min(first.count, second.count)
        let firstChar = first.map({ $0 })
        let secondChar = second.map({ $0 })

        for index in 0..<length {
            if firstChar[index] == secondChar[index] { continue }
            isAscending = firstChar[index] > secondChar[index]
            break
        }

        return isAscending
    }

    func compare(ofDate first: String, _ second: String) -> Bool {
        guard let firstDate = first.toDate, let secondDate = second.toDate else { return false }
        return firstDate < secondDate
    }
}

protocol Document: Sortable {
    var title: String { get set }
    var thumbnail: String { get set }
    var contents: String { get set }
    var datetime: String { get set }
    var url: String { get set }
    var parsedTitle: String? { get set }
    var name: String? { get }
    var type: SearchTargetType { get }
    var isSelected: Bool { get set }
}

extension Document {
    func isAscendingTo(_ object: Any) -> Bool {
        var isAscending: Bool = false

        if let cafe = object as? CafeDocument {
            isAscending = compare(ofTitle: cafe.parsedTitle, self.parsedTitle)
        } else if let blog = object as? BlogDocument {
            isAscending = compare(ofTitle: blog.parsedTitle, self.parsedTitle)
        }

        return isAscending
    }

    func isRecentTo(_ object: Any) -> Bool {
        var isRecent: Bool = false

        if let cafe = object as? CafeDocument {
            isRecent = compare(ofDate: cafe.datetime, self.datetime)
        } else if let blog = object as? BlogDocument {
            isRecent = compare(ofDate: blog.datetime, self.datetime)
        }

        return isRecent
    }
}
