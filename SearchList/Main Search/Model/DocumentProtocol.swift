//
//  DocumentProtocol.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/21.
//

import Foundation

protocol SearchModel {}

protocol Document {
    var title: String { get set }
    var thumbnail: String { get set }
    var contents: String { get set }
    var datetime: String { get set }
    var url: String { get set }
    var name: String? { get }
    var type: SearchTargetType { get }
    var isSelected: Bool { get set }
}
