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
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var historyViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!

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
        tableView.dataSource = self
        tableView.delegate = self
    }
}


extension CustomSearchBarView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}


extension CustomSearchBarView: UITableViewDelegate {

}

