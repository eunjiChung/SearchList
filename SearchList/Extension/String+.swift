//
//  String+.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/19.
//

import Foundation

extension String {
    func htmlToAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }

    var toMainDate: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXX"
        guard let givenDate = dateFormatter.date(from: self) else { return nil }

        if givenDate.isToday {
            return "오늘"
        } else if givenDate.isYesterday {
            return "어제"
        } else {
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
            return dateFormatter.string(from: givenDate)
        }
    }

    var toDetailDate: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXX"
        guard let givenDate = dateFormatter.date(from: self) else { return nil }
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 a HH시 mm분"
        dateFormatter.locale = Locale(identifier:"ko_KR")
        return dateFormatter.string(from: givenDate)
    }
}

extension Date {
    var isToday: Bool {
        let currentCalendar = Calendar.current
        let todayOfStart = currentCalendar.startOfDay(for: Date())
        let dayOfStart = currentCalendar.startOfDay(for: self)
        let dateComponents = Calendar.current.dateComponents([.day], from: todayOfStart, to: dayOfStart)
        return dateComponents.day == 0
    }

    var isYesterday: Bool {
        let currentCalendar = Calendar.current
        let todayOfStart = currentCalendar.startOfDay(for: Date())
        let dayOfStart = currentCalendar.startOfDay(for: self)
        let dateComponents = Calendar.current.dateComponents([.day], from: todayOfStart, to: dayOfStart)
        return dateComponents.day == -1
    }
}
