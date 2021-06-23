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

    @IBOutlet weak var filterListView: UIView!
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet var filterButtons: [UIButton]!
    @IBOutlet weak var filterViewTopConstraint: NSLayoutConstraint!

    var touchSortButton: (() -> Void)?
    var selectFilter: ((FilterType) -> Void)?

    var isFilterSelected: Bool = false

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
        filterListView.isHidden = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 2
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard isUserInteractionEnabled || !isHidden || alpha > 0.01 else { return nil }

        let touchRect = isFilterSelected ? bounds.insetBy(dx: 0, dy: -150) : bounds.inset(by: .zero)
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
        isFilterSelected = !isFilterSelected
        filterListView.isHidden = !isFilterSelected
    }

    @IBAction func selectFilter(_ sender: UIButton) {
        filterLabel.text = FilterType(rawValue: sender.tag)?.title
        selectFilter?(FilterType(rawValue: sender.tag) ?? .all)

        isFilterSelected = false
        filterListView.isHidden = true
    }

    @IBAction func touchSortButton(_ sender: Any) {
        touchSortButton?()
    }
}
