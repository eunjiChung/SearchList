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
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        addSubview(view)
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


