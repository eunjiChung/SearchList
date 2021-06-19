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
        filterListView.isHidden = true
    }

    // 터치 영역 넓히기
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard isUserInteractionEnabled || !isHidden || alpha > 0.01 else { return nil }

        let touchRect = currentFilterButton.isSelected ? bounds.insetBy(dx: 0, dy: -200) : bounds.inset(by: .zero)
        guard touchRect.contains(point) else { return nil }

        for subview in subviews.reversed() {
            let convertedPoint = subview.convert(point, from: self)
            if let hitTestView = subview.hitTest(convertedPoint, with: event) {
                return hitTestView
            }
        }
        return self
    }

    @IBAction func touchFilterButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        filterListView.isHidden = !sender.isSelected
    }

    @IBAction func selectFilter(_ sender: UIButton) {
        currentFilterButton.setTitle(FilterButtonType(rawValue: sender.tag)?.title, for: .normal)
        selectFilter?(FilterButtonType(rawValue: sender.tag) ?? .all)
        filterListView.isHidden = true
    }

    @IBAction func touchSortButton(_ sender: Any) {
        touchSortButton?()
    }
}
