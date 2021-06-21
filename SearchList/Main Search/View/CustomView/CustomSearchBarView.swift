//
//  CustomSearchBarView.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/19.
//

import UIKit

final class CustomSearchBarView: UIView {

    private let xibName = "CustomSearchBarView"

    @IBOutlet weak var searchBar: UISearchBar!

    var delegate: SearchHistoryDelegate?

    var searchKeyword: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        initNotification()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initNotification()
    }

    private func commonInit() {
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        addSubview(view)
    }

    private func initNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleHistorySelection(_:)), name: .historyKeywordSelected, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .historyKeywordSelected, object: nil)
    }

    @objc func handleHistorySelection(_ notification: Notification) {
        guard let keyword = notification.object as? String else { return }
        searchBar.text = keyword
        searchKeyword?(keyword)
        delegate?.searchButtonClicked(by: keyword)
    }
}

extension CustomSearchBarView: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.text = nil
        delegate?.searchBegin()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        searchKeyword?(keyword)
        delegate?.searchButtonClicked(by: keyword)
    }
}

