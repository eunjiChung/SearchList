//
//  FilterView.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/19.
//

import UIKit

enum FilterButtonType: Int {
    case all = 0
    case blog
    case cafe

    var title: String {
        switch self {
        case .all:      return "ALL"
        case .blog:     return "BLOG"
        case .cafe:     return "CAFE"
        }
    }
}

final class FilterView: UIView {

    private let xibName = "FilterView"

    @IBOutlet weak var currentFilterButton: UIButton!
    @IBOutlet weak var filterListView: UIView!
    @IBOutlet var filterButtons: [UIButton]!
    @IBOutlet weak var filterViewTopConstraint: NSLayoutConstraint!

    var touchSortButton: (() -> Void)?
    var selectFilter: ((FilterButtonType) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        initView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        initView()
    }

    private func commonInit() {
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        addSubview(view)
    }

    private func initView() {
    }

    @IBAction func touchFilterButton(_ sender: UIButton) {

    }

    @IBAction func selectFilter(_ sender: UIButton) {
        currentFilterButton.setTitle(FilterButtonType(rawValue: sender.tag)?.title, for: .normal)
        selectFilter?(FilterButtonType(rawValue: sender.tag) ?? .all)
    }

    @IBAction func touchSortButton(_ sender: Any) {
        touchSortButton?()
    }
}
