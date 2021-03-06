//
//  EmptyView.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/19.
//

import UIKit

final class EmptyView: UIView {

    private let xibName = "EmptyView"

    @IBOutlet weak var contentLabel: UILabel!

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

    func showEmptyView() {
        contentLabel.text = "검색 결과가 없습니다"
    }
}
