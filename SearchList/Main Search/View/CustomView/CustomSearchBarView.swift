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
    @IBOutlet weak var tableView: UITableView!

    var searchHistory: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    var searchKeyword: ((String) -> Void)?

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
        historyView.isHidden = true

        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UINib(nibName: HistoryTableViewCell.id, bundle: nil), forCellReuseIdentifier: HistoryTableViewCell.id)
    }
}

extension CustomSearchBarView: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        historyView.isHidden = searchHistory.isEmpty
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        historyView.isHidden = true

        if let keyword = searchBar.text {
            searchHistory.append(keyword)
            searchKeyword?(keyword)
        }
    }
}

extension CustomSearchBarView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.id, for: indexPath) as? HistoryTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = searchHistory[indexPath.row]
        return cell
    }
}


extension CustomSearchBarView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchKeyword?(searchHistory[indexPath.row])
    }
}


