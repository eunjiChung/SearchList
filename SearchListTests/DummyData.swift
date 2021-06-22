//
//  DummyData.swift
//  SearchListTests
//
//  Created by chungeunji on 2021/06/22.
//

import Foundation

let givenDocuments: [DummyDocument] = [
    DummyDocument(title: "<b>아이유</b>도 보고 써니힐도 본 귀신은 ㅁㅁ을 돌려", datetime: "2021-06-22T17:50:56.000+09:00"),
    DummyDocument(title: "죽기 전에 봐야 되는 <b>아이유</b> 직캠 추천 해주라", datetime: "2021-06-22T17:50:56.000+09:00"),
    DummyDocument(title: "느그 아부지 뭐하시노? 대처법 (feat.나의 아저씨)", datetime: "2021-06-22T17:50:56.000+09:00"),
    DummyDocument(title: "웨이브 <b>아이유</b> 배경화면", datetime: "2021-06-22T17:50:56.000+09:00"),
    DummyDocument(title: "여자 아이돌이 쓰는 향수 정보 모음.jpg", datetime: "2021-06-22T17:50:56.000+09:00"),
    DummyDocument(title: "중증 아토피였는데, 완치됨요 (긴글)", datetime: "2021-06-22T17:50:56.000+09:00")
]

let expectedDocs: [DummyDocument] = [
    DummyDocument(title: "느그 아부지 뭐하시노? 대처법 (feat.나의 아저씨)", datetime: "2021-06-22T17:50:56.000+09:00"),
    DummyDocument(title: "아이유도 보고 써니힐도 본 귀신은 ㅁㅁ을 돌려", datetime: "2021-06-22T17:50:56.000+09:00"),
    DummyDocument(title: "여자 아이돌이 쓰는 향수 정보 모음.jpg", datetime: "2021-06-22T17:50:56.000+09:00"),
    DummyDocument(title: "웨이브 아이유 배경화면", datetime: "2021-06-22T17:50:56.000+09:00"),
    DummyDocument(title: "죽기 전에 봐야 되는 아이유 직캠 추천 해주라", datetime: "2021-06-22T17:50:56.000+09:00"),
    DummyDocument(title: "중증 아토피였는데, 완치됨요 (긴글)", datetime: "2021-06-22T17:50:56.000+09:00")
]

class DummyDocument: Document {
    var title: String

    var thumbnail: String = ""

    var contents: String = ""

    var datetime: String

    var url: String = ""

    var parsedTitle: String?

    var name: String?

    var type: SearchTargetType = .cafe

    var isSelected: Bool = false


    init(title: String, datetime: String) {
        self.title = title
        self.datetime = datetime
    }
}
