//
//  MainSearchViewController.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/19.
//

import UIKit

class MainSearchViewController: UIViewController {

    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!

    let searchView = CustomSearchBarView()

    lazy var customFilterView = {
        return FilterView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: filterView.frame.height))
    }()

    var scrollOffsetY: CGFloat = 0 {
        didSet {
            guard scrollOffsetY > 50 else { return }
            changeFilterView(oldValue < scrollOffsetY)
        }
    }

    var newViewModel: SearchViewModel!

    private lazy var emptyView: EmptyView = {
        let emptyView = EmptyView(frame: tableView.bounds)
        emptyView.isHidden = false
        return emptyView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initViewModel()
    }

    private func initView() {
        navigationItem.titleView = searchView
        tableView.backgroundView = emptyView
        filterView.addSubview(customFilterView)

        searchView.searchKeyword = { [weak self] keyword in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.hideKeyboard()
        }

        customFilterView.selectFilter = { [weak self] type in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
        customFilterView.touchSortButton = {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let titleButton = UIAlertAction(title: "Title", style: .default) { _ in
                self.tableView.reloadData()
            }
            let dateButton = UIAlertAction(title: "Date", style: .default) { _ in
                self.tableView.reloadData()
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(titleButton)
            alert.addAction(dateButton)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)
    }

    private func initViewModel() {
        newViewModel = SearchViewModel(delegate: self)
        newViewModel.query = "아이유"

        newViewModel.request()
    }

    @objc func hideKeyboard() {
        searchView.endEditing(true)
    }

    private func changeFilterView(_ isScrollDown: Bool) {
        if filterView.isHidden && isScrollDown { return }
        filterView.isHidden = isScrollDown
        filterViewHeightConstraint.constant = isScrollDown ? 0 : 50
    }

    private func reload() {
        DispatchQueue.main.async {
            self.emptyView.isHidden = self.newViewModel.list.count > 0
            self.tableView.reloadData()
        }
    }
}

extension MainSearchViewController: SearchViewModelDelegate {
    func onFetchCompleted() {
        reload()
    }

    func onFetchFailed() {

    }
}


extension MainSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newViewModel.list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id, for: indexPath) as! SearchTableViewCell
        cell.model = newViewModel.list[indexPath.row]
        return cell
    }
}


extension MainSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: newViewModel.list[indexPath.row])
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY: CGFloat = scrollView.contentOffset.y
        scrollOffsetY = contentOffsetY
    }
}

extension MainSearchViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? SearchDetailViewController,
           let model = sender as? DocumentModel {
            dest.viewModel.documentModel = model
        }
    }
}
