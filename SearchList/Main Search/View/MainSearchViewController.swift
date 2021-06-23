//
//  MainSearchViewController.swift
//  SearchList
//
//  Created by chungeunji on 2021/06/19.
//

import UIKit

final class MainSearchViewController: UIViewController {

    @IBOutlet weak var filterView: FilterView!
    @IBOutlet weak var searchHistoryView: SearchHistoryView!

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var filterViewHeightConstraint: NSLayoutConstraint!
    
    lazy var searchView: CustomSearchBarView = {
        let searchView = CustomSearchBarView()
        searchView.delegate = searchHistoryView
        return searchView
    }()

    var viewModel: SearchViewModel!

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
        tableView.estimatedRowHeight = 122.0

        searchView.searchKeyword = { [weak self] keyword in
            guard let self = self else { return }
            self.viewModel.query = keyword
            self.hideKeyboard()
        }

        filterView.selectFilter = { [weak self] type in
            guard let self = self else { return }
            self.viewModel.filter = type
        }
        filterView.touchSortButton = {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let titleButton = UIAlertAction(title: "Title", style: .default) { _ in self.viewModel.sort = .title }
            let dateButton = UIAlertAction(title: "Date", style: .default) { _ in self.viewModel.sort = .datetime }
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
        viewModel = SearchViewModel(delegate: self)
    }

    @objc func hideKeyboard() {
        searchView.endEditing(true)
    }
}

private extension MainSearchViewController {
    private func reloadTable(_ completion: (() -> Void)?) {
        DispatchQueue.main.async {
            self.emptyView.isHidden = !self.viewModel.isListEmpty

            if self.viewModel.isFirstPage {
                self.tableView.reloadData()
            } else {
                self.tableView.reloadRows(at: self.tableView.indexPathsForVisibleRows ?? [], with: .none)
            }

            if self.tableView.refreshControl?.isRefreshing ?? false {
                self.tableView.refreshControl?.endRefreshing()
            }

            self.scrollToTop()

            completion?()
        }
    }

    private func isLoadingPosition(of indexPath: IndexPath) -> Bool {
        return !viewModel.isEnd && indexPath.row == viewModel.rowCount-1
    }

    private func changeFilterView(_ isScrollDown: Bool) {
        guard !viewModel.isListEmpty else { return }
        if filterView.isHidden && isScrollDown { return }
        filterView.isHidden = isScrollDown
        filterViewHeightConstraint.constant = isScrollDown ? 0 : 50
    }
}

extension MainSearchViewController: SearchViewModelDelegate {
    func onFetchCompleted(with indexPaths: [IndexPath]?, completion: (() -> Void)?) {
        guard let newIndexPaths = indexPaths else {
            reloadTable { completion?() }
            return
        }

        DispatchQueue.main.async {
            self.tableView.performBatchUpdates {
                self.tableView.insertRows(at: newIndexPaths, with: .fade)
            } completion: { _ in
                if let visibleRows = self.tableView.indexPathsForVisibleRows {
                    let intersectionRows = Set(newIndexPaths).intersection(Set(visibleRows))
                    if intersectionRows.count > 0 {
                        self.tableView.reloadRows(at: Array(intersectionRows), with: .none)
                    }
                }
                completion?()
            }
        }
    }

    func onFetchFailed(completion: (() -> Void)?) {
        let alert = UIAlertController(title: "알림", message: "데이터 가져오기에 실패했습니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)

        completion?()
    }

    func onFilterChanged() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.scrollToTop()
        }
    }

    private func scrollToTop() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            if !self.viewModel.isListEmpty {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        })
    }
}

extension MainSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoadingPosition(of: indexPath) {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.id, for: indexPath) as! LoadingTableViewCell
            cell.startLoading()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id, for: indexPath) as! SearchTableViewCell
            cell.model = viewModel.exposingList[indexPath.row]
            return cell
        }
    }
}

extension MainSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectList(indexPath.row) {
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        performSegue(withIdentifier: "showDetail", sender: viewModel.exposingList[indexPath.row])
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchHistoryView.isHidden = true
        filterView.filterListView.isHidden = true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY: CGFloat = scrollView.contentOffset.y
        let isScrollDown: Bool = scrollView.panGestureRecognizer.translation(in: scrollView).y < 0
        let isLoadingPosition: Bool = (contentOffsetY + scrollView.frame.size.height) >= scrollView.contentSize.height

        if contentOffsetY > 50 || contentOffsetY < (scrollView.frame.size.height - 50) {
            changeFilterView(isScrollDown)
        }

        if isLoadingPosition {
            viewModel.loadNextPage()
        }
    }
}

extension MainSearchViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showDetail" else { return }

        if let dest = segue.destination as? SearchDetailViewController,
           let model = sender as? Document {
            dest.viewModel.documentModel = model
        }
    }
}
