//
//  FilterView.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/19.
//

import UIKit

enum FilterType: Int {
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

enum SortType {
    case title
    case datetime
}

final class FilterView: UIView {

    private let xibName = "FilterView"

    @IBOutlet weak var currentFilterButton: UIButton!
    @IBOutlet weak var filterListView: UIView!

    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var blogButton: UIButton!
    @IBOutlet weak var cafeButton: UIButton!

    @IBOutlet var filterButtons: [UIButton]!
    @IBOutlet weak var filterViewTopConstraint: NSLayoutConstraint!

    var touchSortButton: (() -> Void)?
    var selectFilter: ((FilterType) -> Void)?

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
        currentFilterButton.isSelected = false
        filterListView.isHidden = true
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard isUserInteractionEnabled || !isHidden || alpha > 0.01 else { return nil }

        let touchRect = currentFilterButton.isSelected ? bounds.insetBy(dx: 0, dy: -150) : bounds.inset(by: .zero)
        guard touchRect.contains(point) else { return nil }

        for button in filterButtons {
            let buttonPoint = self.convert(point, to: button)
            if button.point(inside: buttonPoint, with: event) {
                return button
            }
        }

        return super.hitTest(point, with: event)
    }

    @IBAction func touchFilterButton(_ sender: UIButton) {
        currentFilterButton.isSelected = !currentFilterButton.isSelected
        filterListView.isHidden = !sender.isSelected
    }

    @IBAction func selectFilter(_ sender: UIButton) {
        currentFilterButton.setTitle(FilterType(rawValue: sender.tag)?.title, for: .normal)
        selectFilter?(FilterType(rawValue: sender.tag) ?? .all)
        filterListView.isHidden = true
    }

    @IBAction func touchSortButton(_ sender: Any) {
        touchSortButton?()
    }
}
