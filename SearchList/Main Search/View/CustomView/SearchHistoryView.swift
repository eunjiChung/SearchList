//
//  SearchHistoryView.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/22.
//

import UIKit

protocol SearchHistoryDelegate {
    func searchBegin()
    func searchButtonClicked(by keyword: String)
}

extension Notification.Name {
    static let historyKeywordSelected = Notification.Name("historyKeywordSelected")
}

final class SearchHistoryView: UIView {

    private let xibName = "SearchHistoryView"

    @IBOutlet weak var tableView: UITableView!

    var searchHistory: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }

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
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 5

        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UINib(nibName: HistoryTableViewCell.id, bundle: nil), forCellReuseIdentifier: HistoryTableViewCell.id)
    }
}

extension SearchHistoryView: SearchHistoryDelegate {
    func searchBegin() {
        self.isHidden = searchHistory.isEmpty
    }

    func searchButtonClicked(by keyword: String) {
        if let index = searchHistory.firstIndex(of: keyword) {
            searchHistory.remove(at: index)
        }
        searchHistory.insert(keyword, at: searchHistory.startIndex)
        self.isHidden = true
    }
}

extension SearchHistoryView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.id, for: indexPath) as! HistoryTableViewCell
        cell.titleLabel.text = searchHistory[indexPath.row]
        return cell
    }
}

extension SearchHistoryView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: .historyKeywordSelected, object: searchHistory[indexPath.row])
    }
}

